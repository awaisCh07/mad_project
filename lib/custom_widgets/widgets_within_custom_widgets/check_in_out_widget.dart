import 'package:flutter/material.dart';

class CheckInOutWidget extends StatelessWidget {
  const CheckInOutWidget({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final containerColor =
        text == 'Check In' ? const Color(0xEEFFFFFF) : Colors.black;
    final textColor = text == 'Check In' ? Colors.black : Colors.white;

    return Container(
      width: 72,
      height: 16,
      padding: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: const Color(0xFFFFFFFF),
          width: 0.5,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 12),
        ),
      ),
    );
  }
}
