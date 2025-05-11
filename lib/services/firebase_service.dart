import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Stream<QuerySnapshot> getSCPItemsByClass(String objectClass) {
    try {
      final scpStream = scpCollection
          .where('objectClass', isEqualTo: objectClass)
          .orderBy('itemNumber')
          .snapshots();

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
  Future<void> reAuthenticateUser(String email, String password) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser.reauthenticateWithCredential(credential);
    }
  }

  Future<void> updateUserName(String newUserName) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(currentUser.uid)
          .update({'name': newUserName});
    } else {
      //redirect to login page or invalidate auth
    }
  }

  Future updateUserEmail(String newEmail) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Update auth email
      // ignore: deprecated_member_use
      await currentUser.updateEmail(newEmail);
      // Update Firestore profile collection email
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(currentUser.uid)
          .update({'email': newEmail});
    } else {
      //redirect to login page or invalidate auth
    }
  }

  Future<void> updateUserPassword(String newPassword) async {
    // ensure firebase auth email change + profiles collection update
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await currentUser.updatePassword(newPassword);
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(currentUser.uid)
          .update({'password': newPassword});
    } else {
      //redirect to login page
    }
  }

  Future<String?> getUserProfilePictureUrl(String userId) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(userId)
            .get();
    return doc.data()?['profilePictureURL'] as String?;
  }

  Future<String> updateUserProfilePictureUrl(
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

  Future<void> deleteUserProfilePictureUrl(String userId) async {
    return FirebaseFirestore.instance.collection('profiles').doc(userId).update(
      {'profilePictureURL': null},
    );
  }

  // ----- Temporary User Profile Services -----
}
