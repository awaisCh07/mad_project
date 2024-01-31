import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ams_employees/constants.dart';
import 'package:ams_employees/custom_widgets/my_custom_app_bar.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({Key? key}) : super(key: key);

  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  DateTime? _focusedDay;
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyCustomAppBar(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Leave Screen Content',
                style: TextStyle(fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _rangeSelectionMode = RangeSelectionMode
                        .toggledOn; // Enable range selection mode
                  });
                },
                child: const Text('Select Date Range'),
              ),
              if (_selectedDateRange != null)
                Text(
                  'Selected Date Range: ${_selectedDateRange!.start.toString()} - ${_selectedDateRange!.end.toString()}',
                ),
              if (_rangeSelectionMode == RangeSelectionMode.toggledOn)
                SizedBox(
                  height: 400, // Adjust the height as needed
                  child: _buildCalendar(),
                ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedDateRange = null;
                    _rangeSelectionMode = RangeSelectionMode
                        .toggledOff; // Disable range selection mode
                  });
                },
                child: const Text('Clear Selection'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build the calendar widget
  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime(DateTime.now().year - 1),
      lastDay: DateTime(DateTime.now().year + 1),
      focusedDay: _focusedDay ?? DateTime.now(),
      rangeSelectionMode: _rangeSelectionMode,
      selectedDayPredicate: (day) {
        return _selectedDateRange != null &&
            day.isAfter(_selectedDateRange!.start) &&
            day.isBefore(_selectedDateRange!.end);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
          if (_rangeSelectionMode == RangeSelectionMode.toggledOn) {
            if (_selectedStartDate == null || _selectedEndDate != null) {
              _selectedStartDate = selectedDay;
              _selectedEndDate = null;
            } else if (_selectedStartDate != null) {
              _selectedEndDate = selectedDay;
              _selectedDateRange = DateTimeRange(
                start: _selectedStartDate!,
                end: _selectedEndDate!,
              );
            }
          }
        });
      },
    );
  }
}
