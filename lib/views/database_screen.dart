import 'package:crud_app/services/firebase_service.dart';
import 'package:flutter/material.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  State<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  final TextEditingController _itemNumberController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _objectClassController = TextEditingController();
  final TextEditingController _containmentProceduresController =
      TextEditingController();

  void handleSaveOrUpdate(context, docId) {
    final itemNumber = _itemNumberController.text.trim();
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final objectClass = _objectClassController.text.trim();
    final containmentProcedures = _containmentProceduresController.text.trim();

    if (itemNumber.isEmpty ||
        title.isEmpty ||
        description.isEmpty ||
        objectClass.isEmpty ||
        containmentProcedures.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final scpItem = {
      'itemNumber': itemNumber,
      'title': title,
      'description': description,
      'objectClass': objectClass,
      'containmentProcedures': containmentProcedures,
    };

    // Call the Firebase service to add or update the SCP item
    if (docId == null) {
      _firebaseService
          .addSCPItem(scpItem)
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('SCP item added successfully')),
            );
          })
          .catchError((error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $error')));
          });
    } else {
      _firebaseService
          .updateSCPItem(docId!, scpItem)
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('SCP item updated successfully')),
            );
          })
          .catchError((error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $error')));
          });
    }
  }

  void openDialogBox({String? docId, Map<String, dynamic>? existingData}) {
    if (existingData != null) {
      _itemNumberController.text = existingData['itemNumber'] ?? '';
      _titleController.text = existingData['title'] ?? '';
      _descriptionController.text = existingData['description'] ?? '';
      _objectClassController.text = existingData['objectClass'] ?? '';
      _containmentProceduresController.text =
          existingData['containmentProcedures'] ?? '';
    } else {
      _itemNumberController.clear();
      _titleController.clear();
      _descriptionController.clear();
      _objectClassController.clear();
      _containmentProceduresController.clear();
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(docId == null ? 'Add SCP' : 'Edit SCP'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _itemNumberController,
                  decoration: const InputDecoration(labelText: 'Item #'),
                ),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'SCP Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _objectClassController,
                  decoration: const InputDecoration(labelText: 'Object Class'),
                ),
                TextField(
                  controller: _containmentProceduresController,
                  decoration: const InputDecoration(
                    labelText: 'Containment Procedures',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  handleSaveOrUpdate(context, docId);
                  Navigator.pop(context);
                },
                child: Text(docId == null ? 'Add' : 'Update'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => openDialogBox(),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firebaseService.getSCPItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final scpItems = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: scpItems.length,
            itemBuilder: (context, index) {
              final docId = scpItems[index].id;
              final data = scpItems[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['title']),
                subtitle: Text(data['description']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _firebaseService.deleteSCPItem(docId).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('SCP item deleted')),
                      );
                    });
                  },
                ),
                onTap: () => openDialogBox(docId: docId, existingData: data),
              );
            },
          );
        },
      ),
    );
  }
}
