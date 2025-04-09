import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/models/ticket_model.dart';
import 'package:gotta_go/screens/page_screens/ticket/ticket_seat_screen.dart';
import 'package:gotta_go/screens/page_screens/ticket/ticket_map_screen.dart';
import 'package:gotta_go/services/ticket_service.dart';
import 'package:gotta_go/widgets/loading_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailScreen extends StatefulWidget {
  final TicketModel ticketModel;

  const TicketDetailScreen({
    super.key,
    required this.ticketModel,
  });

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final _currencyFormatter =
      NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  final _dateFormatter = DateFormat('dd/MM/yyyy - HH:mm');
  
  // Vị trí đích (hardcode tạm thời, trong thực tế nên lấy từ dữ liệu thực)
  final LatLng destination = const LatLng(10.800021, 106.654416);

  GlobalKey globalKey = GlobalKey();

  String _formatDateTime(String dateTimeStr) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeStr);
      return _dateFormatter.format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  String generateTicketQRData() {
    Map<String, String> mapData = {
      "ticketId": widget.ticketModel.ticketId!,
    };
    return jsonEncode(mapData);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF2FD),
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        title: const Text(
          'Chi tiết vé',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildTicketCard(screenWidth),
              const SizedBox(height: 20),
              _buildDirectionButton(),
              const SizedBox(height: 15),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(double screenWidth) {
    return RepaintBoundary(
      key: globalKey,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            _buildTicketHeader(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTripInfo(),
                  const SizedBox(height: 20),
                  _buildDashLine(screenWidth - 80), // Trừ padding
                  const SizedBox(height: 20),
                  _buildTimeAndSeatInfo(),
                  const SizedBox(height: 20),
                  _buildDashLine(screenWidth - 80),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  "Quét mã QR để kiểm tra vé",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: QrImageView(
                    data: generateTicketQRData(),
                    size: 180,
                    version: QrVersions.auto,
                    padding: EdgeInsets.zero,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Mã vé: ${widget.ticketModel.ticketId}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
            _buildPriceSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Constants.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          const Icon(Icons.confirmation_number, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mã vé', style: TextStyle(color: Colors.white70)),
                Text(
                  widget.ticketModel.scheduleId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Constants.backgroundColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Constants.backgroundColor,
                      size: 30,
                    ),
                  ),
                  Text(
                    'Điểm đi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                    child: Dash(
                      direction: Axis.horizontal,
                      length: MediaQuery.of(context).size.width * 0.3,
                      dashLength: 6,
                      dashColor: Constants.backgroundColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Constants.backgroundColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.flag,
                      color: Constants.backgroundColor,
                      size: 30,
                    ),
                  ),
                  Text(
                    'Điểm đến',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ticketModel.from,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.ticketModel.to,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDashLine(double width) {
    return SizedBox(
      width: width,
      child: const Dash(
        direction: Axis.horizontal,
        length: 300,
        dashLength: 5,
        dashColor: Colors.grey,
      ),
    );
  }

  Widget _buildTimeAndSeatInfo() {
    final departureTime = _formatDateTime(widget.ticketModel.departureTime);
    final arrivalTime = _formatDateTime(widget.ticketModel.arrivalTime);
    
    // Tách ngày và giờ
    final departureParts = departureTime.split(' - ');
    final departureDate = departureParts[0];
    final departureHour = departureParts[1];
    
    final arrivalParts = arrivalTime.split(' - ');
    final arrivalDate = arrivalParts[0];
    final arrivalHour = arrivalParts[1];
    
    // Lấy danh sách tất cả các ghế
    final allSeats = [...widget.ticketModel.floor1, ...widget.ticketModel.floor2];
    final formattedSeats = allSeats.join(", ");

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Khởi hành', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Constants.backgroundColor),
                      SizedBox(width: 5),
                      Text(
                        departureDate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Constants.backgroundColor),
                      SizedBox(width: 5),
                      Text(
                        departureHour,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Constants.backgroundColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Constants.backgroundColor,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Đến nơi', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Constants.backgroundColor),
                      SizedBox(width: 5),
                      Text(
                        arrivalDate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.access_time, size: 16, color: Constants.backgroundColor),
                      SizedBox(width: 5),
                      Text(
                        arrivalHour,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.event_seat, color: Constants.backgroundColor),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ghế", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Text(
                    formattedSeats,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TicketSeatScreen(ticketModel: widget.ticketModel),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Constants.backgroundColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Constants.backgroundColor,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.visibility, size: 16, color: Constants.backgroundColor),
                    SizedBox(width: 4),
                    Text(
                      "Xem sơ đồ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Constants.backgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        gradient: Constants.mainGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Giá vé',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                _currencyFormatter.format(widget.ticketModel.price),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Phí dịch vụ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                _currencyFormatter.format(0), // Giả sử miễn phí dịch vụ
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              color: Colors.white.withOpacity(0.3),
              thickness: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng tiền',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                _currencyFormatter.format(widget.ticketModel.price),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'Đã thanh toán',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              try {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => LoadingWidget(),
                );

                await TicketServices.downloadTicket(globalKey);
                Navigator.pop(context); // Đóng loading

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tải vé thành công')),
                );
              } catch (e) {
                Navigator.pop(context); // Đóng loading
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            icon: const Icon(Icons.download),
            label: const Text('Tải vé'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.backgroundColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement share ticket
              TicketServices.shareTicket(globalKey);
            },
            icon: const Icon(Icons.share),
            label: const Text('Chia sẻ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Constants.backgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Constants.backgroundColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Constants.backgroundColor),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDirectionButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: Constants.mainGradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          Constants.mainShadow,
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => TicketMapScreen(destination: destination),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions, 
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  "Xem lộ trình & thời gian đến",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
