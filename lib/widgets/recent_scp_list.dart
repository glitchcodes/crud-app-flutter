import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class RecentSCP extends StatefulWidget {
  const RecentSCP({super.key});

  @override
  State<RecentSCP> createState() => _RecentSCPState();
}

class _RecentSCPState extends State<RecentSCP> {
  final FirebaseService _firebaseService = FirebaseService();

  Image objectClassIcon(String type) {
    Image icon =
    Image.asset(
      'assets/images/safe-class.png',
      width: 40,
      height: 40,
    );

    switch (type) {
      case 'safe':
        icon = Image.asset(
          'assets/images/safe-class.png',
          width: 40,
          height: 40,
        );
        break;
      case 'euclid':
        icon = Image.asset(
          'assets/images/euclid-class.png',
          width: 40,
          height: 40,
        );
        break;
      case 'keter':
        icon = Image.asset(
          'assets/images/keter-class.png',
          width: 40,
          height: 40,
        );
        break;
    }

    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recently added entries',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: 8),
          StreamBuilder(
              stream: _firebaseService.getRecentSCPItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final scpItems = snapshot.data?.docs ?? [];

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: scpItems.length,
                    itemBuilder: (context, index) {
                      // final docId = scpItems[index].id;
                      final data = scpItems[index].data() as Map<String, dynamic>;

                      return Card(
                        child: InkWell(
                            onTap: () {},
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    objectClassIcon(data['objectClass']),
                                    SizedBox(width: 10),
                                    Expanded(child: Column(
                                      children: [
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              data['title'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                        ),
                                        SizedBox(height: 5),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              data['description'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            )
                                        ),
                                      ],
                                    ))
                                  ],
                                )
                            )
                        ),
                      );
                    }
                );
              }
          ),
        ],
      ),
    );
  }
}