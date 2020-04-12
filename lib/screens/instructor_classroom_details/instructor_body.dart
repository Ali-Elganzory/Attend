import 'package:flutter/material.dart';

import '../../models/instructor_classroom.dart';

import './instructor_painter.dart';
import './studentInfo.dart';

class InstructorBody extends StatefulWidget {
  const InstructorBody({@required this.classroom});

  final InstructorClassroom classroom;

  @override
  _InstructorBodyState createState() => _InstructorBodyState();
}

class _InstructorBodyState extends State<InstructorBody> {
  int numOfStudents = 0;
  bool enable = true;

  TextEditingController _numOfStudentsController;
  TextEditingController _attendanceCodeController;

  @override
  void initState() {
    super.initState();

    _numOfStudentsController = TextEditingController();
    _attendanceCodeController = TextEditingController();
    _numOfStudentsController.text = '0';
  }

  @override
  void dispose() {
    super.dispose();

    _numOfStudentsController.dispose();
    _attendanceCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sh = size.height;
    double sw = size.width;

    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              !enable
                  ? Container(
                      height: sh * 0.68,
                      child: ListView.builder(
                        itemCount: numOfStudents,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  widget
                                      .classroom.students[index].sessions.length
                                      .toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor:
                                    Color.fromRGBO(126, 185, 255, 1),
                              ),
                              title: Text(
                                widget.classroom.students[index].name,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(height: sh * 0.7),
            ],
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            height: 0.35 * sh,
            child: CustomPaint(
              painter: InstructorPainter(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0.20 * sh - 120,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(123, 112, 255, 1),
                      ),
                      child: IconButton(
                        iconSize: 33,
                        icon: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        onPressed: enable
                            ? () {
                                return _numOfStudentsController.text == "" ||
                                        int.tryParse(_numOfStudentsController
                                                .text) ==
                                            null ||
                                        int.tryParse(_numOfStudentsController
                                                .text) <=
                                            1
                                    ? _numOfStudentsController.text = "1"
                                    : _numOfStudentsController
                                        .text = (int.tryParse(
                                                _numOfStudentsController.text) -
                                            1)
                                        .toString();
                              }
                            : null,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 40,
                      width: 100,
                      child: TextFormField(
                        enabled: enable,
                        controller: _numOfStudentsController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(163, 160, 185, 1),
                        ),
                        decoration: inputDecoration.copyWith(hintText: "num"),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (quantity) {
                          if (quantity == "") return "Number";
                          return int.tryParse(quantity) == null ||
                                  int.tryParse(quantity) <= 0
                              ? "Not a Number"
                              : null;
                        },
                        onSaved: (quantity) {},
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(123, 112, 255, 1),
                      ),
                      child: IconButton(
                        iconSize: 33,
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        splashColor: Colors.grey,
                        onPressed: enable
                            ? () {
                                return _numOfStudentsController.text == "" ||
                                        int.tryParse(_numOfStudentsController
                                                .text) ==
                                            null
                                    ? _numOfStudentsController.text = "1"
                                    : _numOfStudentsController
                                        .text = (int.tryParse(
                                                _numOfStudentsController.text) +
                                            1)
                                        .toString();
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 40,
                  width: 200,
                  child: TextFormField(
                    enabled: enable,
                    controller: _attendanceCodeController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(163, 160, 185, 1),
                    ),
                    decoration:
                        inputDecoration.copyWith(hintText: "Attendance code"),
                    keyboardType: TextInputType.number,
                    validator: (code) {
                      if (code == "") return "Please, enter a code";
                      return code.length <= 3 ? "code >= 4 characters" : null;
                    },
                    onSaved: (quantity) {},
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 30, left: 0.15 * sw, right: 0.15 * sw),
                  height: 45,
                  width: double.maxFinite,
                  child: FlatButton(
                    color: Color.fromRGBO(100, 130, 255, 1),
                    onPressed: () {},
                    child: Text(
                      "UPDATE",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final inputDecoration = InputDecoration(
    contentPadding: const EdgeInsets.only(
      top: 2.5,
      bottom: 2.5,
      left: 2.0,
      right: 2.0,
    ),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(fontSize: 16));
