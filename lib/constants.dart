import 'package:flutter/material.dart';

// Colors
const Color kPrimaryColor = Color.fromRGBO(23, 24, 24, 1);

// Text Styles
const TextStyle kHeadingTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Poppins',
);

const TextStyle kFadedText = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 10,
  color: Color(0xFFA1A1A1),
);

const TextStyle kSubHeadingTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 10.0,
  letterSpacing: 2.5,
  fontWeight: FontWeight.w700,
  fontFamily: 'Poppins',
);

const TextStyle kButtonTextStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 15,
  color: Colors.black,
);

const TextStyle kDividerTextStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 15,
  color: Colors.white,
);

const TextStyle kGoogleButtonTextStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 15,
  color: Colors.white,
);

const TextStyle kLoginSignupOptionTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
  fontFamily: 'Poppins',
);

const TextStyle kForgetPasswordTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 10.0,
  fontWeight: FontWeight.w700,
  fontFamily: 'Poppins',
);

const TextStyle kTextFieldTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
  fontFamily: 'Poppins',
);

const TextStyle kHintTextStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 15,
  color: Colors.white,
);
//super user
const TextStyle kSuperUserMainScreenHeading = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 20,
  color: Colors.white,
);

const TextStyle kSuperUserMainScreenCardTextStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 14,
  color: Colors.white,
);

const TextStyle kFont12 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 12,
  color: Colors.white,
);
const TextStyle kFont8 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 8,
  color: Colors.white,
);
const TextStyle kFont10 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 10,
  color: Colors.white,
);
const TextStyle kFont7 = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 7,
  color: Color(0xFFB1B1B1),
);

const TextStyle kSuperUserHeadings = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 15,
  color: Colors.white,
);

const TextStyle kDrawerItemTextStyle = TextStyle(color: Colors.white);

const TextStyle kBottomLoginSignupTextStyle = TextStyle(
  color: Color(0xff1D90F5),
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
  fontFamily: 'Poppins',
);

const TextStyle kPageNameTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

const TextStyle kWelcomeUserTextStyle = TextStyle(
  color: Color(0xFFD1000B),
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
);

const TextStyle kEmployeeNameMainScreen = TextStyle(
  color: Colors.white,
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
);

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Color.fromRGBO(0, 0, 0, 0.5),
  hintStyle: TextStyle(color: Colors.white54),
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF51D1D), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  ),
);

const kCalendarStyle = ButtonStyle(
  elevation: MaterialStatePropertyAll(4.0),
  backgroundColor: MaterialStatePropertyAll(Colors.white),
);

/// styles here

ButtonStyle kElevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(
    vertical: 10,
    horizontal: 10,
  ),
  minimumSize: const Size(double.infinity, 0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
    side: const BorderSide(color: Colors.black),
  ),
);

ButtonStyle kCheckIn = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 50,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
    side: const BorderSide(color: Colors.black),
  ),
);

ButtonStyle kUserCheckOut = ElevatedButton.styleFrom(
  backgroundColor: const Color(0x1A000000),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
    side: const BorderSide(
      color: Color(0x1AFFFFFF),
    ),
  ),
);
