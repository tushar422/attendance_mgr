import 'package:attendance_mgr/util/date_formatting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../screen/punchin.dart';

class AttendanceHeader extends StatefulWidget {
  const AttendanceHeader({super.key});

  @override
  State<AttendanceHeader> createState() => _AttendanceHeaderState();
}

class _AttendanceHeaderState extends State<AttendanceHeader> {
  @override
  void initState() {
    _fillDate();

    super.initState();
  }

  DateTime? _localDate;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final newAttendanceContent = Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Text(
            'Mark today\'s attendance now.',
            style: GoogleFonts.raleway(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        IconButton.filled(
          onPressed: _markAttendance,
          icon: const Icon(Icons.assignment_turned_in_sharp),
        )
      ],
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(width: 1),
        ),
      ),
      child: Column(
        mainAxisAlignment:
            (_isLoading) ? MainAxisAlignment.end : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isLoading)
            if (_localDate != null &&
                DateFormatting.ddmmyyFormat(_localDate!) ==
                    DateFormatting.ddmmyyFormat(DateTime.now()))
              Text(
                'You marked today\'s attendance at ${DateFormat.jm().format(_localDate!)}',
                style: GoogleFonts.raleway(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            else
              newAttendanceContent,
          if (_isLoading) const LinearProgressIndicator(),
        ],
      ),
    );
  }

  void _fillDate() async {
    final date = await _getLastAttendance();
    setState(() {
      _localDate = date;
      _isLoading = false;
    });
  }

  Future<DateTime?> _getLastAttendance() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    try {
      final query = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('attendance')
          .orderBy(
            'timestamp',
            descending: true,
          )
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        return (query.docs.first.data()['timestamp'] as Timestamp).toDate();
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching last attendance document: $e");
      return null;
    }
  }

  void _markAttendance() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return PunchInSheet(
            onSuccess: (date) {
              setState(() {
                _localDate = date;
              });
            },
          );
        });
  }
}
