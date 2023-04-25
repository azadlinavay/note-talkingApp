import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo2/src/constants/colors.dart';
import 'package:todo2/src/models/note_model.dart';
import 'package:todo2/src/screens/note_editor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isNoteEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: buttonColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NoteEditorScreen(),
              ),
            );
          },
          child: Icon(
            Icons.note_add,
            color: Colors.white,
          )),
      // Color of the scaffold of home screen
      backgroundColor: backgroundColor,
      // App Bar
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: StreamBuilder<List<Note>>(
          stream: getNoteData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            var mNotes = snapshot.data!;
            if (mNotes.isEmpty) {
              return Center(
                  child: TextButton(
                onPressed: () {},
                child: const Text("Write your frirst note",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ));
            }
            return ListView.builder(
                itemCount: mNotes.length,
                itemBuilder: (context, index) {
                  return getNoteCell(mNotes[index], index);
                });
          }),
    );
  }

// Note Card
  Widget getNoteCell(Note mNote, int index) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: secondaryColor,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NoteEditorScreen(),
                  settings: RouteSettings(arguments: mNote)));
        },
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Note Title
                    Text(
                      mNote.title ?? "",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // note Body
                    Text(
                      mNote.body ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // note date time
                    Text(
                        DateFormat("yy-M-d h:ma")
                            .format(mNote.dateTime!.toDate()),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Stream to get data from firebase
  Stream<List<Note>> getNoteData() {
    return FirebaseFirestore.instance
        .collection('notes')
        .snapshots()
        .map((event) => event.docs.map((e) => Note.fromMap(e.data())).toList());
  }
}
