import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/services/firebase_service.dart';
import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:flutter/material.dart';

class ItemView extends StatefulWidget {
  final String itemId;

  const ItemView({
    super.key,
    required this.itemId
  });

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  final FirebaseService _firebaseService = FirebaseService();

  Map<String, dynamic>? itemData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _fetchItemData();
  }

  _fetchItemData() async {
    try {
      DocumentSnapshot snapshot = await _firebaseService
          .scpCollection
          .doc(widget.itemId)
          .get();

      setState(() {
        itemData = snapshot.data() as Map<String, dynamic>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      debugPrint('Error fetching the item data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextHeading(
              text: 'SCP-${itemData!['itemNumber']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            TextHeading(
              text: itemData!['title'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20),
            Text(itemData!['description']),
          ],
        )
      )
    );
  }
}