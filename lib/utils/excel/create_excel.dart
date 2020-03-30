import 'package:excel/excel.dart';

import '../../models/instructor_classroom.dart';
import '../../models/instructor_student.dart';

Future<void> exportExcel(InstructorClassroom classroom) {
  Excel excel = Excel.createExcel();

  String sheet = classroom.name;

  int i = 2;
  for (InstructorStudent student in classroom.students) {
    excel
      ..updateCell(sheet, CellIndex.indexByString('A$i'), student.collegeId)
      ..updateCell(sheet, CellIndex.indexByString('B$i'), student.name)
      ..updateCell(
          sheet, CellIndex.indexByString('C$i'), student.sessions.length);

      i++;
  }
}
