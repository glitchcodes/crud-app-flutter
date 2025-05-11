import 'package:crud_app/services/firebase_service.dart';
import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ObjectClassView extends StatefulWidget {
  final String objectClass;

  const ObjectClassView({
    super.key,
    required this.objectClass
  });

  @override
  State<ObjectClassView> createState() => _ObjectClassViewState();
}

class _ObjectClassViewState extends State<ObjectClassView> {

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
    final FirebaseService firebaseService = FirebaseService();


    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextHeading(
                text: widget.objectClass,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                fontName: 'Grenze Gotisch',
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the number of columns based on screen width
                int columns = (constraints.maxWidth / 150).floor();

                return StreamBuilder(
                    stream: firebaseService.getSCPItemsByClass(widget.objectClass),
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
                        physics: ScrollPhysics(),
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
                                    context.push('/directory/${items[index]['seriesId']}/${items[index].id}');
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