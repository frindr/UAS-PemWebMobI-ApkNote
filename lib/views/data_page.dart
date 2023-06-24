import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:uas_pemweb/models/materi.dart';
import 'package:uas_pemweb/providers/firestore_service.dart';

class DataPage extends StatefulWidget {
  DataPage({super.key, this.materi, this.id});

  final Materi? materi;
  final String? id;

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late TextEditingController judulController;
  late TextEditingController isiController;

  @override
  void initState() {
    super.initState();
    judulController = TextEditingController();
    isiController = TextEditingController();

    if (widget.materi != null) {
      judulController.text = widget.materi!.judul;
      isiController.text = widget.materi!.isi;
    }
  }

  @override
  void dispose() {
    judulController.dispose();
    isiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.materi != null ? Text("Edit Data") : Text("Tambah Data"),
        actions: [
          IconButton(
            onPressed: () async {
              if (judulController.text.isEmpty ||
                  isiController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Peringatan'),
                      content: Text('Form tidak boleh kosong'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                if (widget.materi != null) {
                  await FirestoreService.updateMateri(
                    Materi(
                      judul: judulController.text,
                      isi: isiController.text,
                    ),
                    widget.id!,
                  );
                } else {
                  await FirestoreService.addMateri(
                    Materi(
                      judul: judulController.text,
                      isi: isiController.text,
                    ),
                  );
                }
                Navigator.pop(context);
              }
            },

            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: judulController,
              decoration: InputDecoration(
                hintText: 'Masukkan Judul Materi',
                labelText: 'Judul Materi',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: isiController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Masukkan Isi Materi',
                labelText: 'Isi Materi',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
