import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_pemweb/models/materi.dart';

class FirestoreService {
  static Future<void> addMateri(Materi materi) async {
    await FirebaseFirestore.instance
        .collection('Materi')
        .add(materi.toJson());
  }

  static Future<void> deleteMateri(String id) async {
    await FirebaseFirestore.instance.collection('Materi').doc(id).delete();
  }

  static Future<void> updateMateri(Materi materi, String id) async {
    await FirebaseFirestore.instance
        .collection('Materi')
        .doc(id)
        .update(materi.toJson());
  }
}
