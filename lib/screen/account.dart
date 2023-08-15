import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAccountSheet extends StatelessWidget {
  const MyAccountSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 30),
      children: [
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log Out'),
          onTap: () {
            showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    icon: const Icon(Icons.logout),
                    title: const Text('Do you want to log out?'),
                    content: const SizedBox(height: 30),
                    actions: [
                      TextButton(
                        child: const Text('Go back'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).primaryColorLight),
                        child: const Text('Confirm'),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                    alignment: Alignment.center,
                  );
                });

            //
          },
        ),
      ],
    );
  }
}
