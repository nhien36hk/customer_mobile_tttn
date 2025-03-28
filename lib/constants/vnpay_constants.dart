/// Các hằng số liên quan đến thanh toán VNPAY
class VNPayConstants {
  /// Host URL cho môi trường sandbox
  static const String sandboxHost = 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html';
  
  /// Host URL cho môi trường production
  static const String productionHost = 'https://pay.vnpay.vn/vpcpay.html';
  
  /// Phiên bản API VNPAY
  static const String version = '2.1.0';
  
  /// Lệnh thanh toán
  static const String command = 'pay';
  
  /// Mã tiền tệ (VND)
  static const String currencyCode = 'VND';
  
  /// Ngôn ngữ giao diện
  static const String locale = 'vn';
  
  /// Thời gian hết hạn giao dịch (phút)
  static const int transactionTimeout = 15;
  
  /// Thời gian timeout cho WebView (phút)
  static const int webViewTimeout = 5;
  
  /// Mã danh mục hàng hóa
  static const String orderType = 'billpayment';
  
  /// URL trả về cho môi trường sandbox
  static const String sandboxReturnUrl = 'https://sandbox.vnpayment.vn/return_url';
  
  /// URL trả về cho môi trường production
  static const String productionReturnUrl = 'https://your-domain.com/vnpay/return';
  
  /// Mã phản hồi thành công
  static const String successResponseCode = '00';
  
  /// Mã phản hồi giao dịch đã tồn tại
  static const String duplicateTransactionCode = '02';
  
  /// Mã phản hồi giao dịch không tồn tại
  static const String transactionNotFoundCode = '01';
  
  /// Mã phản hồi sai chữ ký
  static const String invalidSignatureCode = '97';
  
  /// Mã phản hồi sai thông tin giao dịch
  static const String invalidTransactionInfoCode = '99';
} 