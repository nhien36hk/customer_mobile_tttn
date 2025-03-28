import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:gotta_go/models/vnpay_payment_result.dart';
import 'package:gotta_go/constants/vnpay_constants.dart';

class VNPayService {
  // Thay thế với TMN code và HashSecret thực tế của bạn
  static const String _tmnCode = 'RGZKVRYS';
  static const String _hashSecret = '7OTU09BJ5GQ302LU1QXJV1CJVUIG8OMD';

  /// Tạo URL thanh toán VNPAY với các tham số bắt buộc
  ///
  /// [amount]: Số tiền thanh toán (đã nhân 100 để loại bỏ phần thập phân)
  /// [orderInfo]: Thông tin mô tả nội dung thanh toán
  /// [orderType]: Mã danh mục hàng hóa
  /// [returnUrl]: URL thông báo kết quả giao dịch khi khách hàng kết thúc thanh toán
  /// [ipAddress]: Địa chỉ IP của khách hàng
  /// [bankCode]: Mã ngân hàng (tùy chọn)
  static String createPaymentUrl({
    required int amount,
    required String orderInfo,
    required String orderType,
    required String returnUrl,
    required String ipAddress,
    String? bankCode,
  }) {
    // Tạo mã giao dịch duy nhất
    final DateTime now = DateTime.now();
    final String createDate = DateFormat('yyyyMMddHHmmss').format(now);
    final String orderId = DateFormat('yyyyMMddHHmmss').format(now);

    // Tạo thời gian hết hạn
    final DateTime expireTime =
        now.add(const Duration(minutes: VNPayConstants.transactionTimeout));
    final String expireDate = DateFormat('yyyyMMddHHmmss').format(expireTime);

    // Tạo các tham số thanh toán
    final Map<String, String> vnpParams = {
      'vnp_Version': VNPayConstants.version,
      'vnp_Command': VNPayConstants.command,
      'vnp_TmnCode': _tmnCode,
      'vnp_Amount': amount.toString(),
      'vnp_CreateDate': createDate,
      'vnp_CurrCode': VNPayConstants.currencyCode,
      'vnp_IpAddr': ipAddress,
      'vnp_Locale': VNPayConstants.locale,
      'vnp_OrderInfo': orderInfo,
      'vnp_OrderType': orderType,
      'vnp_ReturnUrl': returnUrl,
      'vnp_TxnRef': orderId,
      'vnp_ExpireDate': expireDate,
    };

    // Thêm mã ngân hàng nếu được chỉ định
    if (bankCode != null && bankCode.isNotEmpty) {
      vnpParams['vnp_BankCode'] = bankCode;
    }

    // Loại bỏ các tham số rỗng hoặc null
    vnpParams.removeWhere((key, value) => value.isEmpty);

    // Sắp xếp tham số theo đúng cách của VNPAY
    Map<String, String> sortedParams = sortVnPayParams(vnpParams);

    // Tạo chuỗi để tính HMAC-SHA512 (không encode ở đây như NodeJS)
    String hashData = createSignData(sortedParams);

    // Tạo HMAC-SHA512 hash
    final hmacSha512 = Hmac(sha512, utf8.encode(_hashSecret));
    final digest = hmacSha512.convert(utf8.encode(hashData));
    final secureHash = digest.toString();

    // Thêm chuỗi hash vào parameters
    sortedParams['vnp_SecureHash'] = secureHash;

    // Tạo URL thanh toán với query string không encode
    String queryString = '';
    sortedParams.forEach((key, value) {
      if (queryString.isNotEmpty) {
        queryString += '&';
      }
      queryString += '$key=$value';
    });

    print('http cuoi cung  ${VNPayConstants.sandboxHost}?$queryString');

    return '${VNPayConstants.sandboxHost}?$queryString';
  }

