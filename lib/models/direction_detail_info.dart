class DirectionDetailInfo {
  String distance_text;
  String duration_text;
  double distance_value;
  double duration_value;
  String e_points;

  DirectionDetailInfo({
    required this.distance_text,
    required this.duration_text,
    required this.distance_value,
    required this.duration_value,
    required this.e_points,
  });

  // Factory constructor để tạo model từ response API
  factory DirectionDetailInfo.fromJson(Map<String, dynamic> response) {
    if (response["code"] != "Ok" || response["routes"] == null || response["routes"].isEmpty) {
      throw Exception("Lỗi khi lấy thông tin đường đi");
    }

    // Lấy thông tin về geometry
    var geometry = response["routes"][0]["geometry"];
    
    // Lấy thông tin về thời gian
    double durationValue = response["routes"][0]["duration"].toDouble();
    String durationText = (durationValue / 60).toStringAsFixed(0) + " phút";
    
    // Mặc định giá trị khoảng cách
    double? distanceValue;
    String? distanceText;
    
    // Thông tin về legs chứa khoảng cách
    var legs = response["routes"][0]["legs"];
    if (legs != null && legs.isNotEmpty) {
      distanceValue = legs[0]["distance"].toDouble();
      distanceText = (distanceValue! / 1000).toStringAsFixed(1) + " km";
    }

    // Trả về đối tượng mới với các giá trị đã xử lý
    return DirectionDetailInfo(
      e_points: geometry,
      duration_value: durationValue,
      duration_text: durationText,
      distance_value: distanceValue!,
      distance_text: distanceText!,
    );
  }

  // Phương thức chuyển đổi model thành JSON
  Map<String, dynamic> toJson() {
    return {
      'e_points': e_points,
      'distance_value': distance_value,
      'distance_text': distance_text,
      'duration_value': duration_value,
      'duration_text': duration_text,
    };
  }
} 