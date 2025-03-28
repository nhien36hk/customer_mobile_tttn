# Gotta Go - Ứng dụng đặt vé xe

Gotta Go là ứng dụng đặt vé xe trực tuyến giúp người dùng dễ dàng tìm kiếm, đặt vé và quản lý các chuyến đi. Ứng dụng được phát triển bằng Flutter, hỗ trợ đa nền tảng (Android, iOS, Web).

## Cấu trúc thư mục dự án

### Thư mục gốc

- `.dart_tool/`: Thư mục chứa công cụ phát triển Dart, được tạo tự động bởi Flutter.
- `.git/`: Thư mục Git quản lý phiên bản mã nguồn.
- `.idea/`: Cấu hình cho IDE IntelliJ IDEA/Android Studio.
- `android/`: Mã nguồn đặc thù cho nền tảng Android.
- `build/`: Thư mục chứa các tệp xây dựng tạm thời được tạo bởi Flutter build.
- `images/`: Thư mục chứa tất cả hình ảnh, biểu tượng và tài nguyên đồ họa.
- `ios/`: Mã nguồn đặc thù cho nền tảng iOS.
- `lib/`: Thư mục chính chứa mã nguồn Dart/Flutter của ứng dụng.
- `linux/`: Mã nguồn đặc thù cho nền tảng Linux.
- `macos/`: Mã nguồn đặc thù cho nền tảng macOS.
- `test/`: Thư mục chứa các tệp kiểm thử.
- `web/`: Mã nguồn đặc thù cho nền tảng Web.
- `windows/`: Mã nguồn đặc thù cho nền tảng Windows.
- `analysis_options.yaml`: Cấu hình cho trình phân tích Dart, giúp duy trì chất lượng mã nguồn.
- `pubspec.yaml`: Tệp cấu hình quản lý các phụ thuộc, tài nguyên và cài đặt của dự án.
- `pubspec.lock`: Tệp khóa phiên bản các phụ thuộc, đảm bảo tính nhất quán khi cài đặt.

### Thư mục `lib/` (Mã nguồn chính)

#### `main.dart`
Điểm khởi đầu của ứng dụng, định nghĩa hàm `main()` và Widget `MyApp` chính.

#### Thư mục `constants/`
Chứa các hằng số, biến cố định và giá trị được sử dụng xuyên suốt ứng dụng.

#### Thư mục `models/`
Chứa các lớp mô hình dữ liệu (data models), đại diện cho cấu trúc dữ liệu trong ứng dụng:

- `create_order_response.dart`: Mô hình dữ liệu phản hồi khi tạo đơn hàng mới.
- `route_model.dart`: Mô hình dữ liệu về tuyến đường.
- `schedule_model.dart`: Mô hình dữ liệu về lịch trình chuyến đi.
- `search_history_model.dart`: Mô hình lưu trữ lịch sử tìm kiếm.
- `seat_booking_model.dart`: Mô hình dữ liệu đặt chỗ ngồi.
- `seat_layout_model.dart`: Mô hình bố trí chỗ ngồi trên xe.
- `ticket_model.dart`: Mô hình dữ liệu vé xe.
- `trip_model.dart`: Mô hình dữ liệu chuyến đi.
- `user_model.dart`: Mô hình dữ liệu người dùng.
- `vnpay_payment_result.dart`: Mô hình kết quả thanh toán qua VNPay.

#### Thư mục `screens/`
Chứa các màn hình (UI) của ứng dụng:

- `booking_information.dart`: Màn hình thông tin đặt vé.
- `chose_location_screen.dart`: Màn hình chọn địa điểm.
- `chose_pay_method_screen.dart`: Màn hình chọn phương thức thanh toán.
- `date_selection_screen.dart`: Màn hình chọn ngày đi.
- `edit_profile_screen.dart`: Màn hình chỉnh sửa thông tin cá nhân.
- `home_screen.dart`: Màn hình chính/trang chủ.
- `login_screen.dart`: Màn hình đăng nhập.
- `main_screen.dart`: Màn hình chính sau khi đăng nhập (điều hướng).
- `notification_screen.dart`: Màn hình thông báo.
- `profile_screen.dart`: Màn hình thông tin cá nhân.
- `register_screen.dart`: Màn hình đăng ký tài khoản.
- `search_location_screen.dart`: Màn hình tìm kiếm địa điểm.
- `search_trip_screen.dart`: Màn hình tìm kiếm chuyến đi.
- `seat_selection_screen.dart`: Màn hình chọn chỗ ngồi.
- `splash_screen.dart`: Màn hình chào mừng khi khởi động.
- `ticket_detail_screen.dart`: Màn hình chi tiết vé.
- `ticket_list_screen.dart`: Màn hình danh sách vé đã đặt.
- `ticket_seat_screen.dart`: Màn hình hiển thị thông tin chỗ ngồi của vé.
- `vnpay_webview_screen.dart`: Màn hình WebView thanh toán VNPay.

