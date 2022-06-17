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
  late List<Note> noteList=[];
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if(noteList.isEmpty)
      {
        noteList = <Note>[];
        updateListView();
      }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getlistview(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigatetodetails(Note('','',2),'Add Note');
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
              backgroundColor: getPriority(this.noteList[pos].priority),
              child: getpriorityicon(this.noteList[pos].priority),
            ),
            title: Text(
              this.noteList[pos].title,
              style: titlestyle,
            ),
            subtitle: Text(this.noteList[pos].date),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
            onTap: () {
              _delete(context, noteList[pos]);
            },
            ),
            onTap: (){
              debugPrint('List tile tapped');
              navigatetodetails(this.noteList[pos], 'Edit Note');
            },
          ),
        );
      },
    );
  }
  //returns priority color
  Color getPriority(int priority)
  {
    switch(priority){
      case 1: return Colors.red;
              break;

      case 2: return Colors.yellow;
              break;

      default: return Colors.yellow;
    }
  }

  //returns priority icon
Icon getpriorityicon(int priority){
  switch(priority){
    case 1: return Icon(Icons.play_arrow);
    break;

    case 2: return Icon(Icons.keyboard_arrow_right);
    break;

    default: return Icon(Icons.keyboard_arrow_right);
  }
}

void _delete(BuildContext context, Note note) async{
    int result = await databaseHelper.deletenote(note.id);
    if(result !=0){
      showsnackbar(context,'Note Deleted Successfully');
      updateListView();
    }
}

void showsnackbar(BuildContext context, String message)
{
  final snackbar = SnackBar(content: Text(message));
  Scaffold.of(context).showSnackBar(snackbar);
}

  void navigatetodetails(Note note,String title) async{
    bool result =await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Notedetails(note,title);
    }));

    if(result == true)
      {
        updateListView();
      }
  }

  void updateListView()
  {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){

      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then ((noteList){
        setState(()
        {
          this.noteList = noteList;
          this.count = noteList. length;
        });
      });
    });
  }
}
