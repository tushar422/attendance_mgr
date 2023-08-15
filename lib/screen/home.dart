import 'package:attendance_mgr/screen/account.dart';

import 'package:attendance_mgr/widget/attendance_head.dart';

import 'package:flutter/material.dart';


import '../widget/attendance_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const MyAccountSheet();
                  });
            },
            icon: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const AttendanceHeader(),
          const Expanded(child: AttendanceList()),
        ],
      ),
    );
  }

 

  
}
