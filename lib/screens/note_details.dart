import 'package:flutter/material.dart';

class Notedetails extends StatefulWidget{
  @override

  State<StatefulWidget> createState() {
    return notedetailsstate();
  }
  }

}

class notedetailsstate extends State<Notedetails>
{

  static var _priorities = ['High','Low'];
  @override
  Widget build(BuildContext context) {
    TextStyle ?textStyle = Theme.of(context).textTheme.titleMedium;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Note'),
      ),

      body: Padding(padding: EdgeInsets.only(top: 15.0,left: 10.0,right: 10.0),
      child: ListView(
        children: <Widget>[
          ListTile(
            title: DropdownButton(
              items: _priorities.map ((String dropDownStringItem)
    {
                return DropdownMenuItem<String> (
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
    ],
          ),
      ),
    );
  }


}