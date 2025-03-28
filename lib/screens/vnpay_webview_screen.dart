import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:gotta_go/models/vnpay_payment_result.dart';
import 'package:gotta_go/services/vnpay_services.dart';
import 'package:gotta_go/constants/vnpay_constants.dart';

class VNPayWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String returnUrl;
  final Function(VNPayPaymentResult) onPaymentComplete;

  const VNPayWebViewScreen({
    Key? key,
    required this.paymentUrl,
    required this.returnUrl,
    required this.onPaymentComplete,
  }) : super(key: key);

  @override
  State<VNPayWebViewScreen> createState() => _VNPayWebViewScreenState();
}

class _VNPayWebViewScreenState extends State<VNPayWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  Timer? _timeoutTimer;
  
  @override
  void initState() {
    super.initState();
    _initWebView();
    
    // Thiết lập bộ đếm thời gian chờ (timeout)
    _timeoutTimer = Timer(const Duration(minutes: VNPayConstants.webViewTimeout), () {
      if (mounted) {
        final result = VNPayPaymentResult(
          isSuccess: false,
          responseCode: 'TIMEOUT',
          message: 'Phiên thanh toán đã hết hạn',
        );
        widget.onPaymentComplete(result);
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            // Kiểm tra nếu URL là return URL
            if (url.startsWith(widget.returnUrl)) {
              _handlePaymentResult(url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handlePaymentResult(String url) {
    // Hủy bộ đếm thời gian chờ
    _timeoutTimer?.cancel();
    
    // Phân tích tham số từ URL
    final params = VNPayService.parseCallbackUrl(url);
    
    // Xử lý kết quả thanh toán
    final result = VNPayService.processPaymentResult(params);
    
    // Gọi callback để thông báo kết quả
    widget.onPaymentComplete(result);
    
    // Đóng màn hình WebView
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Hiển thị hộp thoại xác nhận khi người dùng nhấn nút back
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Hủy thanh toán?'),
              content: const Text('Bạn có chắc muốn hủy quá trình thanh toán không?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Không'),
                ),
                TextButton(
                  onPressed: () {
                    final result = VNPayPaymentResult(
                      isSuccess: false,
                      responseCode: 'CANCELLED',
                      message: 'Thanh toán đã bị hủy',
                    );
                    widget.onPaymentComplete(result);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Có'),
                ),
              ],
            );
          },
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thanh toán VNPAY'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final shouldClose = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Hủy thanh toán?'),
                    content: const Text('Bạn có chắc muốn hủy quá trình thanh toán không?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Không'),
                      ),
                      TextButton(
                        onPressed: () {
                          final result = VNPayPaymentResult(
                            isSuccess: false,
                            responseCode: 'CANCELLED',
                            message: 'Thanh toán đã bị hủy',
                          );
                          widget.onPaymentComplete(result);
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Có'),
                      ),
                    ],
                  );
                },
              );
              if (shouldClose ?? false) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
} 