import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/*
Health Calendar Widget:
- Displays the user's saved food items and saved medications on a calendar
- Allows the user to select a day and view the events for that day
- Allows a user to create a new food item or medication for the selected day (a shortcut to that screen)
- Color code by type: Food Item (red) or Medication (blue)
- Should let the user filter by type, the default is all.
- The calendar days should show dots for the events on that day, color coded by type
- The calendar items for the selected day should be displayed in a list, and also indicate the type of item nicely.
- The selected day should have a date displayed at the top of the list
*/
class HealthCalendarWidget extends StatefulWidget {
  final Function(DateTime, DateTime)? onDaySelected;
  final Set<DateTime>? eventDays;
  final Set<DateTime>? foodEventDays; // {{ New parameter for food item dates }}
  final Set<DateTime>? medicationDays;
  final Set<DateTime>? exerciseEventDays; // New parameter for exercises

  HealthCalendarWidget({
    this.onDaySelected,
    this.eventDays,
    this.foodEventDays, // {{ Include foodEventDays in the constructor }}
    this.medicationDays,
    this.exerciseEventDays, // Include exerciseEventDays in the constructor
  });

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
      // Updated eventLoader to handle medications, food items, and exercises
      eventLoader: (day) {
        List<String> events = [];
        DateTime normalizedDay = DateTime(day.year, day.month, day.day);

        if (widget.medicationDays != null &&
            widget.medicationDays!.contains(normalizedDay)) {
          events.add('medication');
        }
        if (widget.foodEventDays != null &&
            widget.foodEventDays!.contains(normalizedDay)) {
          events.add('food');
        }
        if (widget.exerciseEventDays != null &&
            widget.exerciseEventDays!.contains(normalizedDay)) {
          events.add('exercise');
        }
        return events;
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          if (widget.onDaySelected != null) {
            widget.onDaySelected!(selectedDay, focusedDay);
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
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          List<Widget> markers = [];
          for (var event in events) {
            if (event == 'medication') {
              markers.add(
                Positioned(
                  bottom: 1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue, // Blue marker for medications
                    ),
                  ),
                ),
              );
            } else if (event == 'food') {
              markers.add(
                Positioned(
                  bottom: 1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red, // Red marker for food items
                    ),
                  ),
                ),
              );
            } else if (event == 'exercise') {
              markers.add(
                Positioned(
                  bottom: 1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green, // Green marker for exercises
                    ),
                  ),
                ),
              );
            }
          }
          return Row(children: markers);
        },
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
      ),
    );
  }
}
