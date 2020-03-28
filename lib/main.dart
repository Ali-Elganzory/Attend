import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import './utils/app_theme_data.dart';

import './providers/auth.dart';

import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './screens/home_screen.dart';

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
    return MaterialApp(
      theme: appThemeData,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>(
            create: (_) => Auth(),
          )
        ],
        child: Selector<Auth, bool>(
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
      ),
    );
  }
}
