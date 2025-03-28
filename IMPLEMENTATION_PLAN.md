# Kế hoạch triển khai các chức năng mới cho ứng dụng Gotta Go

## Tổng quan
Dự án này là bản nâng cấp của ứng dụng đặt vé xe Gotta Go với các chức năng mới như cập nhật logic ghế, chia sẻ vé, lịch sử tìm kiếm, lộ trình phổ biến và cập nhật avatar.

## Danh sách công việc

### 1. Cập nhật logic ghế trong TicketSeatScreen
- [x] Phân tích logic ghế mới trong SeatSelectionScreen
- [x] Cập nhật TicketSeatScreen để phù hợp với logic mới (Tầng 1: A1-A12, Tầng 2: B1-B12)
- [x] Kiểm thử hiển thị và tương tác với ghế
- [x] Đảm bảo tính nhất quán với SeatSelectionScreen

### 2. Chức năng chia sẻ vé
- [x] Tích hợp thư viện chia sẻ (share_plus)
- [x] Tạo hàm chụp widget vé (sử dụng lại logic từ chức năng tải vé)
- [x] Thêm nút chia sẻ và xử lý sự kiện chia sẻ
- [x] Hỗ trợ chia sẻ qua các ứng dụng phổ biến (Zalo, Message)
- [x] Kiểm thử chức năng chia sẻ

### 3. Lịch sử tìm kiếm
- [x] Tạo model cho lịch sử tìm kiếm
- [x] Thêm service để lưu và quản lý lịch sử tìm kiếm
- [x] Cập nhật giao diện hiển thị lịch sử
- [x] Thêm chức năng xóa lịch sử
- [x] Tích hợp với chức năng tìm kiếm chuyến

### 4. Lộ trình phổ biến
- [x] Tạo service để lấy dữ liệu từ collection schedules
- [x] Thêm logic lấy ngẫu nhiên các lộ trình
- [x] Cập nhật giao diện hiển thị lộ trình
- [x] Thêm chức năng chuyển hướng đến SearchTripScreen
- [x] Kiểm thử hiển thị và tương tác

### 5. Cập nhật avatar
- [ ] Tích hợp thư viện image_picker
- [ ] Thêm chức năng chọn ảnh từ camera và gallery
- [ ] Tạo service upload ảnh lên Firebase Storage
- [ ] Cập nhật UI hiển thị avatar
- [ ] Thêm loading state khi upload
- [ ] Xử lý lỗi và thông báo

## Quy trình triển khai
1. Bắt đầu với việc cập nhật logic ghế vì đây là thay đổi cơ bản
2. Tiếp theo là chức năng chia sẻ vé vì có thể tận dụng logic chụp vé
3. Thêm lịch sử tìm kiếm để cải thiện trải nghiệm người dùng
4. Cập nhật lộ trình phổ biến để hiển thị dữ liệu thực
5. Cuối cùng là chức năng cập nhật avatar

## Công nghệ sử dụng
- **Flutter**: UI và logic
- **Firebase**: Lưu trữ dữ liệu và ảnh
- **Provider**: Quản lý state
- **Share Plus**: Chia sẻ
- **Image Picker**: Chọn ảnh

## Trạng thái dự án
- **Hoàn thành**: 80%
- **Đang thực hiện**: Chức năng cập nhật avatar

## Lưu ý quan trọng
- Đảm bảo tính nhất quán của dữ liệu giữa các màn hình
- Xử lý các trường hợp lỗi và hiển thị thông báo phù hợp
- Tối ưu hiệu suất khi xử lý ảnh và upload
- Đảm bảo UX mượt mà và thân thiện với người dùng 