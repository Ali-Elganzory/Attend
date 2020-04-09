import 'dart:ui';

import 'package:flutter/material.dart';
import 'studentInfo.dart';

import '../../utils/excel/create_excel.dart';

import '../../models/instructor_classroom.dart';

import './instructor_painter.dart';

class InstructorClassroomDetailsScreen extends StatelessWidget {

  static String routName = '/InstructorClassroomDetails';

  InstructorClassroomDetailsScreen({@required this.classroom});
  String name = "no_name";
  List<StudentInfo> students=[
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042')
  ];
  final InstructorClassroom classroom;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sh = size.height;
    double sw = size.width;
    final counter=TextEditingController();
    counter.text =0.toString();
    bool enable = true;
    return Scaffold(
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Theme(
            data: Theme.of(context)
                .copyWith(canvasColor: Color.fromRGBO(255, 51, 51, 0.5)),
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Padding(
                padding: const EdgeInsets.all(10.0),
                child: DrawerHeader(
                  child: Column(
                  children: <Widget>[
                    Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                    image: AssetImage(
                                    'assets/images/profile.png',
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                          ),
                          Text(
                            name,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.white),
                    title: Text("Home", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.file_download, color: Colors.white),
                    title:
                        Text("Download", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    title:
                        Text("Sign out", style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
      
        backgroundColor: Colors.pink,
      ),
      body: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: sh*0.7,
                    child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context,index){
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(students[index].number.toString(), style: TextStyle(color: Colors.white),),
                            backgroundColor: Colors.orange,),
                          title: Text(students[index].name,style: TextStyle(color: Colors.orange),),
                        ) ,
                      );
                    },
                      ),
                  ),
          ],
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          bottom: 0.5 * sh,
          child: Container(),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          height: 0.3 * sh,
          child: InkWell(
            onLongPress: null,
            onTap: () {
              exportClassroomToExcel(classroom);
            },
            child: CustomPaint(
              painter: InstructorPainter(),
            ),
          ),
        ),
        Positioned(
          bottom: 0.15 * sh,
          left: 0.25 * sw,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.orange),
            child: IconButton(
              iconSize: 33,
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed:  () {
                counter.text = (int.parse(counter.text) + 1).toString();
                print(counter);
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0.15 * sh,
          right: 0.25 * sw,
          child: Container(
            
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
            child: IconButton(
              iconSize: 33,
              icon: Icon(
                Icons.remove,
                color: Colors.white,
                
              ),
              splashColor: Colors.grey,
              onPressed:  () {
                counter.text = (int.parse(counter.text) - 1).toString();
                print(counter);
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0.15 * sh,
          right: 0.45 * sw,
          child: Container(
            height: 30,
            width: 40,
            color: Colors.white,
            child: TextField(
             
              enabled: enable,
              controller: counter,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.pink),
            ),
          ),
        ),
        
      ],
        ),
    );
  }
}
