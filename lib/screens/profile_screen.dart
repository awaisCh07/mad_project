import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ams_employees/constants.dart';
import 'package:ams_employees/custom_widgets/custom_drawer.dart';
import 'package:ams_employees/custom_widgets/my_custom_app_bar.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int selectedId = 70;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      drawer: const SafeArea(
        child: CustomDrawer(),
      ),
      appBar: const MyCustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Profile',
                style: kHeadingTextStyle,
              ),
              // ElevatedButton(
              //   style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all(Colors.white),
              //   ),
              //   onPressed: () {
              //     _getDataFromApi(70); // id needs to be replaced
              //   },
              //   child: const Text(
              //     'Get Data',
              //     style: kButtonTextStyle,
              //   ),
              // ),
              // if (isDataVisible) _buildProfileCard(),
            ],
          ),
        ),
      ),
    );
  }
  //
  // Widget _buildProfileCard() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 10),
  //     height: 80,
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //         color: const Color(0x57707070),
  //       ),
  //       borderRadius: BorderRadius.circular(10),
  //       color: const Color(0xFF202020),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         CircleAvatar(
  //           backgroundImage: NetworkImage(image), // Use image URL from API
  //           radius: 30,
  //           backgroundColor: Colors.black,
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(realName, style: kSuperUserMainScreenCardTextStyle),
  //             Text(id, style: kFadedText),
  //             Text(
  //               designation,
  //               style: kFadedText.copyWith(fontSize: 8),
  //             ),
  //           ],
  //         ),
  //         const VerticalDivider(
  //           color: Color(0x57707070),
  //           thickness: 1,
  //           indent: 8,
  //           endIndent: 8,
  //         ),
  //         Row(
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   '$checkInTime AM', // Use checkInTime from API
  //                   style: kFadedText.copyWith(
  //                     color: const Color(0xFFD1000B),
  //                   ),
  //                 ),
  //                 Container(
  //                   alignment: Alignment.center,
  //                   padding: const EdgeInsets.all(1.0),
  //                   height: 18,
  //                   width: 75,
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(4),
  //                     border: Border.all(
  //                       color: const Color(0x57707070),
  //                       width: 0.5,
  //                     ),
  //                   ),
  //                   child: const Text(
  //                     'Check In',
  //                     style: TextStyle(color: Colors.black),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(width: 10),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   '$checkOutTime PM', // Use checkOutTime from API
  //                   style: kFadedText,
  //                 ),
  //                 Container(
  //                   alignment: Alignment.center,
  //                   padding: const EdgeInsets.all(1.0),
  //                   height: 18,
  //                   width: 75,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0x80000000),
  //                     borderRadius: BorderRadius.circular(4),
  //                     border: Border.all(
  //                       color: Colors.white,
  //                       width: 0.5,
  //                     ),
  //                   ),
  //                   child: const Text(
  //                     'Check Out',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
