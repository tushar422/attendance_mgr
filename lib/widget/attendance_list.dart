import 'package:attendance_mgr/util/date_formatting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_uid)
            .collection('attendance')
            .orderBy(
              'timestamp',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred!'),
            );
          }
          final fetchedData = snapshot.data!.docs;

          if (fetchedData.isEmpty) {
            return const Center(
              child: Text('No previous records!'),
            );
          }
          final records = _getRecordsFromSnapshot(fetchedData);
          return ListView.builder(
            itemCount: fetchedData.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  Icons.done,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(DateFormatting.ddmmyyFormat(records[index])),
                trailing: Text(DateFormat.jm().format(records[index])),
               
              );
            },
            
          );

          // return FutureBuilder(
          //   future: _getRecords(fetchedData),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(child: CircularProgressIndicator());
          //     }

          //     if (snapshot.hasError) {
          //       return Center(
          //         child: Text('An error occurred! : ${snapshot.error}'),
          //       );
          //     }
          //     return ListView.builder(
          //       itemBuilder: (ctx, index) {
          //         return ListTile(
          //           leading: CircleAvatar(
          //             foregroundImage: NetworkImage(contacts[index].imgUrl!),
          //           ),
          //           title: Text(contacts[index].name),
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (ctx) {
          //                   return ChatScreen(contact: contacts[index]);
          //                 },
          //               ),
          //             );
          //           },
          //         );
          //       },
          //       itemCount: contacts.length,
          //     );
          //   },
          // );
        });
  }
}

List<DateTime> _getRecordsFromSnapshot(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> list) {
  List<DateTime> records = [];
  records = list.map((entry) {
    final time = entry.data()['timestamp'] as Timestamp;
    return time.toDate();
  }).toList();

  return records;
}
