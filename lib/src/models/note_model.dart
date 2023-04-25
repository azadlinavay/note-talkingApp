import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? uid;
  String? title;
  String? body;
  Timestamp? dateTime;

  Note({
    this.uid,
    this.title,
    this.body,
    this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'body': body,
      'dateTime': dateTime as Timestamp,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
        uid: map['uid'],
        title: map['title'],
        body: map['body'],
        dateTime: map['dateTime'] is Timestamp ? map['dateTime'] : null);
  }
}
