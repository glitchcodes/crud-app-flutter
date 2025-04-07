import 'package:crud_app/services/firebase_service.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBar(),
            ObjectClassCategories(),
            RecentSCP()
          ],
        ),
      )
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search SCPs',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100)
          ),
          prefixIcon: Icon(Icons.search)
        ),
      ),
    );
  }
}

class ObjectClassCategories extends StatelessWidget {
  ObjectClassCategories({super.key});

  final objectClasses = [
    { 'icon': Icons.verified_user, 'label': 'Safe' },
    { 'icon': Icons.warning, 'label': 'Euclid' },
    { 'icon': Icons.help, 'label': 'Keter' },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Object Classes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(objectClasses.length, (index) {
                final item = objectClasses[index];

                return Card(
                    child: InkWell(
                      onTap: () {},
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 8
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                size: 34,
                              ),
                              SizedBox(height: 6),
                              Text(
                                item['label'] as String,
                                style: TextStyle(
                                    fontSize: 16
                                ),
                              )
                            ],
                          )
                      ),
                    )
                );
              })
          ),
        ],
      )
    );
  }
}

class RecentSCP extends StatefulWidget {
  const RecentSCP({super.key});

  @override
  State<RecentSCP> createState() => _RecentSCPState();
}

class _RecentSCPState extends State<RecentSCP> {
  final FirebaseService _firebaseService = FirebaseService();

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
                  final docId = scpItems[index].id;
                  final data = scpItems[index].data() as Map<String, dynamic>;

                  return Card(
                    child: InkWell(
                        onTap: () {},
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
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