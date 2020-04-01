import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/instructor_classrooms.dart';
import '../providers/auth.dart';

import '../models/instructor_classroom.dart';

import './create_classroom_screen.dart';
import './instructor_classroom_details/instructor_classroom_details_screen.dart';

class InstructorClassroomsScreen extends StatefulWidget {
  @override
  _InstructorClassroomsScreenState createState() =>
      _InstructorClassroomsScreenState();
}

class _InstructorClassroomsScreenState
    extends State<InstructorClassroomsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<InstructorClassrooms>(context, listen: false)
          .getUserIdAndNameAndEmail();
      Provider.of<InstructorClassrooms>(context, listen: false)
          .fetchClassrooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double sh = screenSize.height;
    double sw = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.5,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Color(0xCC000000),
          ),
          onPressed: () {
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
        title: Text(
          'Attend ASU',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Color(0xCC000000),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CreateClassroomScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Color(0xCC000000),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Selector<InstructorClassrooms, bool>(
        selector: (_, instructor) => instructor.classroomsLoading,
        builder: (_, classroomsLoading, __) {
          if (classroomsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<InstructorClassroom> _classrooms =
                Provider.of<InstructorClassrooms>(context, listen: false)
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
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      InstructorClassroomDetailsScreen.routName,
                      arguments: _classrooms[index],
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
                          image:
                              AssetImage('assets/images/classroom_cover.jpg'),
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 18.0,
                            left: 14.0,
                            child: Text(
                              _classrooms[index].name,
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
                              '${_classrooms[index].students.length} students',
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
