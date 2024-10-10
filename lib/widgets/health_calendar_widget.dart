import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HealthCalendarWidget extends StatefulWidget {
  final Function(DateTime, DateTime)? onDaySelected;
  final Set<DateTime>? eventDays; // {{ Added eventDays parameter }}

  HealthCalendarWidget(
      {this.onDaySelected, this.eventDays}); // {{ Updated constructor }}

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
      // Add eventLoader to display markers
      eventLoader: (day) {
        return widget.eventDays != null &&
                widget.eventDays!
                    .contains(DateTime(day.year, day.month, day.day))
            ? ['•'] // Using a simple dot as an event
            : [];
      },
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
        // Customize marker decoration
        markerDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
      ),
    );
  }
}
