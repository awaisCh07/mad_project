import 'package:flutter/material.dart';
import 'package:ams_employees/constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        backgroundColor: const Color(0xFF202020),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF202020),
              ),
              child:
                  Image.asset('assets/images/wb_logo.png', fit: BoxFit.contain),
            ),

            ListTile(
              iconColor: Colors.white,
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard', style: kDrawerItemTextStyle),
              onTap: () {
                // Handle tapping Dashboard ListTile
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            ListTile(
              iconColor: Colors.white,
              leading: const Icon(Icons.person),
              title: const Text('Profile', style: kDrawerItemTextStyle),
              onTap: () {
                // Handle tapping Profile ListTile
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              iconColor: Colors.white,
              leading: const Icon(Icons.checklist),
              title: const Text('Attendance', style: kDrawerItemTextStyle),
              onTap: () {
                // Handle tapping Attendance ListTile
                Navigator.pushNamed(context, '/attendance');
              },
            ),
            ListTile(
              iconColor: Colors.white,
              leading: const Icon(Icons.receipt_long),
              title: const Text('Leave', style: kDrawerItemTextStyle),
              onTap: () {
                // Handle tapping Leave ListTile
                Navigator.pushNamed(context, '/leave');
              },
            ),
            ListTile(
              iconColor: Colors.white,
              leading: const Icon(Icons.home_rounded),
              title: const Text('Home', style: kDrawerItemTextStyle),
              onTap: () {
                // Handle tapping Leave ListTile
                Navigator.pushNamed(context, '/super_user');
              },
            ),
            const Expanded(child: SizedBox()), // Add an Expanded widget
            ListTile(
              iconColor: Colors.white,
              leading: const Icon(Icons.logout),
              title: const Text('Logout', style: kDrawerItemTextStyle),
              onTap: () {
                // Handle Logout here
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
