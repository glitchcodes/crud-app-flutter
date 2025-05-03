import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/features/directory/presentation/bloc/directory_bloc.dart';
import 'package:crud_app/features/directory/presentation/bloc/directory_event.dart';
import 'package:crud_app/services/firebase_service.dart';
import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemView extends StatefulWidget {
  final String itemId;

  const ItemView({
    super.key,
    required this.itemId
  });

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> with RouteAware {
  final FirebaseService _firebaseService = FirebaseService();
  final DirectoryBloc _directoryBloc = DirectoryBloc();

  Map<String, dynamic>? itemData;
  bool isLoading = true;

  FleatherController descriptionController = FleatherController();
  FleatherController containmentProceduresController = FleatherController();

  @override
  void initState() {
    super.initState();

    _fetchItemData();
  }

  ParchmentDocument _parseDescription() {
    return ParchmentDocument.fromJson(jsonDecode(itemData?['description']));
  }

  ParchmentDocument _parseContainmentProcedures() {
    return ParchmentDocument.fromJson(jsonDecode(itemData?['containmentProcedures']));
  }

  _fetchItemData() async {
    try {
      DocumentSnapshot snapshot = await _firebaseService
          .scpCollection
          .doc(widget.itemId)
          .get();

      setState(() {
        itemData = snapshot.data() as Map<String, dynamic>;
        descriptionController = FleatherController(
          document: _parseDescription()
        );
        containmentProceduresController = FleatherController(
          document: _parseContainmentProcedures()
        );

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
    if (!isLoading) {
      context.read<DirectoryBloc>().add(UpdateAppBarTitle(title: itemData!['title']));
    }

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

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF231919),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextHeading(
                    text: 'Description'
                  ),
                  SizedBox(height: 16),
                  FleatherEditor(
                    controller: descriptionController,
                    readOnly: true,
                    showCursor: false,
                  )
                ],
              ),
            ),
            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Color(0xFF231919),
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextHeading(
                    text: 'Containment Procedures'
                  ),
                  SizedBox(height: 16),
                  FleatherEditor(
                    controller: containmentProceduresController,
                    readOnly: true,
                    showCursor: false,
                  )
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}