import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uas_pemweb/models/materi.dart';
import 'package:uas_pemweb/providers/firestore_service.dart';
import 'package:uas_pemweb/views/data_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('Daftar Materi '),
              const Icon(Icons.menu_book),
              const SizedBox(width: 20),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return DataPage();
              },
            ));
          },
          child: const Icon(Icons.note_add),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('Materi').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var materi = snapshot.data!.docs
                  .map((materi) => Materi.fromSnapshot(materi))
                  .toList();
              return ListView.builder(
                itemCount: materi.length,
                itemBuilder: (context, index) {
                  var id = snapshot.data!.docs[index].id;
                  String subtitle = materi[index].isi;
                  if (subtitle.length > 15) {
                    subtitle = subtitle.substring(0, 15) + '...';
                  }

                  String firstLetter =
                      materi[index].judul.substring(0, 1).toUpperCase();

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!, // Warna batas
                        width: 1.0, // Lebar batas
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DataPage(
                                materi: materi[index],
                                id: id,
                              );
                            },
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 175, 118, 187),
                        child: Text(
                          firstLetter,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ), // Warna latar belakang avatar
                      ),
                      title: Text(
                        materi[index].judul,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(subtitle),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                    'Apakah Anda yakin ingin menghapus item ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Menutup dialog
                                    },
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FirestoreService.deleteMateri(id);
                                      Navigator.of(context)
                                          .pop(); // Menutup dialog
                                    },
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 225, 26, 12),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
