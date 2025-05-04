import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/features/directory/presentation/bloc/directory_bloc.dart';
import 'package:crud_app/services/firebase_service.dart';
import 'package:crud_app/ui/search_scp.dart';
import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/directory/presentation/bloc/directory_event.dart';

class RecordsView extends StatefulWidget {
  final String seriesId;

  const RecordsView({
    super.key,
    required this.seriesId
  });

  @override
  State<StatefulWidget> createState() => _RecordsViewState();
}

class _RecordsViewState extends State<RecordsView> {
  final FirebaseService _firebaseService = FirebaseService();

  String seriesName = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _fetchSeriesName();
  }

  Future<void> _fetchSeriesName() async {
    try {
      DocumentSnapshot snapshot = await _firebaseService
          .seriesCollection
          .doc(widget.seriesId)
          .get();

      setState(() {
        seriesName = snapshot.get('name');
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      debugPrint('Error fetching the series name');
    }
  }

  Image objectClassIcon(String type) {
    return switch (type) {
      'safe' => Image.asset(
        'assets/images/safe-class.png',
        width: 40,
        height: 40,
      ),
      'euclid' => Image.asset(
        'assets/images/euclid-class.png',
        width: 40,
        height: 40,
      ),
      'keter' => Image.asset(
        'assets/images/keter-class.png',
        width: 40,
        height: 40,
      ),
      _ => Image.asset(
        'assets/images/safe-class.png',
        width: 40,
        height: 40,
      ) // TODO: Replace with unknown category
    };
  }

  @override
  Widget build(BuildContext context) {
    context.read<DirectoryBloc>().add(UpdateAppBarTitle(title: seriesName));

    return SingleChildScrollView(
      child: Column(
        children: [
          // SearchSCP(),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextHeading(
                text: seriesName,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                fontName: 'Grenze Gotisch',
              ),
            ),
          ),
          SizedBox(height: 15),

          isLoading ? const Center(
            child: CircularProgressIndicator(),
          ) : Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the number of columns based on screen width
                int columns = (constraints.maxWidth / 150).floor();

                return StreamBuilder(
                  stream: _firebaseService.getSeriesRecords(widget.seriesId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    final items = snapshot.data?.docs ?? [];

                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns, // Number of columns
                        crossAxisSpacing: 10,   // Space between columns
                        mainAxisSpacing: 10,    // Space between rows
                      ),
                      itemCount: items.length, // Total number of items
                      itemBuilder: (context, index) {
                        return Card(
                          child: InkWell(
                            onTap: () {
                              context.push('/directory/${widget.seriesId}/${items[index].id}');
                            },
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  objectClassIcon(items[index]['objectClass']),
                                  Spacer(),
                                  TextHeading(
                                    text: '${items[index]['title']}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text('SCP-${items[index]['itemNumber']}')
                                ],
                              ),
                            )
                          )
                        );
                      },
                    );
                  }
                );
              },
            ),
          )
        ],
      ),
    );
  }
}