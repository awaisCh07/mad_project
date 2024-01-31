import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ams_employees/constants.dart';
import 'package:ams_employees/custom_widgets/custom_drawer.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool isDataVisible = false;
  List<Map<String, dynamic>> attendanceDataList = [];

  Future<void> _getDataFromApi(int userId, String filterType, String startDate,
      String endDate, String pageNumber, String pageSize) async {
    final apiUrl =
        'http://192.168.0.110:8080/attendance/?user_id=$userId&filter_type=$filterType&start_date=$startDate&end_date=$endDate&page_number=$pageNumber&page_size=$pageSize';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData is List) {
        setState(() {
          isDataVisible = true;
          attendanceDataList = List<Map<String, dynamic>>.from(jsonData);
        });

        print('Fetched Attendance Data: $attendanceDataList');
      } else {
        print('Invalid response format: $jsonData');
      }
    } else {
      print(
          'Failed to fetch data from API. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      drawer: const SafeArea(child: CustomDrawer()),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Image.asset(
          'assets/images/wb_logo.png',
          height: 17,
          width: 90,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            tooltip: 'Show Message',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('handle messages')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Attendance Screen',
                style: kHeadingTextStyle,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  _getDataFromApi(
                      70, '3', '2023-07-01', '2023-08-08', '2', '10');
                },
                child: const Text(
                  'Get Data',
                  style: kButtonTextStyle,
                ),
              ),
              Visibility(
                visible: isDataVisible,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: attendanceDataList.map((entry) {
                      final checkInTime = entry['check_in_time'];
                      final checkOutTime = entry['check_out_time'];
                      final date = entry['date'];
                      final timeWorked = entry['time_worked'];
                      return Text(
                        'Date: $date, Check In: $checkInTime, Check Out: $checkOutTime, Time Worked: $timeWorked',
                        style: const TextStyle(color: Colors.white),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
