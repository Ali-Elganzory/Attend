import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/student_classrooms.dart';
import '../providers/auth.dart';

import '../models/student_classroom.dart';

import '../components/general_app_drawer.dart';

import './join_classroom_screen.dart';
import './student_classroom_details/student_classroom_details_screen.dart';

class StudentClassroomsScreen extends StatefulWidget {
  @override
  _StudentClassroomsScreenState createState() =>
      _StudentClassroomsScreenState();
}

class _StudentClassroomsScreenState extends State<StudentClassroomsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<StudentClassrooms>(context, listen: false)
          .getUserIdAndNameAndEmailAndClassroomsReferences();
      Provider.of<StudentClassrooms>(context, listen: false).fetchClassrooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double sh = screenSize.height;
    double sw = screenSize.width;

    return Scaffold(
      drawer: GeneralAppDrawer(
        userType: "student",
      ),
      appBar: AppBar(
        elevation: 1.5,
        title: Text(
          'Attend ASU',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(JoinClassroomScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Selector<StudentClassrooms, bool>(
        selector: (_, instructor) => instructor.classroomsLoading,
        shouldRebuild: (_, __) => true,
        builder: (_, classroomsLoading, __) {
          print(Provider.of<StudentClassrooms>(context, listen: false)
              .classrooms);
          if (classroomsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Stream<StudentClassroom>> _classrooms =
                Provider.of<StudentClassrooms>(context, listen: false)
                    .classrooms;
            if (_classrooms == null || _classrooms.isEmpty) {
              return Center(
                child: Text('No classrooms yet...'),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(0.04 * sw),
              itemCount: _classrooms.length,
              itemBuilder: (_, index) {
                return StreamBuilder<StudentClassroom>(
                  stream: _classrooms[index],
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      StudentClassroom classroom = snapshot.data;

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            StudentClassroomDetailsScreen.routName,
                            arguments: [
                              _classrooms[index],
                              classroom,
                            ],
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 2.5 / 1.0,
                          child: Container(
                            width: double.maxFinite,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/classroom_cover.jpg'),
                              ),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 18.0,
                                  left: 14.0,
                                  child: Text(
                                    classroom.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Positioned(
                                  bottom: 12.0,
                                  left: 14.0,
                                  child: Text(
                                    '${classroom.instructorName}',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10.0,
                                  right: 0.0,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              },
              separatorBuilder: (_, index) {
                return const SizedBox(height: 10.0);
              },
            );
          }
        },
      ),
    );
  }
}
