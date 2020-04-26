import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/date.dart';

Future<String> exportClassroomsToExcel(String uid) async {
  Firestore _firestore = Firestore.instance;

  List<String> classroomsReferences =
      ((await _firestore.collection('instructors').document(uid).get())
              .data['classrooms'] as List<dynamic>)
          .map((ref) => ref.toString())
          .toList();

  List<Map<String, dynamic>> classrooms = [];

  for (String ref in classroomsReferences) {
    Map<String, dynamic> classroom =
        (await _firestore.collection('classrooms').document(ref).get()).data;

    List<Map<String, dynamic>> students = (await _firestore
            .collection('classrooms')
            .document(ref)
            .collection('students')
            .getDocuments())
        .documents
        .map((stud) => stud.data)
        .toList();
    classroom.putIfAbsent('students', () => students);

    classrooms.add(classroom);
  }

  Excel excel = Excel.createExcel();

  for (Map<String, dynamic> classroom in classrooms) {
    String sheet = classroom['name'];

    excel
      ..updateCell(sheet, CellIndex.indexByString('A1'), 'ID',
          backgroundColorHex: '#81C784')
      ..updateCell(sheet, CellIndex.indexByString('B1'), 'Name',
          backgroundColorHex: '#81C784')
      ..updateCell(
          sheet, CellIndex.indexByString('C1'), '# of Attended sessions',
          backgroundColorHex: '#81C784');

    int i = 2;
    for (Map<String, dynamic> student in classroom['students']) {
      excel
        ..updateCell(
            sheet, CellIndex.indexByString('A$i'), student['collegeId'])
        ..updateCell(sheet, CellIndex.indexByString('B$i'), student['name'])
        ..updateCell(
            sheet, CellIndex.indexByString('C$i'), student['sessions'].length);

      i++;
    }
  }

  Directory dir = await getExternalStorageDirectory();

  print(dir.path);

  excel.encode().then((onValue) {
    File(join(
        "${dir.path}/${Date.fromDateTime(DateTime.now()).toString()}.xlsx"))
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue);
  }).then((_) {
    print('saved...');
  });

  return join(
      "${dir.path}/${Date.fromDateTime(DateTime.now()).toString()}.xlsx");
}
