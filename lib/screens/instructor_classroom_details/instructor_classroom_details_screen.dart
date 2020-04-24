import 'package:flutter/material.dart';

import '../../components/general_app_drawer.dart';

import '../../screens/instructor_classroom_details/instructor_body.dart';

import '../../models/instructor_classroom.dart';

import '../../utils/excel/create_excel.dart';

class InstructorClassroomDetailsScreen extends StatelessWidget {
  static String routName = '/InstructorClassroomDetails';

  const InstructorClassroomDetailsScreen({@required this.classroom});

  final InstructorClassroom classroom;

  @override
  Widget build(BuildContext context) {
    /* Size size = MediaQuery.of(context).size;
    double sh = size.height;
    double sw = size.width; */

    return Scaffold(
      drawer: GeneralAppDrawer(
        userType: "instructor",
      ),
      appBar: AppBar(
        title: Text(
          '${classroom.name}',
        ),
      ),
      body: InstructorBody(classroom: classroom),
    );
  }
}
