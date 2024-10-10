import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HealthCalendarWidget extends StatefulWidget {
  final Function(DateTime, DateTime)? onDaySelected;

  HealthCalendarWidget({this.onDaySelected});

  @override
  _HealthCalendarWidgetState createState() => _HealthCalendarWidgetState();
}

class _HealthCalendarWidgetState extends State<HealthCalendarWidget> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      // Modified onDaySelected to accept only two parameters
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          if (widget.onDaySelected != null) {
            widget.onDaySelected!(
                selectedDay, focusedDay); // Invoke callback if provided
          }
        }
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
      ),
    );
  }
}
