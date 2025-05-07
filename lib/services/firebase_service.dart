import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference seriesCollection = FirebaseFirestore.instance
      .collection('scp_series');
  final CollectionReference scpCollection = FirebaseFirestore.instance
      .collection('scp_items');

  /// SCP Series
  /// -------------------------------------------------------------------------
  Stream<QuerySnapshot> getAllSeries() {
    try {
      return seriesCollection.orderBy('name').snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getSeriesRecords(String seriesId) {
    try {
      return scpCollection
          .where('seriesId', isEqualTo: seriesId)
          .orderBy('itemNumber')
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  /// SCP Items
  /// -------------------------------------------------------------------------

  Stream<QuerySnapshot> searchSCPItems(String query) {
    try {
      final scpStream =
          scpCollection
              .orderBy('title')
              .where('title', isGreaterThanOrEqualTo: query)
              .where('title', isLessThanOrEqualTo: '$query\uf8ff')
              .snapshots();

      return scpStream;
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getSCPItems() {
    try {
      final scpStream = scpCollection.orderBy('itemNumber').snapshots();
      return scpStream;
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getSCPItemsLimited() {
    try {
      final scpStream =
          scpCollection.orderBy('itemNumber').limit(10).snapshots();
      return scpStream;
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getRecentSCPItems() {
    try {
      final scpStream = scpCollection.orderBy('createdAt').limit(3).snapshots();
      return scpStream;
    } catch (e) {
      rethrow;
    }
  }

  Future<DocumentReference<Object?>> addSCPItem(
    Map<String, dynamic> scpItem,
  ) async {
    return scpCollection.add({
      'itemNumber': scpItem['itemNumber'],
      'title': scpItem['title'],
      'brief_description': scpItem['brief_description'],
      'description': scpItem['description'],
      'objectClass': scpItem['objectClass'],
      'containmentProcedures': scpItem['containmentProcedures'],
      'imageUrl': scpItem['imageUrl'],
      'seriesId': scpItem['seriesId'],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateSCPItem(
    String itemId,
    Map<String, dynamic> scpItem,
  ) async {
    return scpCollection.doc(itemId).update({
      'itemNumber': scpItem['itemNumber'],
      'title': scpItem['title'],
      'brief_description': scpItem['brief_description'],
      'description': scpItem['description'],
      'objectClass': scpItem['objectClass'],
      'containmentProcedures': scpItem['containmentProcedures'],
      'imageUrl': scpItem['imageUrl'],
      'seriesId': scpItem['seriesId'],
    });
  }

  Future<void> deleteSCPItem(String itemId) async {
    return scpCollection.doc(itemId).delete();
  }

  // +++++ Temporary User Profile Services +++++
  Future updateUserName(String userId, String userName) async {
    final result = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .update({'name': userName});

    final newName = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .get()
        .then((value) => value.data()?['name']);
    return newName;
  }

  Future updateUserEmail(String userId, String email) async {
    final result = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .update({'email': email});

    final newEmail = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .get()
        .then((value) => value.data()?['email']);
    return newEmail;
  }

  Future<String?> getUserProfilePictureURL(String userId) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(userId)
            .get();
    return doc.data()?['profilePictureURL'] as String?;
  }

  Future<String> updateUserProfilePictureURL(
    String userId,
    String imageUrl,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userId)
          .update({'profilePictureURL': imageUrl});
      return 'Profile picture URL updated successfully';
    } catch (e) {
      print('Error updating profile picture URL: $e');
      return 'Error updating profile picture URL';
      // throw 'Failed to update profile picture URL';
    }
  }

  Future<void> deleteUserProfilePictureURL(String userId) async {
    return FirebaseFirestore.instance.collection('profiles').doc(userId).update(
      {'profilePictureURL': null},
    );
  }

  // ----- Temporary User Profile Services -----
}
