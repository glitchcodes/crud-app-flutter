import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/features/directory/presentation/bloc/directory_bloc.dart';
import 'package:crud_app/features/directory/presentation/bloc/directory_event.dart';
import 'package:crud_app/services/firebase_service.dart';
import 'package:crud_app/ui/typography/text_heading.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContributeInfoView extends StatefulWidget {
  final String? itemId;

  const ContributeInfoView({
    super.key,
    this.itemId
  });

  @override
  State<StatefulWidget> createState() => _ContributeInfoViewState();
}

class _ContributeInfoViewState extends State<ContributeInfoView> {
  final FirebaseService _firebaseService = FirebaseService();

  late Map<String, dynamic> itemData;
  bool isEditing = false;
  bool isLoading = false;

  final titleController = TextEditingController();
  final itemNumberController = TextEditingController();
  final objectClassController = TextEditingController();
  final briefDescriptionController = TextEditingController();

  static const List<String> list = <String>['Safe', 'Euclid', 'Keter'];

  static final List<DropdownMenuEntry> objectClassEntries = List.unmodifiable(
    list.map((String name) => DropdownMenuEntry(value: name, label: name))
  );

  FleatherController descriptionController = FleatherController();
  FleatherController containmentController = FleatherController();

  @override
  void initState() {
    super.initState();

    if (widget.itemId != null) {
      setState(() {
        isEditing = true;
        isLoading = true;
      });

      _fetchItemData();
    }
  }

  ParchmentDocument _loadDocument(doc) {
    if (doc == null) {
      return ParchmentDocument();
    }

    dynamic decodedJson = jsonDecode(doc);
    
    return ParchmentDocument.fromJson(decodedJson);
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

        titleController.text = itemData['title'];
        itemNumberController.text = itemData['itemNumber'];
        objectClassController.text = itemData['objectClass'];
        briefDescriptionController.text = itemData['brief_description'];
        descriptionController = FleatherController(document: _loadDocument(itemData['description']));
        containmentController = FleatherController(document: _loadDocument(itemData['containmentProcedures']));
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      debugPrint('Error fetching the item data');
    }
  }

  String determineSeriesId(String itemNumber) {
    final value = int.tryParse(itemNumber);
    if (value == null) {
      throw Exception('Invalid item number: $itemNumber');
    }

    final seriesMap = {
      0: 'XPFQvH80Hl5rVOqBVD1k',
      1: 'mLSgKXd2UNGlsGPaqdZS',
      2: 'XTcecJUnhTrvxBxHpadv',
      3: 'vgT1o7DuMxH2JW6EcPtQ',
      4: 'yBj38qbLD3CsQ61ACkWC',
      5: '74HJ9Aii3puA8Hl2ce0n',
      6: 'WRMjmbKWloqJaTx3Ojg4',
      7: 'oTcJ7okhBm59XqmaPpH0',
      8: 'cm6clXbItRflZYfa5sel',
    };
    return seriesMap[value ~/ 1000] ?? 'XPFQvH80Hl5rVOqBVD1k';
  }

  void _handleSaveOrUpdate(context, docId) async {
    final title = titleController.text.trim();
    final itemNumber = itemNumberController.text.trim();
    final objectClass = objectClassController.text.trim();
    final briefDescription = briefDescriptionController.text.trim();
    final description = descriptionController.document;
    final containmentProcedure = containmentController.document;

    final scpItem = {
      'title': title,
      'itemNumber': itemNumber,
      'objectClass': objectClass,
      'brief_description': briefDescription,
      'description': jsonEncode(description),
      'containmentProcedures': jsonEncode(containmentProcedure),
      'seriesId': determineSeriesId(itemNumber)
    };

    if (isEditing) {
      _firebaseService.updateSCPItem(widget.itemId!, scpItem)
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SCP item updated successfully')),
          );
        });
    } else {
      _firebaseService.addSCPItem(scpItem)
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SCP item added successfully')),
          );
        });
    }

  }

  @override
  Widget build(BuildContext context) {
    context.read<DirectoryBloc>().add(UpdateAppBarTitle(title: 'Contribute'));

    return SingleChildScrollView(
      child: isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) : Container(
        padding: EdgeInsets.all(16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextHeading(
              text: isEditing ? 'Edit SCP' : 'Add SCP',
              style: TextStyle(
                fontSize: 30
              ),
              fontName: 'Grenze Gotisch',
            ),
            SizedBox(height: 40),
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'e.g Nervous Tick',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: itemNumberController,
                            decoration: InputDecoration(
                              labelText: 'Item #',
                              hintText: 'e.g 00001',
                              border: OutlineInputBorder(),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        DropdownMenu(
                          controller: objectClassController,
                          initialSelection: list.first,
                          dropdownMenuEntries: objectClassEntries,
                          label: Text('Object Class'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  TextFormField(
                    controller: briefDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Brief Description',
                      hintText: 'e.g This is nervous tick',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  SizedBox(height: 20),

                  TextHeading(
                    text: 'Description'
                  ),
                  SizedBox(height: 10),

                  Container(
                    // padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF231919),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FleatherToolbar.basic(controller: descriptionController),
                        FleatherEditor(
                          controller: descriptionController,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          autocorrect: false,
                        )
                      ]
                    ),
                  ),

                  SizedBox(height: 20),

                  TextHeading(
                    text: 'Containment Procedure'
                  ),

                  SizedBox(height: 10),

                  Container(
                    // padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF231919),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FleatherToolbar.basic(controller: containmentController),
                        FleatherEditor(
                          controller: containmentController,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          autocorrect: false,
                        )
                      ]
                    ),
                  ),

                  SizedBox(height: 30),

                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        onPressed: () => _handleSaveOrUpdate(context, widget.itemId),
                        child: Text(isEditing ? 'Update' : 'Add')
                    ),
                  )
                ]
              )
            )
          ]
        ),
      )
    );
  }
}

