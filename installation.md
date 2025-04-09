# Hướng dẫn cài đặt và chạy ứng dụng Quản lý Thư viện Sách

## Yêu cầu hệ thống

- Flutter SDK 3.0.0 hoặc cao hơn
- Dart SDK 2.17.0 hoặc cao hơn
- MongoDB Community Edition 5.0 hoặc cao hơn (hoặc MongoDB Atlas)
- Android Studio / VS Code
- Git

## Các bước cài đặt

### 1. Cài đặt Flutter

- Tải Flutter SDK từ [flutter.dev](https://flutter.dev/docs/get-started/install)
- Thêm Flutter vào PATH
- Chạy `flutter doctor` để kiểm tra cài đặt

### 2. Cài đặt MongoDB

#### Cài đặt MongoDB Community Edition (Local)

- Tải MongoDB Community Edition từ [mongodb.com](https://www.mongodb.com/try/download/community)
- Cài đặt MongoDB theo hướng dẫn
- Tạo thư mục dữ liệu: `mkdir -p /data/db` (Linux/macOS) hoặc `md C:\data\db` (Windows)
- Khởi động MongoDB: `mongod` (Linux/macOS) hoặc `C:\Program Files\MongoDB\Server\<version>\bin\mongod.exe` (Windows)

#### Hoặc sử dụng MongoDB Atlas (Cloud)

- Đăng ký tài khoản tại [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
- Tạo cluster miễn phí
- Cấu hình Network Access để cho phép IP của bạn kết nối
- Tạo Database User

### 3. Tải mã nguồn ứng dụng

```bash
git clone https://github.com/yourusername/library_management_app.git
cd library_management_app
```

### 4. Cài đặt các dependency

```bash
flutter pub get
```

### 5. Cấu hình kết nối MongoDB

Mở file `lib/services/mongodb_service.dart` và chỉnh sửa URI kết nối MongoDB:

```dart
// Kết nối MongoDB local
_db = await Db.create('mongodb://localhost:27017/library_db');

// Hoặc kết nối MongoDB Atlas
_db = await Db.create('mongodb+srv://<username>:<password>@<cluster-url>/library_db?retryWrites=true&w=majority');
```

### 6. Tạo dữ liệu mẫu

Chạy script tạo dữ liệu mẫu:

```bash
flutter run lib/tools/seed_data.dart
```

### 7. Chạy ứng dụng

```bash
flutter run
```

## Khắc phục sự cố

### Lỗi kết nối MongoDB

- Kiểm tra MongoDB đã chạy chưa
- Kiểm tra cấu hình firewall có chặn kết nối không
- Kiểm tra URI kết nối đúng không

### Lỗi Flutter

- Chạy `flutter doctor` để kiểm tra cài đặt
- Chạy `flutter clean` và `flutter pub get` để làm mới các dependency

## Cấu trúc dự án

```
library_management_app/
├── android/
├── ios/
├── lib/
│   ├── configs/
│   ├── models/
│   ├── repositories/
│   ├── screens/
│   ├── services/
│   ├── tools/
│   ├── widgets/
│   ├── main.dart
│   └── app.dart
├── test/
└── pubspec.yaml
```

## Hướng dẫn sử dụng

Sau khi chạy ứng dụng, bạn sẽ thấy màn hình chính với các tùy chọn:

1. **Quản lý Sách**: Quản lý danh sách sách
2. **Quản lý Thành viên**: Quản lý danh sách thành viên
3. **Quản lý Mượn/Trả sách**: Quản lý việc mượn và trả sách
4. **Thống kê và Báo cáo**: Xem các báo cáo thống kê

Bên cạnh đó, thanh điều hướng (Navigation Drawer) chứa các demo cho các phép toán đại số quan hệ.

## Các phép toán đại số quan hệ

Ứng dụng triển khai 11 phép toán đại số quan hệ:

1. Phép chọn (Selection)
2. Phép chiếu (Projection)
3. Tích Đề-các (Cartesian Product)
4. Phép trừ (Set Difference)
5. Phép hợp (Union)
6. Phép giao (Intersection)
7. Phép nối (Join)
8. Nối θ (θ-join)
9. Nối bằng (Equi-join)
10. Nối tự nhiên (Natural join)
11. Phép chia (Division)

Mỗi phép toán đều có màn hình demo riêng giúp hiểu rõ cách triển khai và ứng dụng vào thực tế. 