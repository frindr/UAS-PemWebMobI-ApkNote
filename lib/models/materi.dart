import 'package:cloud_firestore/cloud_firestore.dart';

class Materi {
  String judul, isi;

  Materi({
    required this.judul,
    required this.isi,
  });

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'isi': isi,
    };
  }

  factory Materi.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return Materi(judul: json['judul'], isi: json['isi']);
  }
}
