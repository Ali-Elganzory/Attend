import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import './utils/app_theme_data.dart';

import './providers/auth.dart';
import './providers/instructor_classrooms.dart';

import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './screens/home_screen.dart';
import './screens/create_classroom_screen.dart';

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
        ChangeNotifierProvider<InstructorClassrooms>(
          create: (_) => InstructorClassrooms(),
        ),
      ],
      child: MaterialApp(
        theme: appThemeData,
        home: Selector<Auth, bool>(
          selector: (_, auth) {
            _staticAuthProvider = auth;
            return auth.isAuth;
          },
          builder: (_, isAuth, __) {
            return isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: _staticAuthProvider.tryAutoLogin(),
                    builder: (_, authResultSnapshot) {
                      if (authResultSnapshot.connectionState ==
                          ConnectionState.done) {
                        if (authResultSnapshot.data) {
                          return HomeScreen();
                        } else {
                          return AuthScreen();
                        }
                      } else {
                        return SplashScreen();
                      }
                    },
                  );
          },
          child: AuthScreen(),
        ),
        routes: {
          CreateClassroom.routeName: (_) => CreateClassroom(),
        },
      ),
    );
  }
}
