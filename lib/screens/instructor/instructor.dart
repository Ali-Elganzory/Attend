import 'package:flutter/material.dart';
import '../custom_widgets/customButton.dart';
class Instructor extends StatefulWidget {
  final Color switcher;
  Instructor(this.switcher);

  @override
  _InstructorState createState() => _InstructorState();
}

class _InstructorState extends State<Instructor> {
  var pColor=Color.fromRGBO(192, 192, 192, 1); //indicates the user is at the profiles section
  var tColor=Color.fromRGBO(51, 153, 255, 1);  //indicates the user is at the Today section
  void profilesFun(){
    setState(() {
         pColor=Color.fromRGBO(51, 153, 255, 1);
         tColor=Color.fromRGBO(192, 192, 192, 1);
    });
  }
  void todayFun(){
    setState(() {
         tColor=Color.fromRGBO(51, 153, 255, 1);
         pColor=Color.fromRGBO(192, 192, 192, 1);
    });
  }
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height= MediaQuery.of(context).size.height;
    Widget appbar(var icon,Color color,String text,void fun()){
      return Container(
                  height: height*0.15,width: (width)/2,
                  child: Stack(children: <Widget>[
                    Container(
                      color: Theme.of(context).canvasColor,
                      height:  height*0.15,width: (width)/2,
                      child: 
                   FlatButton(
                        onPressed: (){
                          fun();
                         },
                        child: Align(
                          alignment: Alignment.topCenter,
                            child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(icon,color: Theme.of(context).primaryColor,),
                          ),
                        ),
                        color: Theme.of(context).canvasColor),
                    ),
                      
                      Positioned(
                        left: width/5.6,
                        bottom:height*0.05,
                        child: Text(text,style: Theme.of(context).textTheme.body1,)),
                      Align(
                        alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                          heightFactor: 0.05,
                          widthFactor: 1,
                          child: Container(decoration:BoxDecoration(color: color),),
                        ),
                      )
                  ],),
                );}
    return Scaffold(
      appBar:AppBar(
        leading: IconButton(
          onPressed: null,
          icon: Icon(Icons.view_list,color: Colors.white,),
        ),
        title: Center(child: 
        Text('Attendance',
        style: Theme.of(context).textTheme.title,)),
        backgroundColor: Theme.of(context).primaryColor,),
      
      body: 
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
        children:<Widget>[
          Row(
              
              children: <Widget>[
                 appbar(Icons.person,pColor,'Profiles',profilesFun),
                 appbar(Icons.today,tColor,'Today',todayFun)
                
              ],
            ),
      widget.switcher==Color.fromRGBO(51, 153, 255, 1)?
      Container(
              child: Column(
                children:<Widget>[
                  CustomPaint(
                    painter: CustomButton(
                      width: width-MediaQuery.of(context).padding.left,
                      height: height-MediaQuery.of(context).padding.top),
                      
                    ),
                
              ]),
            
            ):
      Container()]));
    
  }
}