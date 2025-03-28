# Kế hoạch triển khai thanh toán VNPAY không sử dụng thư viện

## Tổng quan
Dự án này tập trung vào việc tích hợp thanh toán VNPAY vào ứng dụng Gotta Go mà không sử dụng thư viện vnpay_flutter để tránh lỗi sai chữ ký (SecureHash) và các vấn đề liên quan.

## Danh sách công việc

### 1. Tạo dịch vụ thanh toán VNPAY trực tiếp
- [] Tạo file service mới cho VNPAY (VNPayService)
- [] Tạo hàm tạo URL thanh toán với các tham số bắt buộc
- [] Triển khai logic tạo chuỗi hash SHA-256/HMAC-SHA512
- [] Triển khai cơ chế kiểm tra kết quả từ VNPAY

### 2. Tạo giao diện webview cho thanh toán
- [] Tích hợp thư viện webview (webview_flutter)
- [] Tạo màn hình WebViewScreen để hiển thị trang thanh toán VNPAY
- [] Xử lý sự kiện redirect URL khi thanh toán hoàn tất hoặc bị hủy
- [] Thêm cơ chế xử lý loading state

### 3. Xử lý kết quả thanh toán
- [] Phân tích URL callback từ VNPAY
- [] Kiểm tra tính toàn vẹn của dữ liệu (validate hash)
- [] Tạo mô hình kết quả thanh toán (VNPayPaymentResult)
- [] Triển khai xử lý các trường hợp thành công, thất bại và hủy bỏ

### 4. Tích hợp với logic đặt vé hiện tại
- [] Cập nhật BookingServices để sử dụng phương thức thanh toán mới
- [] Xử lý lưu vé sau khi thanh toán thành công
- [] Cập nhật logic hiển thị thông báo kết quả

### 5. Kiểm thử và xử lý lỗi
- [] Kiểm thử quy trình thanh toán đầy đủ
- [] Triển khai xử lý timeout và các trường hợp lỗi
- [] Thêm logging để theo dõi quá trình thanh toán
- [] Tối ưu trải nghiệm người dùng khi có lỗi xảy ra

### 6. Sửa lỗi và tối ưu hóa
- [] Sửa lỗi sai chữ ký (SecureHash) sử dụng cách mã hóa URL đúng
- [] Thêm tính năng loại bỏ tham số rỗng/null trước khi tạo hash
- [] Cải thiện logging để dễ dàng gỡ lỗi

## Công nghệ sử dụng
- **Flutter**: UI và logic chính
- **webview_flutter**: Hiển thị trang thanh toán VNPAY
- **crypto**: Tạo mã hash cho chuỗi dữ liệu
- **http**: Tương tác với API nếu cần
- **url_launcher**: Trường hợp dự phòng nếu cần mở trình duyệt ngoài

## Lưu ý quan trọng
- Đảm bảo định dạng chính xác cho các tham số (đúng kiểu dữ liệu và giới hạn độ dài)
- Sắp xếp các tham số theo thứ tự alphabet trước khi tạo hash
- **Sử dụng Uri.queryParameters để tự động mã hóa URL trước khi tạo hash**
- **Loại bỏ tham số rỗng/null trước khi tạo hash**
- Xử lý mã hóa URL đúng cách với các ký tự đặc biệt
- Kiểm tra kỹ các giá trị thời gian và số tiền để đảm bảo đúng định dạng
- Lưu ý rằng số tiền gửi đến VNPAY cần phải nhân với 100 (để loại bỏ phần thập phân)