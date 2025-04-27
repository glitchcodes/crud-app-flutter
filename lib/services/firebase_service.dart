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
      final seriesStream = scpCollection.orderBy('name').snapshots();
      return seriesStream;
    } catch (e) {
      rethrow;
    }
  }

  /// SCP Items
  /// -------------------------------------------------------------------------
  Stream<QuerySnapshot> getSCPItems() {
    try {
      final scpStream = scpCollection.orderBy('itemNumber').snapshots();
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
      'description': scpItem['description'],
      'objectClass': scpItem['objectClass'],
      'containmentProcedures': scpItem['containmentProcedures'],
      'imageUrl': scpItem['imageUrl'],
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
      'description': scpItem['description'],
      'objectClass': scpItem['objectClass'],
      'containmentProcedures': scpItem['containmentProcedures'],
      'imageUrl': scpItem['imageUrl'],
    });
  }

  Future<void> deleteSCPItem(String itemId) async {
    return scpCollection.doc(itemId).delete();
  }
}
