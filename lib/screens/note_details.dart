import 'package:flutter/material.dart';
import 'dart:async';
import 'package:Notes/Models/note.dart';
import 'package:Notes/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class Notedetails extends StatefulWidget {
  final String appbartitle;
  final Note note;

  Notedetails(this.note, this.appbartitle);

  @override
  State<StatefulWidget> createState() {
    return notedetailsstate(this.note, this.appbartitle);
  }
}

class notedetailsstate extends State<Notedetails> {
  static var _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  String appbartitle;

  Note note;

  notedetailsstate(this.note, this.appbartitle);

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;

    titlecontroller.text = note.title;
    descriptioncontroller.text = note.description;

    return WillPopScope(
        onWillPop: () async {
          moveToLastScreen();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appbartitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                      items: _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: textStyle,
                      value: getpriorityasstring(note.priority),
                      onChanged: (valueselected) {
                        setState() {
                          debugPrint('user selected $valueselected');
                          convertpriorityasint(valueselected.toString());
                        }
                      }),
                ),
                //SECOND ELEMENT
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                      controller: titlecontroller,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint("something changed in title text field");
                        updatetitle();
                      },
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)))),
                ),
                //THIRD ELEMEMT
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                      controller: descriptioncontroller,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint(
                            "something changed in decription text field");
                        updatedescription();
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)))),
                ),
                //FOURTH Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Save button clicked");
                            _save();
                          });
                        },
                      )),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                          child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Delete button clicked");
                            _delete();
                          });
                        },
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context,true);
  }

  //convert string priority in form  of integer value before saving it to database
  void convertpriorityasint(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;

      case 'Low':
        note.priority = 2;
        break;
    }
  }

//convert int priority to string priority and display it to user in dropdown
  String getpriorityasstring(int value) {
    late String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; //high
        break;
      case 2:
        priority = _priorities[1]; //low
        break;
    }
    return priority;
  }

  void updatetitle() => note.title = titlecontroller.text;

  void updatedescription() => note.description = descriptioncontroller.text;

  //sava data to database
  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    ;
    int result;
    if (note.id != null) {
      result = await helper.updatenote(note);
    } else {
      result = await helper.Insertnote(note);
    }
    if (result != 0) {
      _showalertdialog('Status', 'Note Saved Successfully');
    } else {
      _showalertdialog('Status', 'Problem saving Note');
    }
  }

  void _delete() async{
    moveToLastScreen();
    // if user is trying to delete new node i.e he has come to the details page by pressing FAB of NoteList Page
    if(note.id == null)
      {
        _showalertdialog('Status', 'No note was deleted');
        return;
      }

    //User is trying to delte the old note that already has a valid id
    int result = await helper.deletenote(note.id);
    if (result != 0) {
      _showalertdialog('Status', 'Note Deleted Successfully');
    } else {
      _showalertdialog('Status', 'Error occurred while deleting Note');
    }

  }

  void _showalertdialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }
}
