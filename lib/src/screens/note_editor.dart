import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo2/src/models/note_model.dart';
import 'package:uuid/uuid.dart';

import '../constants/colors.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  // variables
  TextEditingController titleTVC = TextEditingController();
  TextEditingController bodyTVC = TextEditingController();

  var isUpdate = false;
  bool isEdit = false;
  Note? updateNote;

  var isCheckedTheUpdaterStat = false;
// load data function to read data from home screen
  loadUpdateData() {
    updateNote ??= ModalRoute.of(context)!.settings.arguments as Note?;
    isUpdate = updateNote != null;
    if (isUpdate) {
      titleTVC.text = updateNote?.title ?? "";
      bodyTVC.text = updateNote?.body ?? "";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // to check the update state and read data from the last screen
    if (!isCheckedTheUpdaterStat) {
      isCheckedTheUpdaterStat = !isCheckedTheUpdaterStat;
      loadUpdateData();
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: isUpdate
            ? isEdit
                ? const Text('Edit Note')
                : const Text('View Note')
            : const Text("New Note"),
        actions: [
          // if its in add note mode only you you will see this button
          if (!isUpdate) ...[
            IconButton(
              onPressed: () {
                if (titleTVC.text.isEmpty && bodyTVC.text.isEmpty) {}
                saveAndQuit(updateNote?.uid);
              },
              icon: const Icon(Icons.save),
            ),
          ] else ...[
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Are you sure to delete this note?'),
                      content: SingleChildScrollView(),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            deleteNote(
                              updateNote!.uid!,
                            );
                            Navigator.pop(context);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                // check if its in edit mode or not
                if (isEdit) {
                  saveAndQuit(updateNote?.uid);
                } else {
                  setState(() {
                    isEdit = !isEdit;
                  });
                }
              },
              icon: isEdit
                  ? const Icon(Icons.save)
                  : const Icon(Icons.edit_document),
            ),
          ]
        ],
      ),
      body: ListView(
        children: [
          // the header of note in note editor screen
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: titleTVC,
              maxLines: null,
              // if its in update mode and edit mode is enabled then make it editable
              enabled: isUpdate
                  ? isEdit
                      ? true
                      : false
                  : true,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  labelStyle:
                      TextStyle(color: isEdit ? Colors.white : Colors.white70),
                  border: InputBorder.none,
                  labelText: "Title"),
              style: TextStyle(color: isEdit ? Colors.white : Colors.white70),
            ),
          ),
          // body of note in note editor page
          Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.75),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              style: TextStyle(color: isEdit ? Colors.white : Colors.white70),
              controller: bodyTVC,
              // if its in update mode and edit mode is enabled then make it editable
              enabled: isUpdate
                  ? isEdit
                      ? true
                      : false
                  : true,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  labelStyle:
                      TextStyle(color: isEdit ? Colors.white : Colors.white70),
                  border: InputBorder.none,
                  labelText: "Body"),
            ),
          )
        ],
      ),
    );
  }

// function to save the edits that ypou have done to the note
  void saveAndQuit(String? uid) async {
    //  if its in update mode
    if (isUpdate) {
      var title = titleTVC.text;
      var body = bodyTVC.text;

      if (title.isEmpty && body.isEmpty) {
        Navigator.pop(context);
      }

      var mNote = Note(
          title: title,
          body: body,
          dateTime: Timestamp.now(),
          uid: updateNote!.uid);

      FirebaseFirestore.instance
          .collection('notes')
          .doc(uid)
          .update(mNote.toMap());
    } else {
      var title = titleTVC.text;
      var body = bodyTVC.text;

      if (title.isEmpty && body.isEmpty) {
        Navigator.pop(context);
      }

      var mNote = Note(
        uid: const Uuid().v1(),
        title: title,
        body: body,
        dateTime: Timestamp.now(),
      );
// write data to firebase
      await FirebaseFirestore.instance.collection('notes').doc(mNote.uid).set(
            mNote.toMap(),
          );
// if u want to use shared preference
      // var prefs = await SharedPreferences.getInstance();
      // var noteList = prefs.getStringList('notes') ?? [];

      // var noteListModel = noteList.map((e) => Note.fromMap(e)).toList();
      // noteListModel.add(mNote);

      // noteListModel.sort((a, b) {
      //   return b.dateTime!.compareTo(a.dateTime!);
      // });

      // noteList = noteListModel.map((e) => jsonEncode(e.toMap())).toList();

      // prefs.setStringList('notes', noteList);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  deleteNote(String uid) async {
    await FirebaseFirestore.instance.collection('notes').doc(uid).delete();
  }
}
