import 'package:flutter/material.dart';
import './instructor_painter.dart';
import './studentInfo.dart';
class InstructorBody extends StatefulWidget {
  @override
  _InstructorBodyState createState() => _InstructorBodyState();
}

class _InstructorBodyState extends State<InstructorBody> {
  List<StudentInfo> students=[
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042'),
    StudentInfo(number:23 ,name:'Ahmed',id:'18P7042')
  ];
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    double sh = size.height;
    double sw = size.width;
    final counter=TextEditingController();
    counter.text =0.toString();
    bool enable = true;
    return Container(
     child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
      Column(
        children: <Widget>[
      Container(
        height: sh*0.68,
        child: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context,index){
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(students[index].number.toString(), style: TextStyle(color: Colors.white),),
                backgroundColor: Colors.orange,),
              title: Text(students[index].name,style: TextStyle(color: Colors.orange),),
            ) ,
           );
                    },
                      ),
                  ),
          ],
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          bottom: 0.5 * sh,
          child: Container(),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          height: 0.3 * sh,
          child: InkWell(
            onLongPress: null,
            onTap: () {
              //exportClassroomToExcel(classroom);
            },
            child: CustomPaint(
              painter: InstructorPainter(),
            ),
          ),
        ),
        Positioned(
          bottom: 0.15 * sh,
          left: 0.25 * sw,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.orange),
            child: IconButton(
              iconSize: 33,
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed:  () {
                counter.text = (int.parse(counter.text) + 1).toString();
                print(counter);
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0.15 * sh,
          right: 0.25 * sw,
          child: Container(
            
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
            child: IconButton(
              iconSize: 33,
              icon: Icon(
                Icons.remove,
                color: Colors.white,
                
              ),
              splashColor: Colors.grey,
              onPressed:  () {
                counter.text = (int.parse(counter.text) - 1).toString();
                print(counter);
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0.15 * sh,
          right: 0.45 * sw,
          child: Container(
            height: 30,
            width: 40,
            color: Colors.white,
            child: TextField(
             
              enabled: enable,
              controller: counter,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.pink),
            ),
          ),
        ),
        
      ],
        ),
    );
  }
}