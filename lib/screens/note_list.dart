import 'package:flutter/material.dart';

class NoteList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList>{

  int count =0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
          body: getlistview(),
      floatingActionButton: FloatingActionButton(
        onPressed:(){

        },

        tooltip: 'Add note',

        child: Icon(Icons.add),
      ),
    );
}

ListView getlistview()
{
  TextStyle ?titlestyle = Theme.of(context).textTheme.subtitle1;
  
  return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int pos){
         return Card(
            color: Colors.white,
           elevation: 3.0,
           child: ListTile(
             leading: CircleAvatar(
               backgroundColor: Colors.teal,
               child: Icon(Icons.keyboard_arrow_right),
             ),
             title: Text("sample title", style: titlestyle,),
             subtitle: Text("Smaple subtitle"),
             trailing: Icon(Icons.delete, color: Colors.grey,),
             onTap: (){

             },
           ),
         );
      },
  );
}
}