  /// Sắp xếp tham số theo đúng cách của VNPAY, giống như NodeJS
  static Map<String, String> sortVnPayParams(Map<String, String> params) {
    List<String> keys = params.keys.toList();
    keys.sort();

    Map<String, String> sortedParams = {};
    for (String key in keys) {
      // Thay thế khoảng trắng bằng dấu + sau khi encode, như NodeJS
      String encodedValue =
          Uri.encodeComponent(params[key]!).replaceAll('%20', '+');
      sortedParams[key] = encodedValue;
    }

    return sortedParams;
  }

  /// Tạo chuỗi để tính chữ ký không encode lại như NodeJS
  static String createSignData(Map<String, String> sortedParams) {
    String data = '';
    sortedParams.forEach((key, value) {
      if (data.isNotEmpty) {
        data += '&';
      }
      data += '$key=$value';
    });
    return data;
  }

  /// Kiểm tra tính toàn vẹn của dữ liệu trả về từ VNPAY
  ///
  /// [params]: Các tham số trả về từ VNPAY
  static bool validateResponse(Map<String, String> params) {
    if (!params.containsKey('vnp_SecureHash')) {
      return false;
    }

    final String secureHash = params['vnp_SecureHash']!;
    final Map<String, String> validationParams = Map.from(params);

    // Loại bỏ vnp_SecureHash khỏi map để tính toán lại
    validationParams.remove('vnp_SecureHash');
    if (validationParams.containsKey('vnp_SecureHashType')) {
      validationParams.remove('vnp_SecureHashType');
    }

    // Sắp xếp tham số theo đúng cách của VNPAY
    Map<String, String> sortedParams = sortVnPayParams(validationParams);

    // Tạo chuỗi để tính HMAC-SHA512 (không encode lại)
    String hashData = createSignData(sortedParams);

    // Tạo HMAC-SHA512 hash
    final hmacSha512 = Hmac(sha512, utf8.encode(_hashSecret));
    final digest = hmacSha512.convert(utf8.encode(hashData));
    final calculatedHash = digest.toString();

    // So sánh hash tính toán với hash nhận được
    return secureHash == calculatedHash;
  }

  /// Phân tích chuỗi URL callback để lấy các tham số
  ///
  /// [url]: URL callback từ VNPAY
  static Map<String, String> parseCallbackUrl(String url) {
    final uri = Uri.parse(url);
    final Map<String, String> params = {};

    uri.queryParameters.forEach((key, value) {
      // Giữ nguyên giá trị không decode lại để đảm bảo chữ ký đúng
      params[key] = value;
    });

    return params;
  }

  /// Xử lý kết quả thanh toán từ VNPAY
  ///
  /// [params]: Các tham số trả về từ VNPAY
  static VNPayPaymentResult processPaymentResult(Map<String, String> params) {
    // Kiểm tra tính toàn vẹn của dữ liệu
    final bool isValid = validateResponse(params);

    if (!isValid) {
      return VNPayPaymentResult(
        isSuccess: false,
        responseCode: VNPayConstants.invalidSignatureCode,
        message: 'Dữ liệu không hợp lệ hoặc đã bị thay đổi',
      );
    }

    final String responseCode = params['vnp_ResponseCode'] ?? '';
    final String transactionNo = params['vnp_TransactionNo'] ?? '';
    final String amount = params['vnp_Amount'] ?? '0';
    final String orderInfo = params['vnp_OrderInfo'] ?? '';
    final String txnRef = params['vnp_TxnRef'] ?? '';
    final String payDate = params['vnp_PayDate'] ?? '';
    final String bankCode = params['vnp_BankCode'] ?? '';

    // Kiểm tra mã phản hồi
    bool isSuccess = responseCode == VNPayConstants.successResponseCode;
    String message = isSuccess
        ? 'Thanh toán thành công'
        : 'Thanh toán không thành công. Mã lỗi: $responseCode';

    return VNPayPaymentResult(
      isSuccess: isSuccess,
      responseCode: responseCode,
      message: message,
      transactionNo: transactionNo,
      amount: int.tryParse(amount) ?? 0,
      orderInfo: orderInfo,
      txnRef: txnRef,
      payDate: payDate,
      bankCode: bankCode,
    );
  }
}
