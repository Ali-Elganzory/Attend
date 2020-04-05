import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../utils/excel/create_excel.dart';

import '../../models/instructor_classroom.dart';

import './instructor_painter.dart';

class InstructorClassroomDetailsScreen extends StatelessWidget {
  static String routName = '/InstructorClassroomDetails';

  InstructorClassroomDetailsScreen({@required this.classroom});
  
  String name="no_name";
  final InstructorClassroom classroom;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sh = size.height;
    double sw = size.width;

    return Scaffold(
      drawer:
      SizedBox(
        width: MediaQuery.of(context).size.width*0.6,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color.fromRGBO(128, 128, 128, 0.5)
        ),
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
                            decoration: 
                            BoxDecoration(shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(image: AssetImage('assets/images/profile.png',),fit:BoxFit.cover) ),
                            ),
                      ),
                          Text(name,style: TextStyle(color: Colors.white),)
                    ],
                  ),
              ),
            ),
            ListTile(
                leading: Icon(Icons.home,color: Colors.white),
                title: Text("Home",style: TextStyle(color: Colors.white)),
                onTap: (){
                  Navigator.pop(context);
                },
            ),
            ListTile(
                leading: Icon(Icons.file_download,color: Colors.white),
                title: Text("Download",style: TextStyle(color: Colors.white)),
                onTap: (){
                  Navigator.pop(context);
                },
            ),
            ListTile(
                leading: Icon(Icons.exit_to_app,color: Colors.white,),
                title: Text("Sign out",style: TextStyle(color: Colors.white)),
                onTap: (){
                  Navigator.pop(context);
                },
            ),
          ],
        ),

    ),
          ),
              ),
      ) ,
      appBar:AppBar(
        title: Center(child: 
        Text('Attendance',
        style: Theme.of(context).textTheme.bodyText1,)),
        backgroundColor: Theme.of(context).backgroundColor,),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.6 * sh,
            child: Container(),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            height: 0.5 * sh,
            child: InkWell(
              onTap: () {
                exportClassroomToExcel(classroom);
              },
              child: CustomPaint(
                painter: InstructorPainter(),
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}
