import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String? id;
  final String? title;
  final String? body;
  final int? color;
  final Timestamp? creationTime;

  NoteModel({this.id, this.title, this.body, this.color, this.creationTime});

  factory NoteModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return NoteModel(
      id: snapshot['id'],
      title: snapshot['title'],
      body: snapshot['body'],
      color: snapshot['color'],
      creationTime: snapshot['creationTime'],
    );
  }

  Map<String, dynamic> toDocument() => {
    "id": id,
    "title": title,
    "body": body,
    "color": color,
    "creationTime": creationTime,
  };
}