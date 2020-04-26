import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/auth.dart';
import '../providers/instructor_classrooms.dart';
import '../providers/student_classrooms.dart';

class GeneralAppDrawer extends StatelessWidget {
  const GeneralAppDrawer({
    Key key,
    @required this.userType,
  }) : super(key: key);

  final String userType;

  @override
  Widget build(BuildContext context) {
    dynamic profile = userType == "instructor"
        ? Provider.of<InstructorClassrooms>(context, listen: true)
        : Provider.of<StudentClassrooms>(context, listen: true);

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
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return PhotoDialog(
                                staticProfile: profile,
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              image: profile.photo == null
                                  ? AssetImage('assets/images/profile.png')
                                  : NetworkImage(
                                      profile.photo,
                                    ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      profile.name,
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
            if (userType == "instructor")
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
                Navigator.pop(context);
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoDialog extends StatelessWidget {
  final dynamic staticProfile;

  const PhotoDialog({@required this.staticProfile});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Change Profile Photo',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                try {
                  File photo = await ImagePicker.pickImage(
                    source: ImageSource.camera,
                  );

                  Navigator.of(context).pop();

                  if (photo != null) await staticProfile.uploadPhoto(photo);
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.maxFinite,
                child: Text(
                  'Take Photo',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                try {
                  File photo = await ImagePicker.pickImage(
                    source: ImageSource.gallery,
                  );

                  Navigator.of(context).pop();

                  if (photo != null) await staticProfile.uploadPhoto(photo);
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                width: double.maxFinite,
                child: Text(
                  'Choose Photo',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
