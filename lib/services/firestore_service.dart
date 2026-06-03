import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> addFavorite({
    required String text,
    required String author,
  }) async {

    String docId =
        "${text.hashCode}_${author.hashCode}";

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(docId)
        .set({
      'text': text,
      'author': author,
      'timestamp': Timestamp.now(),
    });
  }

  Future<bool> isFavorite({
    required String text,
    required String author,
  }) async {

    final result = await _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .where('text', isEqualTo: text)
        .where('author', isEqualTo: author)
        .get();

    return result.docs.isNotEmpty;
  }

  Future<void> removeFavorite(String docId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(docId)
        .delete();
  }

  Stream<QuerySnapshot> getFavorites() {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots();
  }
  Future<void> submitFeedback({
    required String feedback,
    required String email,
    required String uid,
  }) async {
    await FirebaseFirestore.instance
        .collection('feedback')
        .add({
      'feedback': feedback,
      'email': email,
      'uid': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}