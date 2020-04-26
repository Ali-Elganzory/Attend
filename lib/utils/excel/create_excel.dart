/* import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/instructor_classroom.dart';
import '../../models/instructor_student.dart';

Future<void> exportClassroomToExcel(InstructorClassroom classroom) async {
  Excel excel = Excel.createExcel();

  String sheet = classroom.name;
  
  excel
    ..updateCell(sheet, CellIndex.indexByString('A1'), 'ID',
        backgroundColorHex: '#81C784')
    ..updateCell(sheet, CellIndex.indexByString('B1'), 'Name',
        backgroundColorHex: '#81C784')
    ..updateCell(sheet, CellIndex.indexByString('C1'), '# of Attended sessions',
        backgroundColorHex: '#81C784');

  int i = 2;
  for (InstructorStudent student in classroom.students) {
    excel
      ..updateCell(sheet, CellIndex.indexByString('A$i'), student.collegeId)
      ..updateCell(sheet, CellIndex.indexByString('B$i'), student.name)
      ..updateCell(
          sheet, CellIndex.indexByString('C$i'), student.sessions.length);

    i++;
  }

  Directory dir = await getExternalStorageDirectory();

  print(dir.path);

  excel.encode().then((onValue) {
    File(join("${dir.path}/${classroom.name}.xlsx"))
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue);
  }).then((_) {
    print('saved...');
  });
}
 */