#### Thư mục `services/`
Chứa các dịch vụ giao tiếp với API, cơ sở dữ liệu và xử lý logic nghiệp vụ:

- `booking_services.dart`: Dịch vụ quản lý đặt vé.
- `bus_services.dart`: Dịch vụ quản lý thông tin xe buýt/xe khách.
- `popular_routes_service.dart`: Dịch vụ quản lý các tuyến đường phổ biến.
- `search_history_service.dart`: Dịch vụ quản lý lịch sử tìm kiếm.
- `ticket_service.dart`: Dịch vụ quản lý vé.
- `user_services.dart`: Dịch vụ quản lý thông tin người dùng.
- `vnpay_services.dart`: Dịch vụ thanh toán qua VNPay.

#### Thư mục `provider/`
Chứa các lớp provider phục vụ quản lý trạng thái (state management) của ứng dụng.

#### Thư mục `theme/`
Chứa cấu hình giao diện, chủ đề, màu sắc và phong cách của ứng dụng.

#### Thư mục `utils/`
Chứa các tiện ích, hàm trợ giúp và công cụ sử dụng xuyên suốt ứng dụng.

#### Thư mục `widgets/`
Chứa các widget tái sử dụng trong nhiều màn hình:

- `bottom_navigation_widget.dart`: Widget thanh điều hướng dưới cùng.
- `gradient_background.dart`: Widget nền gradient.
- `gradient_button.dart`: Widget nút có nền gradient.
- `label_text_widget.dart`: Widget nhãn văn bản.
- `loading_widget.dart`: Widget hiển thị trạng thái đang tải.
- `method_pay_widget.dart`: Widget phương thức thanh toán.
- `modern_card.dart`: Widget thẻ hiện đại.
- `password_input_widget.dart`: Widget nhập mật khẩu.
- `search_history_widget.dart`: Widget hiển thị lịch sử tìm kiếm.
- `show_result_pay_widget.dart`: Widget hiển thị kết quả thanh toán.
- `text_input_widget.dart`: Widget nhập văn bản.
- `warning_widget.dart`: Widget cảnh báo.

## Quy trình làm việc

1. **Khởi động ứng dụng**: Qua `splash_screen.dart`
2. **Xác thực người dùng**: `login_screen.dart`, `register_screen.dart`
3. **Màn hình chính**: `main_screen.dart` điều hướng đến các màn hình:
   - Trang chủ: `home_screen.dart`
   - Đặt vé:
     - Tìm địa điểm: `chose_location_screen.dart`, `search_location_screen.dart`
     - Chọn ngày: `date_selection_screen.dart`
     - Tìm chuyến đi: `search_trip_screen.dart`
     - Chọn chỗ ngồi: `seat_selection_screen.dart`
     - Thông tin đặt vé: `booking_information.dart`
     - Chọn phương thức thanh toán: `chose_pay_method_screen.dart`
     - Thanh toán VNPay: `vnpay_webview_screen.dart`
   - Vé của tôi: `ticket_list_screen.dart`, `ticket_detail_screen.dart`
   - Thông báo: `notification_screen.dart`
   - Hồ sơ: `profile_screen.dart`, `edit_profile_screen.dart`

## Cài đặt và phát triển

1. Sao chép mã nguồn:
   ```bash
   git clone <link-repository>
   ```

2. Cài đặt các phụ thuộc:
   ```bash
   flutter pub get
   ```

3. Chạy ứng dụng:
   ```bash
   flutter run
   ```

## Triển khai

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```
