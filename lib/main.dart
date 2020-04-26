import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import './utils/app_theme_data.dart';

import './providers/auth.dart';
import './providers/instructor_classrooms.dart';
import './providers/student_classrooms.dart';

import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './screens/instructor_classrooms_screen.dart';
import './screens/create_classroom_screen.dart';
import './screens/student_classrooms_screen.dart';
import './screens/join_classroom_screen.dart';
import './screens/instructor_classroom_details/instructor_classroom_details_screen.dart';
import './screens/student_classroom_details/student_classroom_details_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Auth _staticAuthProvider;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
      ],
      child: Selector<Auth, bool>(
        selector: (_, auth) {
          _staticAuthProvider = auth;
          return auth.isAuth;
        },
        builder: (_, isAuth, __) {
          bool isStudent = _staticAuthProvider.userType == UserType.students;

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<InstructorClassrooms>(
                create: (_) => InstructorClassrooms(),
              ),
              ChangeNotifierProvider<StudentClassrooms>(
                create: (_) => StudentClassrooms(),
              ),
            ],
            child: MaterialApp(
              theme: appThemeData,
              home: isAuth
                  ? isStudent
                      ? StudentClassroomsScreen()
                      : InstructorClassroomsScreen()
                  : FutureBuilder(
                      future: _staticAuthProvider.tryAutoLogin(),
                      builder: (_, authResultSnapshot) {
                        if (authResultSnapshot.connectionState ==
                            ConnectionState.done) {
                          if (authResultSnapshot.data) {
                            return isStudent
                                ? StudentClassroomsScreen()
                                : InstructorClassroomsScreen();
                          } else {
                            return AuthScreen();
                          }
                        } else {
                          return SplashScreen();
                        }
                      },
                    ),
              routes: {
                CreateClassroomScreen.routeName: (_) => CreateClassroomScreen(),
                JoinClassroomScreen.routeName: (_) => JoinClassroomScreen(),
              },
              onGenerateRoute: (settings) {
                if (settings.name ==
                    InstructorClassroomDetailsScreen.routName) {
                  return MaterialPageRoute(
                    builder: (context) => InstructorClassroomDetailsScreen(
                      classroomStream: (settings.arguments as List)[0],
                      initialClassroomSnapshot: (settings.arguments as List)[1],
                      initialStudentsSnapshot: (settings.arguments as List)[2],
                    ),
                  );
                } else if (settings.name ==
                    StudentClassroomDetailsScreen.routName) {
                  return MaterialPageRoute(
                    builder: (context) => StudentClassroomDetailsScreen(
                      classroomStream: (settings.arguments as List)[0],
                      initialSnapshot: (settings.arguments as List)[1],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
