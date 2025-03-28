import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gotta_go/constants/global.dart';
import 'package:gotta_go/models/search_history_model.dart';

class SearchHistoryService {
  final CollectionReference _searchHistoryCollection =
      FirebaseFirestore.instance.collection('searchHistory');

  // Lưu lịch sử tìm kiếm mới vào Firestore
  Future<void> saveSearchHistory(
      String fromLocation, String toLocation, DateTime searchDate) async {
    try {
      if (firebaseAuth.currentUser == null) {
        // Không lưu lịch sử nếu người dùng chưa đăng nhập
        print("Không thể lưu lịch sử tìm kiếm: Người dùng chưa đăng nhập");
        return;
      }

      final String userId = firebaseAuth.currentUser!.uid;
      final DateTime now = DateTime.now();

      // Kiểm tra xem đã có lịch sử tìm kiếm tương tự chưa
      final QuerySnapshot existingHistory = await _searchHistoryCollection
          .where('userId', isEqualTo: userId)
          .where('fromLocation', isEqualTo: fromLocation)
          .where('toLocation', isEqualTo: toLocation)
          .limit(1)
          .get();

      if (existingHistory.docs.isNotEmpty) {
        // Nếu đã có, cập nhật thời gian createdAt
        await _searchHistoryCollection.doc(existingHistory.docs.first.id).update({
          'searchDate': Timestamp.fromDate(searchDate),
          'createdAt': Timestamp.fromDate(now),
        });
      } else {
        // Nếu chưa có, tạo mới
        await _searchHistoryCollection.add({
          'userId': userId,
          'fromLocation': fromLocation,
          'toLocation': toLocation,
          'searchDate': Timestamp.fromDate(searchDate),
          'createdAt': Timestamp.fromDate(now),
        });
      }

      print("Đã lưu lịch sử tìm kiếm thành công");
    } catch (e) {
      print("Lỗi khi lưu lịch sử tìm kiếm: $e");
      Fluttertoast.showToast(
          msg: "Không thể lưu lịch sử tìm kiếm: $e",
          backgroundColor: Colors.red);
    }
  }

  // Xóa một mục lịch sử tìm kiếm theo ID
  Future<void> deleteSearchHistory(String historyId) async {
    try {
      await _searchHistoryCollection.doc(historyId).delete();
      print("Đã xóa lịch sử tìm kiếm thành công");
    } catch (e) {
      print("Lỗi khi xóa lịch sử tìm kiếm: $e");
      Fluttertoast.showToast(
          msg: "Không thể xóa lịch sử tìm kiếm: $e",
          backgroundColor: Colors.red);
    }
  }

  // Xóa tất cả lịch sử tìm kiếm của người dùng hiện tại
  Future<void> clearAllSearchHistory() async {
    try {
      if (firebaseAuth.currentUser == null) {
        return;
      }

      final String userId = firebaseAuth.currentUser!.uid;
      final QuerySnapshot historySnapshot = await _searchHistoryCollection
          .where('userId', isEqualTo: userId)
          .get();

      // Xóa từng document trong writeBatch để tăng hiệu suất
      final WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var doc in historySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      print("Đã xóa tất cả lịch sử tìm kiếm");
      Fluttertoast.showToast(
          msg: "Đã xóa tất cả lịch sử tìm kiếm",
          backgroundColor: Colors.green);
    } catch (e) {
      print("Lỗi khi xóa tất cả lịch sử tìm kiếm: $e");
      Fluttertoast.showToast(
          msg: "Không thể xóa lịch sử tìm kiếm: $e",
          backgroundColor: Colors.red);
    }
  }

  // Thêm phương thức mới để lấy stream lịch sử tìm kiếm
  Stream<List<SearchHistoryModel>> getSearchHistoryStream() {
    if (firebaseAuth.currentUser == null) {
      // Trả về stream rỗng nếu người dùng chưa đăng nhập
      return Stream.value([]);
    }

    final String userId = firebaseAuth.currentUser!.uid;
    
    // Thay vì dùng where + orderBy, chỉ cần dùng where cho userId
    // Và sắp xếp sau khi đã lấy dữ liệu về
    return _searchHistoryCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          List<SearchHistoryModel> history = snapshot.docs
              .map((doc) => SearchHistoryModel.fromSnapshot(doc))
              .toList();
              
          // Sắp xếp theo createdAt giảm dần (mới nhất đầu tiên)
          history.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          
          // Giới hạn số lượng kết quả
          if (history.length > 10) {
            return history.sublist(0, 10);
          }
          
          return history;
        });
  }
} 