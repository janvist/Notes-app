import 'package:flutter/material.dart';

class Notedetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return notedetailsstate();
  }
}


class notedetailsstate extends State<Notedetails> {

  static var _priorities = ['High', 'Low'];
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle ?textStyle = Theme
        .of(context)
        .textTheme
        .titleMedium;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Note'),
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

                  value: 'Low',
                  onChanged: (valueselected) {
                    setState() {
                      debugPrint('user selected $valueselected');
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
                  },
                  decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  )
              ),
            ),
            //THIRD ELEMEMT
            Padding(
              padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
              child: TextField(
                  controller: descriptioncontroller,
                  style: textStyle,
                  onChanged: (value){
                    debugPrint("something changed in decription text field");
                  },
                  decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  )
              ),
            ),
            //FOURTH Element
            Padding(padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
    child: Row(
    children: <Widget> [
      Expanded(
      child: RaisedButton(
      color: Theme.of(context).primaryColorDark,
    textColor: Theme.of(context).primaryColorLight,
    child: Text(
    'Save',
    textScaleFactor: 1.5,
    ),
    onPressed: (){
        setState(() {
          debugPrint("Save button clicked");
        });
    },

      )),
    Container(width: 5.0,),
    Expanded(
    child: RaisedButton(
    color: Theme.of(context).primaryColorDark,
    textColor: Theme.of(context).primaryColorLight,
    child: Text(
    'Delete',
    textScaleFactor: 1.5,
    ),
    onPressed: (){
    setState(() {
    debugPrint("Delete button clicked");
    });
    },

    ))
    ],
    ),),],      ),
      ),
    );
  }


}