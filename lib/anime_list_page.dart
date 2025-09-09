import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'edit_anime_page.dart';

class AnimeListPage extends StatelessWidget {
  const AnimeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference animeCollection =
        FirebaseFirestore.instance.collection('anime');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Tracker'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: animeCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("${data['title']} (S${data['season']})"),
                  subtitle: Text("ตอนที่ ${data['episode']} | คะแนน: ${data['rating']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditAnimePage(
                                  id: docs[index].id,
                                  data: data,
                                ),
                              ),
                            );
                          }),
                      IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            animeCollection.doc(docs[index].id).delete();
                          }),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const EditAnimePage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
