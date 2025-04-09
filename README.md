# Ứng Dụng Quản Lý Thư Viện Sách với Flutter và MongoDB

Ứng dụng này là một dự án nhỏ triển khai các phép toán đại số quan hệ trong MongoDB thông qua Flutter. Ứng dụng mô phỏng hệ thống quản lý thư viện sách, được thiết kế để minh họa tất cả 11 phép toán đại số quan hệ.

## Mục Lục

1. [Giới thiệu](#giới-thiệu)
2. [Thiết kế cơ sở dữ liệu](#thiết-kế-cơ-sở-dữ-liệu)
3. [Cài đặt và cấu hình](#cài-đặt-và-cấu-hình)
4. [Các phép toán đại số quan hệ](#các-phép-toán-đại-số-quan-hệ)
   - [Phép chọn (Selection - σ)](#1-phép-chọn-selection---σ)
   - [Phép chiếu (Projection - π)](#2-phép-chiếu-projection---π)
   - [Tích Đề-các (Cartesian Product - ×)](#3-tích-đề-các-cartesian-product---)
   - [Phép trừ (Set Difference - -)](#4-phép-trừ-set-difference---)
   - [Phép hợp (Union - ∪)](#5-phép-hợp-union---∪)
   - [Phép giao (Intersection - ∩)](#6-phép-giao-intersection---∩)
   - [Phép nối (Join - ⋈)](#7-phép-nối-join---⋈)
   - [Nối θ (θ-join)](#8-nối-θ-θ-join)
   - [Nối bằng (Equi-join)](#9-nối-bằng-equi-join)
   - [Nối tự nhiên (Natural join)](#10-nối-tự-nhiên-natural-join)
   - [Phép chia (Division - ÷)](#11-phép-chia-division---÷)
5. [Cấu trúc dự án](#cấu-trúc-dự-án)
6. [Giao diện người dùng](#giao-diện-người-dùng)
   - [Màn hình chính](#1-màn-hình-chính-home-screen)
   - [Quản lý Sách](#2-màn-hình-quản-lý-sách)
   - [Quản lý Thành viên](#3-màn-hình-quản-lý-thành-viên)
   - [Quản lý Mượn/Trả](#4-màn-hình-quản-lý-mượntrả)
   - [Phân tích Đọc sách](#5-màn-hình-phân-tích-đọc-sách)
   - [Báo cáo và Thống kê](#6-màn-hình-báo-cáo-và-thống-kê)
   - [Quản lý Thể loại và Tác giả](#7-màn-hình-quản-lý-thể-loại-và-tác-giả)
   - [Demo Phép toán Đại số Quan hệ](#8-màn-hình-demo-phép-toán-đại-số-quan-hệ)
7. [Triển khai chi tiết](#triển-khai-chi-tiết)
8. [Đóng gói và triển khai](#đóng-gói-và-triển-khai)
9. [Tài liệu tham khảo](#tài-liệu-tham-khảo)

## Giới thiệu

Ứng dụng Quản lý Thư viện Sách là một dự án minh họa cách áp dụng các phép toán đại số quan hệ trong cơ sở dữ liệu MongoDB. Dự án này không chỉ là một ứng dụng di động mà còn là một tài liệu học tập về cách triển khai các nguyên lý cơ sở dữ liệu quan hệ trong môi trường NoSQL.

Mục tiêu của dự án:
- Hiện thực hóa 11 phép toán đại số quan hệ trong MongoDB
- Xây dựng giao diện người dùng trực quan với Flutter
- Tạo ra một ứng dụng thực tế hữu ích cho việc quản lý thư viện sách
- Tích hợp các phép toán đại số quan hệ vào các chức năng thực tế của ứng dụng

Đặc điểm nổi bật:
1. **Tích hợp lý thuyết và thực hành**: Mỗi phép toán đại số quan hệ đều được ứng dụng vào một tính năng thực tế, giúp người học dễ dàng hiểu và áp dụng.
2. **Phân bố đều các phép toán**: Mỗi màn hình của ứng dụng được thiết kế để áp dụng nhiều phép toán khác nhau, tránh tập trung quá nhiều vào một vài phép toán.
3. **Trực quan hóa kết quả**: Kết quả của mỗi phép toán được hiển thị bằng giao diện trực quan, dễ hiểu cho người dùng.
4. **Ứng dụng thực tế**: Mỗi phép toán đều được giải thích trong ngữ cảnh quản lý thư viện thực tế, giúp người dùng hiểu rõ giá trị của việc áp dụng đại số quan hệ.

Ứng dụng này đặc biệt hữu ích cho:
- Sinh viên đang học về cơ sở dữ liệu quan hệ và MongoDB
- Lập trình viên muốn tìm hiểu cách áp dụng các nguyên lý cơ sở dữ liệu quan hệ trong NoSQL
- Người quản lý thư viện muốn tham khảo giải pháp công nghệ cho công việc của mình

## Thiết kế cơ sở dữ liệu

### Tổng quan về cơ sở dữ liệu MongoDB

MongoDB là một hệ quản trị cơ sở dữ liệu NoSQL, lưu trữ dữ liệu dưới dạng các document JSON. Mặc dù MongoDB không phải là cơ sở dữ liệu quan hệ, chúng ta vẫn có thể mô phỏng các phép toán đại số quan hệ thông qua các thao tác aggregation pipeline và các phương thức truy vấn phức tạp.

### Các Collection trong cơ sở dữ liệu

Ứng dụng Quản lý Thư viện Sách sử dụng các collection sau:

#### 1. Collection `books`

Lưu trữ thông tin về các cuốn sách trong thư viện.

```json
{
  "_id": ObjectId("..."),
  "maSach": "S01",
  "tenSach": "Dạy Nấu Ăn",
  "theLoai": "Đời sống",
  "giaBan": 50000,
  "soTrang": 100,
  "tacGia": "TG01",
  "nhaXuatBan": "NXB01",
  "namXuatBan": 2020,
  "soLuong": 10,
  "trangThai": "Còn sách",
  "moTa": "Sách dạy nấu ăn cơ bản cho người mới bắt đầu",
  "hinhAnh": "https://example.com/image.jpg",
  "ngayNhap": ISODate("2023-01-01"),
  "danh_gia_trung_binh": 4.5
}
```

#### 2. Collection `members`

Lưu trữ thông tin về các thành viên của thư viện.

```json
{
  "_id": ObjectId("..."),
  "maTV": "TV01",
  "tenTV": "Nguyễn Văn A",
  "tuoi": 20,
  "soDT": "0901234567",
  "email": "nguyenvana@example.com",
  "diaChi": "123 Đường ABC, Quận 1, TP.HCM",
  "ngaySinh": ISODate("2003-05-15"),
  "gioiTinh": "Nam",
  "ngayDangKy": ISODate("2023-01-01"),
  "hanThe": ISODate("2024-01-01"),
  "diem": 100,
  "trangThai": "Đang hoạt động"
}
```

#### 3. Collection `borrows`

Lưu trữ thông tin về các lượt mượn sách.

```json
{
  "_id": ObjectId("..."),
  "maTV": "TV01",
  "maSach": "S01",
  "ngayMuon": ISODate("2023-10-01"),
  "ngayTra": ISODate("2023-10-10"),
  "trangThai": "Đã trả",
  "ghiChu": "Sách còn mới",
  "nhanVienChoMuon": "NV01",
  "nhanVienNhan": "NV02",
  "soLuong": 1,
  "tienCoc": 50000,
  "tienPhat": 0
}
```

#### 4. Collection `categories`

Lưu trữ thông tin về các thể loại sách.

```json
{
  "_id": ObjectId("..."),
  "maTheLoai": "TL01",
  "tenTheLoai": "Đời sống",
  "moTa": "Sách về kỹ năng sống, nấu ăn, làm đẹp",
  "viTri": "Kệ A",
  "soLuongSach": 100
}
```

#### 5. Collection `authors`

Lưu trữ thông tin về các tác giả.

```json
{
  "_id": ObjectId("..."),
  "maTacGia": "TG01",
  "tenTacGia": "Nguyễn Văn A",
  "quocTich": "Việt Nam",
  "namSinh": 1980,
  "tieuSu": "Tác giả của nhiều cuốn sách về ẩm thực"
}
```

#### 6. Collection `employees`

Lưu trữ thông tin về nhân viên thư viện.

```json
{
  "_id": ObjectId("..."),
  "maNV": "NV01",
  "tenNV": "Trần Thị B",
  "chucVu": "Thủ thư",
  "soDT": "0912345678",
  "email": "tranthib@example.com",
  "diaChi": "456 Đường XYZ, Quận 2, TP.HCM",
  "luong": 8000000,
  "ngayVaoLam": ISODate("2020-01-01")
}
```

#### 7. Collection `ratings`

Lưu trữ đánh giá của độc giả về sách.

```json
{
  "_id": ObjectId("..."),
  "maTV": "TV01",
  "maSach": "S01",
  "diem": 5,
  "nhanXet": "Sách rất hay và dễ hiểu",
  "ngayDanhGia": ISODate("2023-10-15")
}
```

#### 8. Collection `publishers`

Lưu trữ thông tin về các nhà xuất bản.

```json
{
  "_id": ObjectId("..."),
  "maNXB": "NXB01",
  "tenNXB": "NXB Giáo Dục",
  "diaChi": "789 Đường MNO, Quận 3, TP.HCM",
  "soDT": "0923456789",
  "email": "nxbgiaoduc@example.com",
  "website": "https://nxbgiaoduc.com"
}
```

### Mối quan hệ giữa các Collection

- **Một sách thuộc về một thể loại**: Collection `books` có trường `theLoai` liên kết với `maTheLoai` trong collection `categories`.

- **Một sách có một tác giả**: Collection `books` có trường `tacGia` liên kết với `maTacGia` trong collection `authors`.

- **Một sách thuộc về một nhà xuất bản**: Collection `books` có trường `nhaXuatBan` liên kết với `maNXB` trong collection `publishers`.

- **Một thành viên có thể mượn nhiều sách**: Collection `borrows` có các trường `maTV` và `maSach` liên kết với `maTV` trong collection `members` và `maSach` trong collection `books`.

- **Một thành viên có thể đánh giá nhiều sách**: Collection `ratings` có các trường `maTV` và `maSach` liên kết với `maTV` trong collection `members` và `maSach` trong collection `books`.

- **Một nhân viên có thể xử lý nhiều lượt mượn sách**: Collection `borrows` có các trường `nhanVienChoMuon` và `nhanVienNhan` liên kết với `maNV` trong collection `employees`.

### Ưu điểm của thiết kế cơ sở dữ liệu

- **Tính linh hoạt**: MongoDB cho phép mở rộng schema dễ dàng khi cần thêm trường mới.
- **Hiệu suất cao**: Các truy vấn phức tạp có thể được tối ưu thông qua index và aggregation pipeline.
- **Dễ dàng mở rộng**: Có thể thêm các collection mới khi cần mở rộng tính năng của ứng dụng.
- **Hỗ trợ đa dạng kiểu dữ liệu**: MongoDB hỗ trợ lưu trữ các loại dữ liệu phức tạp như mảng, đối tượng lồng nhau, v.v.

## Cài đặt và cấu hình

Để cài đặt và chạy ứng dụng, bạn cần thực hiện các bước sau:

1. Cài đặt MongoDB và cấu hình kết nối đến cơ sở dữ liệu.
2. Cài đặt Flutter và các phụ thuộc cần thiết.
3. Sao chép mã nguồn vào máy tính của bạn.
4. Chạy ứng dụng bằng lệnh `flutter run`.

## Các phép toán đại số quan hệ

### 1. Phép chọn (Selection - σ)

Phép chọn trả về các bản ghi thỏa mãn điều kiện được chỉ định.

#### Ví dụ: Lấy ra các sách thuộc thể loại CNTT

**Cú pháp truyền thống**:
```
σ theLoai='CNTT' (books)
```

**Triển khai với MongoDB**:
```javascript
db.books.find({ "theLoai": "CNTT" })
```

**Triển khai với Flutter & MongoDB**:
```dart
Future<List<Book>> getBooksByCategory(String category) async {
  try {
    final collection = db.collection('books');
    final result = await collection.find(where.eq('theLoai', category)).toList();
    return result.map((doc) => Book.fromJson(doc)).toList();
  } catch (e) {
    print('Lỗi khi lấy sách theo thể loại: $e');
    return [];
  }
}
```

**Ứng dụng trong màn hình**: Hiển thị danh sách sách theo thể loại.

### 2. Phép chiếu (Projection - π)

Phép chiếu trả về các cột được chỉ định từ các bản ghi.

#### Ví dụ: Lấy ra tên sách và giá bán từ bảng SÁCH

**Cú pháp truyền thống**:
```
π tenSach, giaBan (books)
```

**Triển khai với MongoDB**:
```javascript
db.books.find({}, { "tenSach": 1, "giaBan": 1, "_id": 0 })
```

**Triển khai với Flutter & MongoDB**:
```dart
Future<List<Map<String, dynamic>>> getBooksNameAndPrice() async {
  try {
    final collection = db.collection('books');
    final result = await collection.find(
      {},
      projection: {'tenSach': 1, 'giaBan': 1, '_id': 0},
    ).toList();
    return result;
  } catch (e) {
    print('Lỗi khi lấy tên và giá sách: $e');
    return [];
  }
}
```

**Ứng dụng trong màn hình**: Hiển thị danh sách sách với thông tin tối giản (chỉ tên và giá).

### 3. Tích Đề-các (Cartesian Product - ×)

Tích Đề-các trả về tất cả các bản ghi có thể có được bằng cách kết hợp mỗi bản ghi từ bảng thứ nhất với mỗi bản ghi từ bảng thứ hai.

#### Ví dụ: Kết hợp tất cả các thành viên với tất cả các sách

**Cú pháp truyền thống**:
```
members × books
```

**Triển khai với MongoDB**:
```javascript
// Trong MongoDB, chúng ta cần sử dụng $lookup và làm thêm vài bước
db.members.aggregate([
  {
    $lookup: {
      from: "books",
      pipeline: [],
      as: "allBooks"
    }
  },
  {
    $unwind: "$allBooks"
  },
  {
    $project: {
      "_id": 0,
      "maTV": 1,
      "tenTV": 1,
      "maSach": "$allBooks.maSach",
      "tenSach": "$allBooks.tenSach"
    }
  }
])
```

**Triển khai với Flutter & MongoDB**:
```dart
Future<List<Map<String, dynamic>>> cartesianProductMembersAndBooks() async {
  try {
    final collection = db.collection('members');
    final pipeline = [
      {
        '\$lookup': {
          'from': 'books',
          'pipeline': [],
          'as': 'allBooks'
        }
      },
      {
        '\$unwind': '\$allBooks'
      },
      {
        '\$project': {
          '_id': 0,
          'maTV': 1,
          'tenTV': 1,
          'maSach': '\$allBooks.maSach',
          'tenSach': '\$allBooks.tenSach'
        }
      }
    ];
    
    final result = await collection.aggregate(pipeline).toList();
    return result;
  } catch (e) {
    print('Lỗi khi thực hiện tích Đề-các: $e');
    return [];
  }
}
```

**Ứng dụng trong màn hình**: Hiển thị tất cả các kết hợp có thể giữa thành viên và sách, có thể dùng để tạo báo cáo thống kê.

### 4. Phép trừ (Set Difference - -)

Phép trừ trả về các bản ghi chỉ có trong bảng thứ nhất mà không có trong bảng thứ hai.

#### Ví dụ: Tìm các thành viên chưa mượn sách nào

**Cú pháp truyền thống**:
```
π maTV (members) - π maTV (borrows)
```

**Triển khai với MongoDB**:
```javascript
db.members.aggregate([
  {
    $lookup: {
      from: "borrows",
      localField: "maTV",
      foreignField: "maTV",
      as: "borrowed"
    }
  },
  {
    $match: {
      "borrowed": { $eq: [] }
    }
  },
  {
    $project: {
      "_id": 0,
      "maTV": 1,
      "tenTV": 1
    }
  }
])
```

**Triển khai với Flutter & MongoDB**:
```dart
Future<List<Map<String, dynamic>>> getMembersWithNoBorrows() async {
  try {
    final collection = db.collection('members');
    final pipeline = [
      {
        '\$lookup': {
          'from': 'borrows',
          'localField': 'maTV',
          'foreignField': 'maTV',
          'as': 'borrowed'
        }
      },
      {
        '\$match': {
          'borrowed': { '\$eq': [] }
        }
      },
      {
        '\$project': {
          '_id': 0,
          'maTV': 1,
          'tenTV': 1
        }
      }
    ];
    
    final result = await collection.aggregate(pipeline).toList();
    return result;
  } catch (e) {
    print('Lỗi khi tìm thành viên chưa mượn sách: $e');
    return [];
  }
}
```

**Ứng dụng trong màn hình**: Hiển thị danh sách thành viên chưa mượn sách nào, có thể dùng để tạo chiến dịch khuyến khích.

### 5. Phép hợp (Union - ∪)

Phép hợp trả về tất cả các bản ghi có trong một trong hai hoặc cả hai bảng.

#### Ví dụ: Hợp danh sách sách mới và sách cũ

**Cú pháp truyền thống**:
```
old_books ∪ new_books
```

**Triển khai với MongoDB**:
```javascript
// Giả sử chúng ta có collection old_books và new_books
db.old_books.aggregate([
  {
    $unionWith: {
      coll: "new_books"
    }
  }
])
```

**Triển khai với Flutter & MongoDB**:
```dart
Future<List<Map<String, dynamic>>> unionBooks() async {
  try {
    final collection = db.collection('old_books');
    final pipeline = [
      {
        '\$unionWith': {
          'coll': 'new_books'
        }
      }
    ];
    
    final result = await collection.aggregate(pipeline).toList();
    return result;
  } catch (e) {
    print('Lỗi khi thực hiện phép hợp: $e');
    return [];
  }
}
```

**Ứng dụng trong màn hình**: Hiển thị tất cả sách có trong thư viện, bao gồm cả sách mới và sách cũ.

### 6. Phép giao (Intersection - ∩)

Phép giao trả về các bản ghi có trong cả hai bảng.

#### Ví dụ: Tìm sách vừa thuộc thể loại CNTT vừa là sách bán chạy

**Cú pháp truyền thống**:
```
(σ theLoai='CNTT' (books)) ∩ best_selling_books
```

**Triển khai với MongoDB**:
```javascript
// Giả sử chúng ta có collection best_selling_books
db.books.aggregate([
  {
    $match: { "theLoai": "CNTT" }
  },
  {
    $lookup: {
      from: "best_selling_books",
      localField: "maSach",
      foreignField: "maSach",
      as: "bestSelling"
    }
  },
  {
    $match: {
      "bestSelling": { $ne: [] }
    }
  },
  {
    $project: {
      "_id": 0,
      "maSach": 1,
      "tenSach": 1,
      "theLoai": 1,
      "giaBan": 1
    }
  }
])
```

**Triển khai với Flutter & MongoDB**:
```dart
Future<List<Map<String, dynamic>>> getITBestSellingBooks() async {
  try {
    final collection = db.collection('books');
    final pipeline = [
      {
        '\$lookup': {
          'from': 'borrows',
          'localField': 'maSach',
          'foreignField': 'maSach',
          'as': 'borrowRecords'
        }
      },
      {
        '\$addFields': {
          'borrowCount': { '\$size': '\$borrowRecords' }
        }
      },
      {
        '\$match': {
          'theLoai': 'CNTT',
          'borrowCount': { '\$gte': 5 }
        }
      },
      {
        '\$project': {
          '_id': 0,
          'maSach': 1,
          'tenSach': 1,
          'theLoai': 1,
          'tacGia': 1,
          'borrowCount': 1
        }
      }
    ];
    
    final result = await collection.aggregateToStream(pipeline).toList();
    return result;
  } catch (e) {
    print('Lỗi khi tìm sách CNTT bán chạy: $e');
    return [];
  }
}
```

**Ứng dụng trong màn hình**: Hiển thị danh sách sách CNTT bán chạy để đề xuất cho người dùng.

### 7. Phép nối (Join - ⋈)

Phép nối kết hợp các hàng từ hai bảng dựa trên một điều kiện nối.

#### Ví dụ: Kết hợp thông tin thành viên với thông tin mượn sách

**Cú pháp truyền thống**:
```
members ⋈ members.maTV = borrows.maTV borrows
```

**Triển khai với MongoDB**:
```javascript
db.members.aggregate([
  {
    $lookup: {
      from: "borrows",
      localField: "maTV",
      foreignField: "maTV",
      as: "borrowInfo"
    }
  },
  {
    $unwind: "$borrowInfo"
  },
  {
    $project: {
      "_id": 0,
      "maTV": 1,
      "tenTV": 1,
      "maSach": "$borrowInfo.maSach",
      "ngayMuon": "$borrowInfo.ngayMuon",
      "ngayTra": "$borrowInfo.ngayTra"
    }
  }
])
```

**Triển khai với Flutter & MongoDB**:
```dart
Future<List<Map<String, dynamic>>> getMembersWithBorrowInfo() async {
  try {
    final collection = db.collection('members');
    final pipeline = [
      {
        '\$lookup': {
          'from': 'borrows',
          'localField': 'maTV',
          'foreignField': 'maTV',
          'as': 'borrowInfo'
        }
      },
      {
        '\$unwind': '\$borrowInfo'
      },
      {
        '\$project': {
          '_id': 0,
          'maTV': 1,
          'tenTV': 1,
          'maSach': '\$borrowInfo.maSach',
          'ngayMuon': '\$borrowInfo.ngayMuon',
          'ngayTra': '\$borrowInfo.ngayTra'
        }
      }
    ];
    
    final result = await collection.aggregate(pipeline).toList();
    return result;
  } catch (e) {
    print('Lỗi khi lấy thông tin mượn sách của thành viên: $e');
    return [];
  }
}
```

**Ứng dụng trong màn hình**: Hiển thị danh sách thành viên và thông tin mượn sách của họ.

### 8. Nối θ (θ-join)

Nối θ là phép nối dựa trên một điều kiện so sánh θ bất kỳ (không chỉ là bằng).

#### Ví dụ: Tìm các cặp thành viên và sách mà thành viên có tuổi lớn hơn số trang của sách

**Cú pháp truyền thống**:
```
members ⋈ members.tuoi > books.soTrang books
```

**Triển khai với MongoDB**:
```javascript
db.members.aggregate([
  {
    $lookup: {
      from: "books",
      let: { memberAge: "$tuoi" },
      pipeline: [
        {
          $match: {
            $expr: {
              $lt: ["$soTrang", "$$memberAge"]
            }
          }
        }
      ],
      as: "matchedBooks"
    }
  },
  {
    $unwind: "$matchedBooks"
  },
  {
    $project: {
      "_id": 0,
      "maTV": 1,
      "tenTV": 1,
      "tuoi": 1,
      "maSach": "$matchedBooks.maSach",
      "tenSach": "$matchedBooks.tenSach",
      "soTrang": "$matchedBooks.soTrang"
    }
  }
])
```

**Triển khai với Flutter & MongoDB**:
```dart
Future<List<Map<String, dynamic>>> getMembersAgeGreaterThanBookPages() async {
  try {
    final collection = db.collection('members');
    final pipeline = [
      {
        '\$lookup': {
          'from': 'books',
          'let': { 'memberAge': '\$tuoi' },
          'pipeline': [
            {
              '\$match': {
                '\$expr': {
                  '\$lt': ['\$soTrang', '\$\$memberAge']
                }
              }
            }
          ],
          'as': 'matchedBooks'
        }
      },
      {
        '\$match': {
          'matchedBooks': { '\$ne': [] }
        }
      },
      {
        '\$unwind': '\$matchedBooks'
      },
      {
        '\$project': {
          '_id': 0,
          'maTV': 1,
          'tenTV': 1,
          'tuoi': 1,
          'maSach': '\$matchedBooks.maSach',
          'tenSach': '\$matchedBooks.tenSach',
          'soTrang': '\$matchedBooks.soTrang'
        }
      }
    ];
    
    final result = await collection.aggregate(pipeline).toList();
    return result;
  } catch (e) {
    print('Lỗi khi thực hiện nối θ: $e');
    return [];
  }
}
```

**Ứng dụng trong màn hình**: Hiển thị danh sách gợi ý sách dựa trên tuổi thành viên.

### 9. Nối bằng (Equi-join)

Nối bằng là phép nối dựa trên điều kiện bằng nhau giữa hai cột.

#### Ví dụ: Kết hợp thông tin sách và thông tin đánh giá

**Cú pháp truyền thống**:
```
books ⋈ books.maSach = ratings.maSach ratings
```

**Triển khai với MongoDB**:
```javascript
db.books.aggregate([
  {
    $lookup: {
      from: "ratings",
      localField: "maSach",
      foreignField: "maSach",
      as: "ratingInfo"
    }
  },
  {
    $unwind: "$ratingInfo"
  },
  {
    $project: {
      "_id": 0,
      "maSach": 1,
      "tenSach": 1,
      "theLoai": 1,
      "maTV": "$ratingInfo.maTV",
      "diem": "$ratingInfo.diem",
      "nhanXet": "$ratingInfo.nhanXet"
    }
  }
])
```

**Triển khai với Flutter & MongoDB**:
```dart
Future<List<Map<String, dynamic>>> getBooksWithRatings() async {
  try {
    final collection = db.collection('books');
    final pipeline = [
      {
        '\$lookup': {
          'from': 'ratings',
          'localField': 'maSach',
          'foreignField': 'maSach',
          'as': 'ratingInfo'
        }
      },
      {
        '\$unwind': '\$ratingInfo'
      },
      {
        '\$project': {
          '_id': 0,
          'maSach': 1,
          'tenSach': 1,
          'theLoai': 1,
          'maTV': '\$ratingInfo.maTV',
          'diem': '\$ratingInfo.diem',
          'nhanXet': '\$ratingInfo.nhanXet'
        }
      }
    ];
    
    final result = await collection.aggregate(pipeline).toList();
    return result;
  } catch (e) {
    print('Lỗi khi lấy sách kèm đánh giá: $e');
    return [];
  }
}
```

**Ứng dụng trong màn hình**: Hiển thị danh sách sách với đánh giá của độc giả.

### 10. Nối tự nhiên (Natural Join)

Nối tự nhiên là phép nối dựa trên tất cả các cột có cùng tên trong hai bảng.

#### Ví dụ: Kết hợp thông tin sách và thông tin mượn sách

**Cú pháp truyền thống**:
```
books ⋈ borrows
```

**Triển khai với MongoDB**:
```javascript
db.books.aggregate([
  {
    $lookup: {
      from: "borrows",
      localField: "maSach",
      foreignField: "maSach",
      as: "borrowInfo"
    }
  },
  {
    $unwind: "$borrowInfo"
  },
  {
    $project: {
      "_id": 0,
      "maSach": 1,
      "tenSach": 1,
      "theLoai": 1,
      "maTV": "$borrowInfo.maTV",
      "ngayMuon": "$borrowInfo.ngayMuon",
      "ngayTra": "$borrowInfo.ngayTra"
    }
  }
])
```

**Triển khai với Flutter & MongoDB**:
```dart
Future<List<Map<String, dynamic>>> getBooksWithBorrows() async {
  try {
    final collection = db.collection('books');
    final pipeline = [
      {
        '\$lookup': {
          'from': 'borrows',
          'localField': 'maSach',
          'foreignField': 'maSach',
          'as': 'borrowInfo'
        }
      },
      {
        '\$unwind': '\$borrowInfo'
      },
      {
        '\$project': {
          '_id': 0,
          'maSach': 1,
          'tenSach': 1,
          'theLoai': 1,
          'maTV': '\$borrowInfo.maTV',
          'ngayMuon': '\$borrowInfo.ngayMuon',
          'ngayTra': '\$borrowInfo.ngayTra'
        }
      }
    ];
    
    final result = await collection.aggregate(pipeline).toList();
    return result;
  } catch (e) {
    print('Lỗi khi lấy sách kèm thông tin mượn: $e');
    return [];
  }
}
```

**Ứng dụng trong màn hình**: Hiển thị danh sách sách kèm thông tin ai đang mượn.

### 11. Phép chia (Division - ÷)

Phép chia tìm các giá trị trong bảng thứ nhất mà liên kết với tất cả các giá trị trong bảng thứ hai.

#### Ví dụ: Tìm các thành viên đã mượn tất cả sách thể loại CNTT

**Cú pháp truyền thống**:
```
π maTV, maSach (borrows) ÷ π maSach (σ theLoai='CNTT' (books))
```

**Triển khai với MongoDB**:
```javascript
// Bước 1: Lấy danh sách tất cả sách CNTT
const itBooks = db.books.find({ "theLoai": "CNTT" }).map(book => book.maSach);

// Bước 2: Tìm những thành viên đã mượn tất cả sách CNTT
db.members.aggregate([
  {
    $lookup: {
      from: "borrows",
      localField: "maTV",
      foreignField: "maTV",
      as: "borrowedBooks"
    }
  },
  {
    $project: {
      "_id": 0,
      "maTV": 1,
      "tenTV": 1,
      "borrowedITBooks": {
        $filter: {
          input: "$borrowedBooks",
          as: "borrowed",
          cond: {
            $in: ["$$borrowed.maSach", itBooks]
          }
        }
      }
    }
  },
  {
    $match: {
      $expr: {
        $eq: [{ $size: "$borrowedITBooks" }, { $size: itBooks }]
      }
    }
  },
  {
    $project: {
      "maTV": 1,
      "tenTV": 1
    }
  }
])
```

**Triển khai với Flutter & MongoDB**:
```dart
Future<List<Map<String, dynamic>>> getMembersWhoBorrowedAllITBooks() async {
  try {
    // Bước 1: Lấy danh sách tất cả sách CNTT
    final booksCollection = db.collection('books');
    final itBooksResult = await booksCollection.find({'theLoai': 'CNTT'}).toList();
    final itBooks = itBooksResult.map((book) => book['maSach']).toList();
    
    // Bước 2: Tìm những thành viên đã mượn tất cả sách CNTT
    final membersCollection = db.collection('members');
    final pipeline = [
      {
        '\$lookup': {
          'from': 'borrows',
          'localField': 'maTV',
          'foreignField': 'maTV',
          'as': 'borrowedBooks'
        }
      },
      {
        '\$project': {
          '_id': 0,
          'maTV': 1,
          'tenTV': 1,
          'borrowedITBooks': {
            '\$filter': {
              'input': '\$borrowedBooks',
              'as': 'borrowed',
              'cond': {
                '\$in': ['\$\$borrowed.maSach', itBooks]
              }
            }
          }
        }
      },
      {
        '\$match': {
          '\$expr': {
            '\$eq': [{ '\$size': '\$borrowedITBooks' }, itBooks.length]
          }
        }
      },
      {
        '\$project': {
          'maTV': 1,
          'tenTV': 1
        }
      }
    ];
    
    final result = await membersCollection.aggregate(pipeline).toList();
    return result;
  } catch (e) {
    print('Lỗi khi thực hiện phép chia: $e');
    return [];
  }
}
```

**Ứng dụng trong màn hình**: Hiển thị danh sách thành viên đã mượn tất cả sách CNTT, có thể dùng để trao thưởng hoặc tạo chương trình khuyến mãi đặc biệt.

## Cấu trúc dự án

Ứng dụng Quản lý Thư viện Sách có cấu trúc dự án như sau:

```
library_management_app/
├── android/
├── ios/
├── lib/
│   ├── configs/
│   │   ├── constants.dart
│   │   ├── routes.dart
│   │   └── theme.dart
│   ├── models/
│   │   ├── book_model.dart
│   │   ├── member_model.dart
│   │   ├── borrow_model.dart
│   │   ├── category_model.dart
│   │   ├── author_model.dart
│   │   ├── publisher_model.dart
│   │   ├── employee_model.dart
│   │   └── rating_model.dart
│   ├── repositories/
│   │   ├── book_repository.dart
│   │   ├── member_repository.dart
│   │   ├── borrow_repository.dart
│   │   ├── category_repository.dart
│   │   ├── author_repository.dart
│   │   ├── publisher_repository.dart
│   │   └── relational_operations.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── books/
│   │   │   ├── book_list_screen.dart
│   │   │   ├── book_detail_screen.dart
│   │   │   ├── add_edit_book_screen.dart
│   │   │   ├── books_by_category_screen.dart
│   │   │   └── bestseller_books_screen.dart
│   │   ├── members/
│   │   │   ├── member_list_screen.dart
│   │   │   ├── member_detail_screen.dart
│   │   │   ├── add_edit_member_screen.dart
│   │   │   └── inactive_members_screen.dart
│   │   ├── borrows/
│   │   │   ├── borrow_list_screen.dart
│   │   │   ├── borrow_detail_screen.dart
│   │   │   ├── add_edit_borrow_screen.dart
│   │   │   └── borrow_statistics_screen.dart
│   │   ├── reading_analysis/
│   │   │   ├── reading_matrix_screen.dart
│   │   │   ├── seasonal_trends_screen.dart
│   │   │   └── age_category_analysis_screen.dart
│   │   ├── reports/
│   │   │   ├── reading_preference_report.dart
│   │   │   ├── trends_comparison_screen.dart
│   │   │   └── loyal_readers_screen.dart
│   │   ├── catalog/
│   │   │   ├── category_list_screen.dart
│   │   │   ├── author_list_screen.dart
│   │   │   ├── author_books_screen.dart
│   │   │   └── empty_categories_screen.dart
│   │   └── operations/
│   │       ├── selection_demo_screen.dart
│   │       ├── projection_demo_screen.dart
│   │       ├── cartesian_product_demo_screen.dart
│   │       ├── set_difference_demo_screen.dart
│   │       ├── union_demo_screen.dart
│   │       ├── intersection_demo_screen.dart
│   │       ├── join_demo_screen.dart
│   │       ├── theta_join_demo_screen.dart
│   │       ├── equi_join_demo_screen.dart
│   │       ├── natural_join_demo_screen.dart
│   │       └── division_demo_screen.dart
│   ├── services/
│   │   ├── database_service.dart
│   │   ├── mongodb_service.dart
│   │   ├── auth_service.dart
│   │   └── analytics_service.dart
│   ├── widgets/
│   │   ├── book_card.dart
│   │   ├── member_card.dart
│   │   ├── borrow_card.dart
│   │   ├── category_card.dart
│   │   ├── author_card.dart
│   │   ├── custom_app_bar.dart
│   │   ├── custom_drawer.dart
│   │   ├── loading_indicator.dart
│   │   ├── statistics_chart.dart
│   │   └── relation_demo_card.dart
│   ├── main.dart
│   └── app.dart
├── pubspec.yaml
├── test/
├── README.md
└── .gitignore
```

## Giao diện người dùng

Ứng dụng Quản lý Thư viện Sách có giao diện người dùng trực quan, dễ sử dụng, được thiết kế để áp dụng đầy đủ 11 phép toán đại số quan hệ vào các chức năng thực tế. Mỗi màn hình chính sẽ áp dụng một số phép toán cụ thể:

### 1. Màn hình chính (Home Screen)
- **Tổng quan thống kê**: Sử dụng phép chiếu (π) và các hàm tổng hợp để hiển thị số lượng sách, thành viên và lượt mượn
- **Tìm sách phổ biến nhất**: Sử dụng phép nối tự nhiên (Natural Join) giữa books và borrows để tìm sách được mượn nhiều nhất

### 2. Màn hình Quản lý Sách
- **Danh sách sách**: Sử dụng phép chọn (σ) khi lọc theo điều kiện (thể loại, tác giả, v.v.)
- **Thống kê sách theo thể loại**: Sử dụng phép chiếu (π) và gom nhóm để phân tích xu hướng
- **Tìm sách CNTT bán chạy**: Sử dụng phép giao (Intersection) giữa sách CNTT và sách bán chạy
- **Kết hợp sách mới và cũ**: Sử dụng phép hợp (Union) để hiển thị cả sách mới và cũ

### 3. Màn hình Quản lý Thành viên
- **Danh sách thành viên**: Sử dụng phép chọn (σ) để lọc thành viên theo tiêu chí
- **Tìm thành viên chưa mượn sách**: Sử dụng phép trừ (Set Difference) giữa tất cả thành viên và thành viên đã mượn sách
- **Lịch sử mượn sách của thành viên**: Sử dụng phép nối (Join) giữa members và borrows
- **So sánh thành viên với số trang sách**: Sử dụng nối θ (θ-join) để tìm thành viên có tuổi > số trang của sách họ mượn

### 4. Màn hình Quản lý Mượn/Trả
- **Danh sách mượn sách**: Sử dụng phép chọn (σ) để lọc theo trạng thái mượn/trả
- **Thống kê mượn/trả theo thời gian**: Sử dụng phép chiếu (π) và gom nhóm theo ngày
- **Tìm thành viên mượn tất cả sách CNTT**: Sử dụng phép chia (Division) để tìm thành viên đã mượn tất cả sách thể loại CNTT

### 5. Màn hình Phân tích Đọc sách
- **Ma trận thành viên-sách**: Sử dụng tích Đề-các (Cartesian Product) để tạo khung phân tích đọc sách
- **Xu hướng đọc theo mùa**: Sử dụng phép nối (Join) giữa thành viên, mượn sách và thời gian
- **Phân tích tuổi độc giả và thể loại**: Sử dụng nối θ (θ-join) để phân tích mối quan hệ giữa độ tuổi và sở thích đọc

### 6. Màn hình Báo cáo và Thống kê
- **Phân tích độc giả trung thành**: Sử dụng phép chia để tìm thành viên đã mượn tất cả sách của tác giả
- **So sánh xu hướng mượn sách**: Sử dụng phép trừ và hợp để phân tích sự thay đổi theo thời gian
- **Độc giả trung thành nhất**: Sử dụng phép chia để tìm độc giả đọc đầy đủ các series sách

### 7. Màn hình Quản lý Thể loại và Tác giả
- **Danh sách thể loại**: Sử dụng phép chiếu (π) để hiển thị
- **Tác giả và sách tương ứng**: Sử dụng phép nối (⋈) để kết hợp thông tin
- **Thể loại không có sách**: Sử dụng phép trừ (-) để phân tích kho sách

### 8. Màn hình Demo Phép toán Đại số Quan hệ

Mỗi phép toán đại số quan hệ sẽ có một màn hình demo riêng với ví dụ thực tế:

1. **Phép chọn (σ)**: Tìm sách theo điều kiện (ví dụ: giá < 50.000đ)
2. **Phép chiếu (π)**: Hiển thị chỉ tên sách và tác giả
3. **Tích Đề-các (×)**: Hiển thị tất cả cặp thành viên-sách có thể
4. **Phép trừ (-)**: Tìm sách chưa từng được mượn
5. **Phép hợp (∪)**: Gộp sách từ hai chi nhánh thư viện
6. **Phép giao (∩)**: Tìm sách vừa thuộc thể loại Văn học vừa là sách dịch
7. **Phép nối (⋈)**: Kết hợp thông tin sách và tác giả
8. **Nối θ (θ-join)**: Tìm cặp thành viên-sách có điều kiện (tuổi > số trang)
9. **Nối bằng (Equi-join)**: Kết hợp sách và đánh giá theo mã sách
10. **Nối tự nhiên (Natural Join)**: Kết hợp tự động theo mã sách
11. **Phép chia (÷)**: Tìm thành viên đã mượn tất cả sách của tác giả cụ thể

## Triển khai chi tiết

### Cài đặt và cấu hình

#### 1. Cài đặt Flutter

Đầu tiên, bạn cần cài đặt Flutter trên máy tính của mình. Truy cập [flutter.dev](https://flutter.dev) để tải xuống và cài đặt Flutter SDK.

#### 2. Cài đặt MongoDB

Có hai cách để sử dụng MongoDB:

- **Cài đặt MongoDB Community Edition**: Tải xuống và cài đặt từ [mongodb.com](https://www.mongodb.com/try/download/community).
- **Sử dụng MongoDB Atlas**: Dịch vụ đám mây miễn phí cho cơ sở dữ liệu MongoDB. Tạo tài khoản tại [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas).

#### 3. Tạo dự án Flutter mới

   ```bash
flutter create library_management_app
cd library_management_app
```

#### 4. Thêm các dependency vào pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  mongo_dart: ^0.8.2
  provider: ^6.0.5
  flutter_staggered_grid_view: ^0.6.2
  intl: ^0.17.0
  shared_preferences: ^2.1.1
  http: ^0.13.5
  path_provider: ^2.0.15
  flutter_local_notifications: ^13.0.0
  pdf: ^3.10.1
  printing: ^5.10.1
  image_picker: ^0.8.7+5
  connectivity_plus: ^3.0.3
  flutter_spinkit: ^5.2.0
  cached_network_image: ^3.2.3
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.2.19
```

Chạy lệnh sau để cài đặt các dependency:

   ```bash
   flutter pub get
   ```

#### 5. Cấu hình kết nối MongoDB

Tạo file `lib/services/mongodb_service.dart` với nội dung sau:

```dart
import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  static Db? _db;
  static bool isInitialized = false;

  static Future<void> connect() async {
    if (_db == null || !isInitialized) {
      try {
        // Thay đổi URI kết nối phù hợp với môi trường của bạn
        _db = await Db.create('mongodb://localhost:27017/library_db');
        await _db!.open();
        isInitialized = true;
        print('Kết nối MongoDB thành công');
      } catch (e) {
        print('Lỗi kết nối MongoDB: $e');
        rethrow;
      }
    }
  }

  static Db get db {
    if (!isInitialized) {
      throw Exception('MongoDB chưa được khởi tạo. Vui lòng gọi connect() trước.');
    }
    return _db!;
  }

  static DbCollection getCollection(String collectionName) {
    return db.collection(collectionName);
  }

  static Future<void> close() async {
    if (_db != null && isInitialized) {
      await _db!.close();
      isInitialized = false;
      _db = null;
      print('Đã đóng kết nối MongoDB');
    }
  }
}
```

#### 6. Khởi tạo dữ liệu mẫu

Tạo file `lib/services/data_seed_service.dart` để tạo dữ liệu mẫu cho ứng dụng:

```dart
import 'package:mongo_dart/mongo_dart.dart';
import 'package:library_management_app/services/mongodb_service.dart';

class DataSeedService {
  static Future<void> seedData() async {
    await seedBooks();
    await seedMembers();
    await seedBorrows();
    await seedCategories();
    await seedAuthors();
    await seedPublishers();
    await seedEmployees();
    await seedRatings();
    print('Đã tạo dữ liệu mẫu thành công');
  }

  static Future<void> seedBooks() async {
    final collection = MongoDBService.getCollection('books');
    
    // Xóa tất cả dữ liệu cũ
    await collection.drop();
    
    // Thêm dữ liệu mẫu
    await collection.insertMany([
      {
        'maSach': 'S01',
        'tenSach': 'Dạy Nấu Ăn',
        'theLoai': 'Đời sống',
        'giaBan': 50000,
        'soTrang': 100,
        'tacGia': 'Nguyễn Văn A',
        'nhaXuatBan': 'NXB Giáo Dục',
        'namXuatBan': 2020,
        'soLuong': 10,
        'trangThai': 'Còn sách',
        'moTa': 'Sách dạy nấu ăn cơ bản cho người mới bắt đầu',
        'hinhAnh': 'https://example.com/image1.jpg',
        'ngayNhap': DateTime.now(),
        'danh_gia_trung_binh': 4.5
      },
      {
        'maSach': 'S02',
        'tenSach': 'Học Lập Trình',
        'theLoai': 'CNTT',
        'giaBan': 120000,
        'soTrang': 300,
        'tacGia': 'Trần Văn B',
        'nhaXuatBan': 'NXB Khoa học Kỹ thuật',
        'namXuatBan': 2021,
        'soLuong': 5,
        'trangThai': 'Còn sách',
        'moTa': 'Sách học lập trình cho người mới bắt đầu',
        'hinhAnh': 'https://example.com/image2.jpg',
        'ngayNhap': DateTime.now(),
        'danh_gia_trung_binh': 4.0
      },
      // Thêm các sách khác
    ]);
  }

  // Tương tự cho các hàm seedMembers(), seedBorrows(), ...
}
```

#### 7. Tạo mô hình dữ liệu

Ví dụ về mô hình dữ liệu cho sách (`lib/models/book_model.dart`):

```dart
class Book {
  final String? id;
  final String maSach;
  final String tenSach;
  final String theLoai;
  final int giaBan;
  final int soTrang;
  final String tacGia;
  final String nhaXuatBan;
  final int namXuatBan;
  final int soLuong;
  final String trangThai;
  final String moTa;
  final String hinhAnh;
  final DateTime ngayNhap;
  final double danhGiaTrungBinh;

  Book({
    this.id,
    required this.maSach,
    required this.tenSach,
    required this.theLoai,
    required this.giaBan,
    required this.soTrang,
    required this.tacGia,
    required this.nhaXuatBan,
    required this.namXuatBan,
    required this.soLuong,
    required this.trangThai,
    required this.moTa,
    required this.hinhAnh,
    required this.ngayNhap,
    required this.danhGiaTrungBinh,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id']?.toString(),
      maSach: json['maSach'],
      tenSach: json['tenSach'],
      theLoai: json['theLoai'],
      giaBan: json['giaBan'],
      soTrang: json['soTrang'],
      tacGia: json['tacGia'],
      nhaXuatBan: json['nhaXuatBan'],
      namXuatBan: json['namXuatBan'],
      soLuong: json['soLuong'],
      trangThai: json['trangThai'],
      moTa: json['moTa'],
      hinhAnh: json['hinhAnh'],
      ngayNhap: json['ngayNhap'] is DateTime 
        ? json['ngayNhap'] 
        : DateTime.parse(json['ngayNhap'].toString()),
      danhGiaTrungBinh: json['danh_gia_trung_binh'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSach': maSach,
      'tenSach': tenSach,
      'theLoai': theLoai,
      'giaBan': giaBan,
      'soTrang': soTrang,
      'tacGia': tacGia,
      'nhaXuatBan': nhaXuatBan,
      'namXuatBan': namXuatBan,
      'soLuong': soLuong,
      'trangThai': trangThai,
      'moTa': moTa,
      'hinhAnh': hinhAnh,
      'ngayNhap': ngayNhap,
      'danh_gia_trung_binh': danhGiaTrungBinh,
    };
  }
}
```

#### 8. Tạo repository cho các phép toán đại số quan hệ

Tạo file `lib/repositories/relational_operations.dart`:

```dart
import 'package:mongo_dart/mongo_dart.dart';
import 'package:library_management_app/services/mongodb_service.dart';

class RelationalOperations {
  // Tích Đề-các: Kết hợp thành viên và sách
  static Future<List<Map<String, dynamic>>> cartesianProductMembersAndBooks() async {
    try {
      final db = MongoDBService.db;
      final collection = db.collection('members');
      final pipeline = [
        {
          '\$lookup': {
            'from': 'books',
            'pipeline': [],
            'as': 'allBooks'
          }
        },
        {
          '\$unwind': '\$allBooks'
        },
        {
          '\$project': {
            '_id': 0,
            'maTV': 1,
            'tenTV': 1,
            'maSach': '\$allBooks.maSach',
            'tenSach': '\$allBooks.tenSach'
          }
        }
      ];
      
      final result = await collection.aggregateToStream(pipeline).toList();
      return result;
    } catch (e) {
      print('Lỗi khi thực hiện tích Đề-các: $e');
      return [];
    }
  }

  // Phép chia: Tìm thành viên đã mượn tất cả sách của tác giả
  static Future<List<Map<String, dynamic>>> getMembersWhoBorrowedAllBooksByAuthor(String authorName) async {
    try {
      final db = MongoDBService.db;
      
      // Bước 1: Lấy mã tác giả từ tên tác giả
      final authorCollection = db.collection('authors');
      final authorDoc = await authorCollection.findOne(where.eq('tenTacGia', authorName));
      if (authorDoc == null) return [];
      
      final authorId = authorDoc['maTacGia'];
      
      // Bước 2: Lấy danh sách tất cả sách của tác giả
      final booksCollection = db.collection('books');
      final authorBooks = await booksCollection.find(where.eq('tacGia', authorId)).toList();
      final authorBookIds = authorBooks.map((book) => book['maSach']).toList();
      
      // Nếu tác giả không có sách nào
      if (authorBookIds.isEmpty) return [];
      
      // Bước 3: Tìm những thành viên đã mượn tất cả sách của tác giả
      final membersCollection = db.collection('members');
      final pipeline = [
        {
          '\$lookup': {
            'from': 'borrows',
            'localField': 'maTV',
            'foreignField': 'maTV',
            'as': 'borrowedBooks'
          }
        },
        {
          '\$project': {
            '_id': 0,
            'maTV': 1,
            'tenTV': 1,
            'borrowedAuthorBooks': {
              '\$filter': {
                'input': '\$borrowedBooks',
                'as': 'borrowed',
                'cond': {
                  '\$in': ['\$\$borrowed.maSach', authorBookIds]
                }
              }
            }
          }
        },
        {
          '\$addFields': {
            'borrowedAuthorBooksCount': { '\$size': '\$borrowedAuthorBooks' },
            'totalAuthorBooks': authorBookIds.length
          }
        },
        {
          '\$match': {
            '\$expr': {
              '\$eq': ['\$borrowedAuthorBooksCount', '\$totalAuthorBooks']
            }
          }
        },
        {
          '\$project': {
            'maTV': 1,
            'tenTV': 1
          }
        }
      ];
      
      final result = await membersCollection.aggregate(pipeline).toList();
      return result;
    } catch (e) {
      print('Lỗi khi thực hiện phép chia: $e');
      return [];
    }
  }

  // Phép trừ: Tìm thể loại không có sách nào
  static Future<List<Map<String, dynamic>>> getEmptyCategories() async {
    try {
      final db = MongoDBService.db;
      
      // Bước 1: Lấy tất cả thể loại
      final categoryCollection = db.collection('categories');
      final allCategories = await categoryCollection.find().toList();
      
      // Bước 2: Lấy thể loại có sách
      final booksCollection = db.collection('books');
      final usedCategoriesResult = await booksCollection.distinct('theLoai');
      final usedCategories = usedCategoriesResult.toList();
      
      // Bước 3: Tìm thể loại không có trong danh sách thể loại có sách
      final result = allCategories.where((category) {
        final categoryId = category['maTheLoai'];
        return !usedCategories.contains(categoryId);
      }).toList();
      
      return result;
    } catch (e) {
      print('Lỗi khi tìm thể loại trống: $e');
      return [];
    }
  }

  // Phép giao: Tìm sách vừa thuộc thể loại CNTT vừa là sách bán chạy
  static Future<List<Map<String, dynamic>>> getITBestSellingBooks() async {
    try {
      final db = MongoDBService.db;
      final booksCollection = db.collection('books');
      
      // Định nghĩa "bán chạy" là sách được mượn >= 5 lần
      final pipeline = [
        {
          '\$lookup': {
            'from': 'borrows',
            'localField': 'maSach',
            'foreignField': 'maSach',
            'as': 'borrowRecords'
          }
        },
        {
          '\$addFields': {
            'borrowCount': { '\$size': '\$borrowRecords' }
          }
        },
        {
          '\$match': {
            'theLoai': 'CNTT',
            'borrowCount': { '\$gte': 5 }
          }
        },
        {
          '\$project': {
            '_id': 0,
            'maSach': 1,
            'tenSach': 1,
            'theLoai': 1,
            'tacGia': 1,
            'borrowCount': 1
          }
        }
      ];
      
      final result = await booksCollection.aggregateToStream(pipeline).toList();
      return result;
    } catch (e) {
      print('Lỗi khi tìm sách CNTT bán chạy: $e');
      return [];
    }
  }

  // Nối θ: Tìm thành viên có tuổi > số trang sách
  static Future<List<Map<String, dynamic>>> getMembersAgeGreaterThanBookPages() async {
    try {
      final db = MongoDBService.db;
      final membersCollection = db.collection('members');
      
      final pipeline = [
        {
          '\$lookup': {
            'from': 'books',
            'let': { 'memberAge': '\$tuoi' },
            'pipeline': [
              {
                '\$match': {
                  '\$expr': {
                    '\$lt': ['\$soTrang', '\$\$memberAge']
                  }
                }
              }
            ],
            'as': 'matchedBooks'
          }
        },
        {
          '\$match': {
            'matchedBooks': { '\$ne': [] }
          }
        },
        {
          '\$unwind': '\$matchedBooks'
        },
        {
          '\$project': {
            '_id': 0,
            'maTV': 1,
            'tenTV': 1,
            'tuoi': 1,
            'maSach': '\$matchedBooks.maSach',
            'tenSach': '\$matchedBooks.tenSach',
            'soTrang': '\$matchedBooks.soTrang'
          }
        }
      ];
      
      final result = await membersCollection.aggregate(pipeline).toList();
      return result;
    } catch (e) {
      print('Lỗi khi thực hiện nối θ: $e');
      return [];
    }
  }

  // Lấy danh sách tất cả tác giả
  static Future<List<Map<String, dynamic>>> getAllAuthors() async {
    try {
      final db = MongoDBService.db;
      final authorCollection = db.collection('authors');
      final results = await authorCollection.find().toList();
      return results;
    } catch (e) {
      print('Lỗi khi lấy danh sách tác giả: $e');
      return [];
    }
  }
}
```

### Triển khai giao diện người dùng

#### 1. Màn hình chính

Tạo file `lib/screens/home_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:library_management_app/repositories/relational_operations.dart';
import 'package:library_management_app/screens/operations/selection_demo_screen.dart';
import 'package:library_management_app/screens/operations/projection_demo_screen.dart';
// Import các màn hình khác

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý Thư viện Sách'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Các phép toán đại số quan hệ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('1. Phép chọn (Selection)'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectionDemoScreen()),
                );
              },
            ),
            ListTile(
              title: Text('2. Phép chiếu (Projection)'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectionDemoScreen()),
                );
              },
            ),
            // Thêm các phép toán khác
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 1.0,
        children: [
          _buildCard(
            context,
            'Sách',
            Icons.book,
            () {
              // Navigator.push đến màn hình quản lý sách
            },
          ),
          _buildCard(
            context,
            'Thành viên',
            Icons.people,
            () {
              // Navigator.push đến màn hình quản lý thành viên
            },
          ),
          _buildCard(
            context,
            'Mượn sách',
            Icons.swap_horiz,
            () {
              // Navigator.push đến màn hình quản lý mượn sách
            },
          ),
          _buildCard(
            context,
            'Thống kê',
            Icons.bar_chart,
            () {
              // Navigator.push đến màn hình thống kê
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2.0,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50.0,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### 2. Màn hình demo phép chọn

Tạo file `lib/screens/operations/selection_demo_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:library_management_app/repositories/relational_operations.dart';

class SelectionDemoScreen extends StatefulWidget {
  @override
  _SelectionDemoScreenState createState() => _SelectionDemoScreenState();
}

class _SelectionDemoScreenState extends State<SelectionDemoScreen> {
  final TextEditingController _categoryController = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _performSelection() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final category = _categoryController.text.trim();
      if (category.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng nhập thể loại')),
        );
        return;
      }

      final results = await RelationalOperations.selection(
        'books',
        {'theLoai': category},
      );

      setState(() {
        _results = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phép chọn (Selection)'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Giải thích: Phép chọn trả về các bản ghi thỏa mãn điều kiện được chỉ định.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Ví dụ: Lấy ra các sách thuộc thể loại cụ thể',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Nhập thể loại (Ví dụ: CNTT)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _performSelection,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Thực hiện phép chọn'),
            ),
            SizedBox(height: 16),
            Text(
              'Kết quả:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? Center(child: Text('Không có kết quả'))
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final book = _results[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(book['tenSach'] ?? ''),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Mã sách: ${book['maSach'] ?? ''}'),
                                    Text('Thể loại: ${book['theLoai'] ?? ''}'),
                                    Text('Giá bán: ${book['giaBan'] ?? 0}'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Chạy ứng dụng

Sau khi hoàn thành các bước trên, bạn có thể chạy ứng dụng bằng lệnh:

   ```bash
   flutter run
   ```

### Đóng gói ứng dụng

#### Android

```bash
flutter build apk --release
```

#### iOS

```bash
flutter build ios --release
```

#### Web

```bash
flutter build web --release
```

## Đóng gói và triển khai

### Đóng gói ứng dụng

#### Android

```bash
flutter build apk --release
```

#### iOS

```bash
flutter build ios --release
```

#### Web

```bash
flutter build web --release
```

## Tài liệu tham khảo

- [MongoDB Documentation](https://docs.mongodb.com/)
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)