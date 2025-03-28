import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/models/search_history_model.dart';
import 'package:gotta_go/services/bus_services.dart';
import 'package:gotta_go/services/search_history_service.dart';
import 'package:intl/intl.dart';

class SearchHistoryWidget extends StatefulWidget {
  final Function(String, String, DateTime) onHistorySelected;

  const SearchHistoryWidget({
    Key? key,
    required this.onHistorySelected,
  }) : super(key: key);

  @override
  State<SearchHistoryWidget> createState() => _SearchHistoryWidgetState();
}

class _SearchHistoryWidgetState extends State<SearchHistoryWidget> {
  final SearchHistoryService _searchHistoryService = SearchHistoryService();
  Stream<List<SearchHistoryModel>>? _searchHistoryStream;

  @override
  void initState() {
    super.initState();
    _searchHistoryStream = _searchHistoryService.getSearchHistoryStream();
  }

  Future<void> _deleteHistoryItem(String historyId) async {
    await _searchHistoryService.deleteSearchHistory(historyId);
  }

  Future<void> _clearAllHistory() async {
    await _searchHistoryService.clearAllSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lịch sử tìm kiếm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StreamBuilder<List<SearchHistoryModel>>(
                  stream: _searchHistoryStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return TextButton(
                        onPressed: _clearAllHistory,
                        child: const Text(
                          'Xóa tất cả',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          StreamBuilder<List<SearchHistoryModel>>(
            stream: _searchHistoryStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Lỗi: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Chưa có lịch sử tìm kiếm',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }
              
              // Có dữ liệu
              final histories = snapshot.data!;
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: histories.length,
                separatorBuilder: (context, index) => SizedBox(height: 1),
                itemBuilder: (context, index) {
                  final history = histories[index];
                  return Card(
                    child: ListTile(
                      onTap: () {
                        widget.onHistorySelected(
                          history.fromLocation,
                          history.toLocation,
                          history.searchDate,
                        );
                      },
                      leading: const Icon(
                        Icons.history,
                        color: Constants.backgroundColor,
                      ),
                      title: Text(
                        '${history.fromLocation} → ${history.toLocation}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Tìm kiếm vào: ${DateFormat('dd/MM/yyyy HH:mm').format(history.createdAt)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => _deleteHistoryItem(history.id),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
