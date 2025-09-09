import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditAnimePage extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? data;

  const EditAnimePage({super.key, this.id, this.data});

  @override
  State<EditAnimePage> createState() => _EditAnimePageState();
}

class _EditAnimePageState extends State<EditAnimePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _episodeController = TextEditingController();
  final _seasonController = TextEditingController();
  final _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _titleController.text = widget.data!['title'];
      _episodeController.text = widget.data!['episode'].toString();
      _seasonController.text = widget.data!['season'].toString();
      _ratingController.text = widget.data!['rating'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference animeCollection =
        FirebaseFirestore.instance.collection('anime');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'เพิ่มอนิเมะ' : 'แก้ไขอนิเมะ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'ชื่ออนิเมะ'),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกชื่ออนิเมะ' : null,
              ),
              TextFormField(
                controller: _episodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ตอนที่'),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกตอน' : null,
              ),
              TextFormField(
                controller: _seasonController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ซีซั่น'),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกซีซั่น' : null,
              ),
              TextFormField(
                controller: _ratingController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'คะแนน (0-5)'),
                validator: (value) {
                  if (value!.isEmpty) return 'กรุณากรอกคะแนน';
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 0 || rating > 5) {
                    return 'คะแนนต้องอยู่ระหว่าง 0-5';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final data = {
                        'title': _titleController.text,
                        'episode': int.parse(_episodeController.text),
                        'season': int.parse(_seasonController.text),
                        'rating': double.parse(
                            double.parse(_ratingController.text).toStringAsFixed(2)),
                      };
                      if (widget.id == null) {
                        animeCollection.add(data);
                      } else {
                        animeCollection.doc(widget.id).update(data);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("บันทึก")),
            ],
          ),
        ),
      ),
    );
  }
}
