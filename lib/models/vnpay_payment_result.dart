class VNPayPaymentResult {
  final bool isSuccess;
  final String responseCode;
  final String message;
  final String transactionNo;
  final int amount;
  final String orderInfo;
  final String txnRef;
  final String payDate;
  final String bankCode;

  VNPayPaymentResult({
    required this.isSuccess,
    required this.responseCode,
    required this.message,
    this.transactionNo = '',
    this.amount = 0,
    this.orderInfo = '',
    this.txnRef = '',
    this.payDate = '',
    this.bankCode = '',
  });

  /// Tạo một đối tượng VNPayPaymentResult từ dữ liệu JSON
  factory VNPayPaymentResult.fromJson(Map<String, dynamic> json) {
    return VNPayPaymentResult(
      isSuccess: json['isSuccess'] ?? false,
      responseCode: json['responseCode'] ?? '',
      message: json['message'] ?? '',
      transactionNo: json['transactionNo'] ?? '',
      amount: json['amount'] ?? 0,
      orderInfo: json['orderInfo'] ?? '',
      txnRef: json['txnRef'] ?? '',
      payDate: json['payDate'] ?? '',
      bankCode: json['bankCode'] ?? '',
    );
  }

  /// Chuyển đối tượng thành dữ liệu JSON
  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'responseCode': responseCode,
      'message': message,
      'transactionNo': transactionNo,
      'amount': amount,
      'orderInfo': orderInfo,
      'txnRef': txnRef,
      'payDate': payDate,
      'bankCode': bankCode,
    };
  }

  @override
  String toString() {
    return 'VNPayPaymentResult(isSuccess: $isSuccess, responseCode: $responseCode, message: $message, '
        'transactionNo: $transactionNo, amount: $amount, orderInfo: $orderInfo, txnRef: $txnRef, '
        'payDate: $payDate, bankCode: $bankCode)';
  }
} 