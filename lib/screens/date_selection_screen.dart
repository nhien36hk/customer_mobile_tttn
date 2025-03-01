import 'package:flutter/material.dart';
import 'package:gotta_go/constants/constant.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class DateSelectionScreen extends StatefulWidget {
  const DateSelectionScreen({super.key});

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  final _firstDay = DateTime.now();
  final _lastDay = DateTime.now().add(const Duration(days: 90));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Gradient Overlay
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/dalat.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Chọn ngày khởi hành thôi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // Balance for close button
                    ],
                  ),
                ),

                // Calendar Container
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: TableCalendar(
                        firstDay: _firstDay,
                        lastDay: _lastDay,
                        focusedDay: _focusedDay,
                        calendarFormat: CalendarFormat.month,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        headerStyle: HeaderStyle(
                          titleTextStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          formatButtonVisible: false,
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: Constants.backgroundColor,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: Constants.backgroundColor,
                          ),
                          headerPadding: const EdgeInsets.symmetric(vertical: 0),
                          titleCentered: true,
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Constants.backgroundColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Constants.backgroundColor,
                            shape: BoxShape.circle,
                          ),
                          weekendTextStyle: TextStyle(color: Colors.red[300]),
                          outsideDaysVisible: true,
                          cellMargin: const EdgeInsets.all(4),
                          cellPadding: const EdgeInsets.all(0),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: const TextStyle(fontWeight: FontWeight.bold),
                          weekendStyle: TextStyle(
                            color: Colors.red[300],
                            fontWeight: FontWeight.bold,
                          ),
                          dowTextFormatter: (date, locale) {
                            return DateFormat.E(locale).format(date)[0];
                          },
                        ),
                        rowHeight: 40,
                        daysOfWeekHeight: 20,
                      ),
                    ),
                  ),
                ),

                // Bottom Button
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_selectedDay != null) ...[
                        Text(
                          'Bạn đã chọn:',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          DateFormat('EEEE, dd/MM/yyyy', 'vi_VN')
                              .format(_selectedDay!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      ElevatedButton(
                        onPressed: _selectedDay != null
                            ? () => Navigator.pop(context, _selectedDay)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Xác nhận',
                          style: TextStyle(
                            color: Constants.backgroundColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 