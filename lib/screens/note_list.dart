import 'package:flutter/material.dart';
import 'note_details.dart';
import 'dart:async';
import 'package:Notes/Models/note.dart';
import 'package:Notes/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';


class NoteList extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper= DatabaseHelper();
  late List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if(noteList==null)
      {
        noteList= List<Note>();
      }
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getlistview(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigatetodetails('Add Note');
        },
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getlistview() {
    TextStyle? titlestyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int pos) {
        return Card(
          color: Colors.white,
          elevation: 3.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            title: Text(
              "sample title",
              style: titlestyle,
            ),
            subtitle: Text("Smaple subtitle"),
            trailing: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onTap: () {
              debugPrint("LISTTILE TAPPED");
              navigatetodetails('Edit Note');
            },
          ),
        );
      },
    );
  }

  void navigatetodetails(String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Notedetails(title);
    }));
  }
}
