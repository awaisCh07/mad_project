import 'package:flutter/material.dart';
import 'package:ams_employees/constants.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const MyCustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      title: Image.asset('assets/images/wb_logo.png', width: 90, height: 17),
      actions: [
        IconButton(
          icon: const Icon(Icons.message_outlined),
          tooltip: 'Show Message',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No messages')),
            );
          },
        ),
      ],
    );
  }
}
