import 'package:flutter/material.dart';

import '../../components/general_app_drawer.dart';

import '../../screens/instructor_classroom_details/instructor_body.dart';

import '../../models/instructor_classroom.dart';
import '../../models/instructor_student.dart';

import '../../utils/excel/create_excel.dart';

class InstructorClassroomDetailsScreen extends StatelessWidget {
  static String routName = '/InstructorClassroomDetails';

  const InstructorClassroomDetailsScreen({
    @required this.classroomStream,
    @required this.initialClassroomSnapshot,
    @required this.initialStudentsSnapshot,
  });

  final Stream<InstructorClassroom> classroomStream;
  final InstructorClassroom initialClassroomSnapshot;
  final List<InstructorStudent> initialStudentsSnapshot;

  @override
  Widget build(BuildContext context) {
    /* Size size = MediaQuery.of(context).size;
    double sh = size.height;
    double sw = size.width; */

    return StreamBuilder<InstructorClassroom>(
      stream: classroomStream,
      initialData: initialClassroomSnapshot,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          InstructorClassroom classroom = snapshot.data;

          return Scaffold(
            drawer: GeneralAppDrawer(
              userType: "instructor",
            ),
            appBar: AppBar(
              title: Text(
                '${classroom.name}',
              ),
            ),
            body: InstructorBody(classroom: classroom, initialStudentsSnapshot: initialStudentsSnapshot,),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
