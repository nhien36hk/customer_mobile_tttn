# Cấu trúc Cơ sở dữ liệu MongoDB và Các Model

## Collections MongoDB

### 1. Collection `books`
```json
{
  "_id": ObjectId("..."),
  "maSach": "S01",
  "tenSach": "Dạy Nấu Ăn",
  "theLoai": "Đời sống",
  "giaBan": 50000,
  "soTrang": 100,
  "tacGia": "Nguyễn Văn A",
  "nhaXuatBan": "NXB Giáo Dục",
  "namXuatBan": 2020,
  "soLuong": 10,
  "trangThai": "Còn sách",
  "moTa": "Sách dạy nấu ăn cơ bản cho người mới bắt đầu",
  "hinhAnh": "https://example.com/image.jpg",
  "ngayNhap": ISODate("2023-01-01"),
  "danh_gia_trung_binh": 4.5
}
```

### 2. Collection `members`
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

### 3. Collection `borrows`
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

### 4. Collection `categories`
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

## Các Model trong Flutter

### 1. Book Model

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

### 2. Member Model

```dart
class Member {
  final String? id;
  final String maTV;
  final String tenTV;
  final int tuoi;
  final String soDT;
  final String email;
  final String diaChi;
  final DateTime ngaySinh;
  final String gioiTinh;
  final DateTime ngayDangKy;
  final DateTime hanThe;
  final int diem;
  final String trangThai;

  Member({
    this.id,
    required this.maTV,
    required this.tenTV,
    required this.tuoi,
    required this.soDT,
    required this.email,
    required this.diaChi,
    required this.ngaySinh,
    required this.gioiTinh,
    required this.ngayDangKy,
    required this.hanThe,
    required this.diem,
    required this.trangThai,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['_id']?.toString(),
      maTV: json['maTV'],
      tenTV: json['tenTV'],
      tuoi: json['tuoi'],
      soDT: json['soDT'],
      email: json['email'],
      diaChi: json['diaChi'],
      ngaySinh: json['ngaySinh'] is DateTime 
        ? json['ngaySinh'] 
        : DateTime.parse(json['ngaySinh'].toString()),
      gioiTinh: json['gioiTinh'],
      ngayDangKy: json['ngayDangKy'] is DateTime 
        ? json['ngayDangKy'] 
        : DateTime.parse(json['ngayDangKy'].toString()),
      hanThe: json['hanThe'] is DateTime 
        ? json['hanThe'] 
        : DateTime.parse(json['hanThe'].toString()),
      diem: json['diem'],
      trangThai: json['trangThai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maTV': maTV,
      'tenTV': tenTV,
      'tuoi': tuoi,
      'soDT': soDT,
      'email': email,
      'diaChi': diaChi,
      'ngaySinh': ngaySinh,
      'gioiTinh': gioiTinh,
      'ngayDangKy': ngayDangKy,
      'hanThe': hanThe,
      'diem': diem,
      'trangThai': trangThai,
    };
  }
}
```

### 3. Borrow Model

```dart
class Borrow {
  final String? id;
  final String maTV;
  final String maSach;
  final DateTime ngayMuon;
  final DateTime ngayTra;
  final String trangThai;
  final String ghiChu;
  final String nhanVienChoMuon;
  final String nhanVienNhan;
  final int soLuong;
  final int tienCoc;
  final int tienPhat;

  Borrow({
    this.id,
    required this.maTV,
    required this.maSach,
    required this.ngayMuon,
    required this.ngayTra,
    required this.trangThai,
    required this.ghiChu,
    required this.nhanVienChoMuon,
    required this.nhanVienNhan,
    required this.soLuong,
    required this.tienCoc,
    required this.tienPhat,
  });

  factory Borrow.fromJson(Map<String, dynamic> json) {
    return Borrow(
      id: json['_id']?.toString(),
      maTV: json['maTV'],
      maSach: json['maSach'],
      ngayMuon: json['ngayMuon'] is DateTime 
        ? json['ngayMuon'] 
        : DateTime.parse(json['ngayMuon'].toString()),
      ngayTra: json['ngayTra'] is DateTime 
        ? json['ngayTra'] 
        : DateTime.parse(json['ngayTra'].toString()),
      trangThai: json['trangThai'],
      ghiChu: json['ghiChu'],
      nhanVienChoMuon: json['nhanVienChoMuon'],
      nhanVienNhan: json['nhanVienNhan'],
      soLuong: json['soLuong'],
      tienCoc: json['tienCoc'],
      tienPhat: json['tienPhat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maTV': maTV,
      'maSach': maSach,
      'ngayMuon': ngayMuon,
      'ngayTra': ngayTra,
      'trangThai': trangThai,
      'ghiChu': ghiChu,
      'nhanVienChoMuon': nhanVienChoMuon,
      'nhanVienNhan': nhanVienNhan,
      'soLuong': soLuong,
      'tienCoc': tienCoc,
      'tienPhat': tienPhat,
    };
  }
}
```

### 4. Category Model

```dart
class Category {
  final String? id;
  final String maTheLoai;
  final String tenTheLoai;
  final String moTa;
  final String viTri;
  final int soLuongSach;

  Category({
    this.id,
    required this.maTheLoai,
    required this.tenTheLoai,
    required this.moTa,
    required this.viTri,
    required this.soLuongSach,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id']?.toString(),
      maTheLoai: json['maTheLoai'],
      tenTheLoai: json['tenTheLoai'],
      moTa: json['moTa'],
      viTri: json['viTri'],
      soLuongSach: json['soLuongSach'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maTheLoai': maTheLoai,
      'tenTheLoai': tenTheLoai,
      'moTa': moTa,
      'viTri': viTri,
      'soLuongSach': soLuongSach,
    };
  }
}
``` 