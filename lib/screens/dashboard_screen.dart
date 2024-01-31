import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ams_employees/constants.dart';
import 'package:ams_employees/custom_widgets/my_custom_app_bar.dart';
import 'package:ams_employees/custom_widgets/custom_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final DateFormat _dateFormat = DateFormat('E, d MMM y h:mm a');
  String selectedDropdownValue = 'This Month';
  DateTime? checkInDateTime;
  DateTime? checkOutDateTime;
  bool isCheckedIn = false;
  bool isOnBreak = false;
  DateTime? breakStartTime;
  DateTime? breakEndTime;
  Duration breakDuration = const Duration(seconds: 0);

  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference<Map<String, dynamic>> attendanceCollection =
      FirebaseFirestore.instance.collection('Employee');

  Stream<QuerySnapshot<Map<String, dynamic>>> getAttendanceStream() {
    return attendanceCollection.snapshots();
  }

  List<AttendanceRecord> fetchedData = [];
  void fetchDataFromFirebase() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userEmail = user.email;
      final userName = userEmail?.substring(0, userEmail.indexOf('@'));
      final TimeAndDate = DateTime.now();
      final checkInDate =
          DateFormat('dd MMM yyyy').format(TimeAndDate).toString();
      final docReference = FirebaseFirestore.instance
          .collection('Employee')
          .doc(userName)
          .collection('EmployeeAttendance')
          .doc(checkInDate);

      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await docReference.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final attendanceRecord = AttendanceRecord(
          date: data['CheckInDate'] ?? '',
          checkIn: data['CheckIn'] ?? '',
          checkOut: data['CheckOut'] ?? '',
          production: data['Production'] ?? '',
          breakTime: data['Break'] ?? '',
        );

        setState(() {
          fetchedData = [attendanceRecord];
        });
      } else {
        setState(() {
          fetchedData = [];
        });
      }
    }
  }

  Future<String?> getCurrentUserName() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userEmail = user.email;
      final userName = userEmail?.substring(0, userEmail.indexOf('@'));
      return userName;
    }
    return null;
  }

  TableCell buildTableCell({required String text}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          text,
          style: kFont10,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  ///TODO: manage state of checkin
  void onCheckInPressed() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userEmail = user.email;
      final userName = userEmail?.substring(0, userEmail.indexOf('@'));
      final TimeAndDate = DateTime.now();
      final checkInDate =
          DateFormat('dd MMM yyyy').format(TimeAndDate).toString();
      final checkInTimeFormatted =
          DateFormat('HH:mm a').format(TimeAndDate).toString();

      final docReference = firestore
          .collection('Employee')
          .doc(userName)
          .collection('EmployeeAttendance')
          .doc(checkInDate);

      await docReference.set(
        {
          'Email': userEmail,
          'CheckInDate': checkInDate,
          'CheckIn': checkInTimeFormatted,
        },
        SetOptions(
          merge: true,
        ),
      );

      setState(() {
        isCheckedIn = true;
        checkInDateTime = TimeAndDate;
      });
    }
  }

  void onCheckOutPressed() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userEmail = user.email;
      final userName = userEmail?.substring(0, userEmail.indexOf('@'));
      final TimeAndDate = DateTime.now();
      final checkInDate =
          DateFormat('dd MMM yyyy').format(TimeAndDate).toString();

      final docReference = firestore
          .collection('Employee')
          .doc(userName)
          .collection('EmployeeAttendance')
          .doc(checkInDate);

      if (checkInDateTime != null) {
        final checkOutTime = DateTime.now();
        final productionDuration = checkOutTime.difference(checkInDateTime!);

        final checkOutDate = DateFormat('yyyy-MM-dd').format(checkOutTime);
        final checkOutTimeFormatted =
            DateFormat('HH:mm a').format(checkOutTime);
        final productionTime =
            '${productionDuration.inHours.toString().padLeft(2, '0')} : ${productionDuration.inMinutes.remainder(60).toString().padLeft(2, '0')} hrs';

        final breakDurationFormatted =
            '${breakDuration.inHours.toString().padLeft(2, '0')} : ${breakDuration.inMinutes.remainder(60).toString().padLeft(2, '0')} hrs';

        await docReference.set(
          {
            'Email': userEmail,
            'CheckOutDate': checkOutDate.toString(),
            'CheckOut': checkOutTimeFormatted.toString(),
            'Production': productionTime,
            'Break': breakDurationFormatted,
          },
          SetOptions(merge: true),
        );

        setState(() {
          isCheckedIn = false;
          checkInDateTime = null;
          breakStartTime = null; // Reset break start time
          breakEndTime = null; // Reset break end time
          isOnBreak = false; // Reset break status
          breakDuration = const Duration(seconds: 0); // Reset break duration
        });

        fetchDataFromFirebase();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    Stream<Duration> elapsedStream = Stream<Duration>.periodic(
      const Duration(seconds: 1),
      (x) {
        if (isCheckedIn && checkInDateTime != null) {
          return DateTime.now().difference(checkInDateTime!);
        } else {
          return const Duration();
        }
      },
    );

    Stream<QuerySnapshot<Map<String, dynamic>>> getAttendanceStream() {
      final user = _auth.currentUser;
      if (user != null) {
        final userEmail = user.email;

        /// TODO: check it again if data is not being stored at right position
        return FirebaseFirestore.instance
            .collection('Employee')
            .doc('Awais')
            .collection('EmployeeAttendance')
            .where('Email', isEqualTo: userEmail)
            .snapshots();
      } else {
        return const Stream.empty();
      }
    }

    void saveBreakDurationToFirebase(Duration breakDuration) async {
      final user = _auth.currentUser;
      if (user != null) {
        final userEmail = user.email;
        final userName = userEmail?.substring(0, userEmail.indexOf('@'));
        final todayDateAndTime = DateTime.now();
        final todayDate =
            DateFormat('dd MMM yyyy').format(todayDateAndTime).toString();

        final docReference = firestore
            .collection('Employee')
            .doc('$userName')
            .collection('EmployeeAttendance')
            .doc(todayDate);

        final checkInTime = checkInDateTime;
        if (checkInTime != null) {
          final breakDurationFormatted =
              '${breakDuration.inHours.toString().padLeft(2, '0')} : ${breakDuration.inMinutes.remainder(60).toString().padLeft(2, '0')} hrs';

          await docReference.set(
            {
              'Break': breakDurationFormatted,
            },
            SetOptions(
              merge: true,
            ),
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: kPrimaryColor,
      drawer: const SafeArea(child: CustomDrawer()),
      appBar: const MyCustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Visibility(
                  visible: !isCheckedIn,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<String?>(
                      future: getCurrentUserName(),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return const Center(
                        //     child: Padding(
                        //       padding: EdgeInsets.all(120.0),
                        //       child: LoadingIndicator(
                        //         indicatorType: Indicator.cubeTransition,
                        //         colors: [Colors.white, Color(0xFFD1000B)],
                        //       ),
                        //     ),
                        //   );
                        // } else
                        if (snapshot.hasData && snapshot.data != null) {
                          String userName = snapshot.data!;
                          userName =
                              userName[0].toUpperCase() + userName.substring(1);
                          return Container(
                            margin:
                                const EdgeInsets.only(top: 50.0, bottom: 10.0),
                            child: Center(
                              child: Column(
                                children: [
                                  const Text(
                                    'Good Morning',
                                    style: kWelcomeUserTextStyle,
                                  ),
                                  Text(
                                    userName,
                                    style: kEmployeeNameMainScreen,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const Text(
                            'Hi, User',
                            style: kPageNameTextStyle,
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                StreamBuilder<Duration>(
                  stream: elapsedStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final elapsedDuration = snapshot.data!;
                      final hours =
                          elapsedDuration.inHours.toString().padLeft(2, '0');
                      final minutes = (elapsedDuration.inMinutes % 60)
                          .toString()
                          .padLeft(2, '0');
                      final seconds = (elapsedDuration.inSeconds % 60)
                          .toString()
                          .padLeft(2, '0');

                      final elapsedTimeString = '$hours:$minutes:$seconds Hrs';
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          elapsedTimeString,
                          style: kEmployeeNameMainScreen,
                        ),
                      );
                    } else {
                      return const Text(
                        '00:00:00 Hrs',
                        style: kEmployeeNameMainScreen,
                      );
                    }
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isCheckedIn)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            onCheckInPressed();
                          },
                          style: kCheckIn,
                          child: const Text(
                            'Check In',
                            style: kButtonTextStyle,
                          ),
                        ),
                      ),
                  ],
                ),
                Visibility(
                  visible: isCheckedIn,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      color: const Color(0xFF202020),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: const Color(0x47707070), width: 1),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(15),
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            color: const Color(0xFF262626),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0x47707070),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Check in at',
                                  style: kFont10,
                                ),
                                if (isCheckedIn && checkInDateTime != null)
                                  Text(
                                    _dateFormat.format(checkInDateTime!),
                                    style: kFont8.copyWith(
                                      color: const Color(0xFFA5A5A5),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (isOnBreak)
                          Column(
                            children: [
                              Text(
                                'Break',
                                style: kFont12.copyWith(fontSize: 14),
                              ),
                              StreamBuilder(
                                stream:
                                    Stream.periodic(const Duration(seconds: 1)),
                                builder: (context, snapshot) {
                                  breakDuration = DateTime.now()
                                      .difference(breakStartTime!);
                                  return Text(
                                    '${breakDuration.inHours.toString().padLeft(2, '0')}:${breakDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${breakDuration.inSeconds.remainder(60).toString().padLeft(2, '0')} hrs',
                                    style: kFont10.copyWith(
                                      color: const Color(0xFFA1A1A1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  if (isOnBreak) {
                                    breakEndTime = DateTime.now();
                                    breakDuration = breakEndTime!
                                        .difference(breakStartTime!);
                                    isOnBreak = false;

                                    saveBreakDurationToFirebase(breakDuration);
                                  } else {
                                    breakStartTime = DateTime.now();
                                    isOnBreak = true;
                                  }
                                });
                              },
                              child: Text(
                                isOnBreak ? 'Back to Work' : 'Take a Break',
                                style: kFont12.copyWith(
                                  color: const Color(0xFF1D90F5),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 60,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // fetchCheckOutTimeFromStream();
                                onCheckOutPressed();
                              },
                              style: kUserCheckOut,
                              child: Text(
                                'Check Out',
                                style: kButtonTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 90,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: const Color(0xFF202020),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: const Color(0x47707070), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Working Hours',
                              style: kFont12.copyWith(fontSize: 14),
                            ),
                            Container(
                              height: 25,
                              width: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFF707070),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: DropdownButton<String>(
                                    dropdownColor: const Color(0xFF202020),
                                    value: selectedDropdownValue,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedDropdownValue = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'This Month',
                                      'This Week',
                                    ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: kFont12),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          '00:00:00',
                          style: kEmployeeNameMainScreen,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: const Color(0xFF202020),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: const Color(0x47707070), width: 1),
                  ),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: getAttendanceStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(150.0),
                            child: LoadingIndicator(
                              indicatorType: Indicator.cubeTransition,
                              colors: [Colors.white, Color(0xFFD1000B)],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Text('No data available.');
                      } else {
                        List<AttendanceRecord> attendanceData =
                            snapshot.data!.docs
                                .map((doc) => AttendanceRecord(
                                      date: doc['CheckInDate'],
                                      checkIn: doc['CheckIn'],
                                      checkOut: doc['CheckOut'],
                                      production: doc['Production'],
                                      breakTime: doc['Break'],
                                    ))
                                .toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Attendance List',
                                style: kFont12.copyWith(fontSize: 14),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: attendanceData.isEmpty
                                  ? const BorderRadius.only(
                                      bottomRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0),
                                    )
                                  : BorderRadius.zero,
                              child: Table(
                                border: TableBorder.all(
                                  width: 1.0,
                                  color: const Color(0x87707070),
                                ),
                                children: [
                                  // Header row
                                  TableRow(
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    children: [
                                      buildTableCell(text: 'S. No'),
                                      buildTableCell(text: 'Date'),
                                      buildTableCell(text: 'Check In'),
                                      buildTableCell(text: 'Check Out'),
                                      buildTableCell(text: 'Production'),
                                      buildTableCell(text: 'Break'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: attendanceData.length,
                                itemBuilder: (context, index) {
                                  final record = attendanceData[index];
                                  return Table(
                                    border: TableBorder.symmetric(
                                      inside: const BorderSide(
                                          color: Color(0x57707070), width: 1),
                                      outside: const BorderSide(
                                          color: Color(0x57707070), width: 0.5),
                                    ),
                                    children: [
                                      TableRow(
                                        children: [
                                          buildTableCell(text: '${index + 1}'),
                                          buildTableCell(text: record.date),
                                          buildTableCell(text: record.checkIn),
                                          buildTableCell(text: record.checkOut),
                                          buildTableCell(
                                              text: record.production),
                                          buildTableCell(
                                              text: record.breakTime),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
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

class AttendanceRecord {
  final String date;
  final String checkIn;
  final String checkOut;
  final String production;
  final String breakTime;

  AttendanceRecord({
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.production,
    required this.breakTime,
  });
}
