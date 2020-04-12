import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../screens/instructor_classrooms_screen.dart';

class InstructorDrawer extends StatelessWidget {
  const InstructorDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
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
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Text(
                      "name",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text(
                "Classes",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            ListTile(
              leading: Icon(Icons.file_download, color: Colors.white),
              title: Text(
                "Export ",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/ms_excel_icon.png'),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              title: Text(
                "Sign out",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
