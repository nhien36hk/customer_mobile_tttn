import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:gotta_go/models/ticket_model.dart';
import 'package:gotta_go/screens/seat_detail_screen.dart';
import 'package:gotta_go/services/ticket_service.dart';
import 'package:gotta_go/widgets/loading_widget.dart';
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
                  const SizedBox(height: 20),
                  _buildCustomerInfo(),
                ],
              ),
            ),
            QrImageView(
              data: generateTicketQRData(),
              size: 200,
              version: QrVersions.auto,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.ticketModel.status,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripInfo() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Từ', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 5),
              Text(
                widget.ticketModel.from,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward, color: Constants.backgroundColor),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Đến', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 5),
              Text(
                widget.ticketModel.to,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
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
    final seats =
        '${widget.ticketModel.floor1.join(", ")}\n${widget.ticketModel.floor2.join(", ")}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoColumn(
            'Thời gian', departureTime.split(' - ')[1], Icons.access_time),
        _buildInfoColumn(
            'Ngày', departureTime.split(' - ')[0], Icons.calendar_today),
        Column(
          children: [
            Icon(Icons.event_seat, color: Constants.backgroundColor),
            const SizedBox(height: 5),
            Text("Ghế", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SeatDetailScreen(ticketModel: widget.ticketModel),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Chi tiết",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mã khách hàng', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 5),
              Text(
                widget.ticketModel.customerId,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tổng tiền',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            _currencyFormatter.format(widget.ticketModel.price),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Constants.backgroundColor,
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
}
