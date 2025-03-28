import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistoryModel {
  String id;
  String fromLocation;
  String toLocation;
  DateTime searchDate;
  DateTime createdAt;
  String userId;

  SearchHistoryModel({
    required this.id,
    required this.fromLocation,
    required this.toLocation,
    required this.searchDate,
    required this.createdAt,
    required this.userId,
  });

  // Chuyển đổi từ DocumentSnapshot sang model
  factory SearchHistoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return SearchHistoryModel(
      id: snapshot.id,
      fromLocation: data['fromLocation'] ?? '',
      toLocation: data['toLocation'] ?? '',
      searchDate: (data['searchDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
    );
  }

  // Chuyển đổi từ model sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'fromLocation': fromLocation,
      'toLocation': toLocation,
      'searchDate': Timestamp.fromDate(searchDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'userId': userId,
    };
  }
} 