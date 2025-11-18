import "package:flutter/material.dart";
import "package:project_myapp/account_teacher.dart";
import "package:project_myapp/account_stud.dart";


// void main(){
//   runApp(TeacherRoleApp());
// }

class TeacherRoleApp extends StatefulWidget {
  const TeacherRoleApp({super.key});

  @override
  State<TeacherRoleApp> createState() => _TeacherRoleAppState();
}

class _TeacherRoleAppState extends State<TeacherRoleApp> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title:const Text("Choose Role",
          style:TextStyle(
            color:Colors.white,
            fontSize:25,
            fontWeight:FontWeight.bold
          )
        ),
        centerTitle:true,
        backgroundColor:Colors.blue,
        iconTheme:IconThemeData(
          color:Colors.white,
          size:30
        ),
      ),
      body:SafeArea(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.start,
            children:[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Text("Select your role",
                    style:TextStyle(
                      color:Colors.blue,
                      fontSize:40,
                      fontWeight:FontWeight.bold
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: ElevatedButton(
                    onPressed:(){
                      Navigator.push(context,MaterialPageRoute(builder:(context) => const TeacherProfApp() ));
                    },
                    style:ElevatedButton.styleFrom(
                      minimumSize:const Size(400,250),
                      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(50)),
                      backgroundColor:Colors.red,
                      foregroundColor:Colors.white,
                      elevation:10,
                      shadowColor:Colors.black,
                    ),
                    child:const Text("Teacher",
                      style:TextStyle(
                        fontSize:40,
                        fontWeight:FontWeight.w400
                      )
                    )
                  ),
                ),
              Padding(
                padding:const EdgeInsets.all(30),
                child:ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    minimumSize:const Size(400,250),
                    shape:RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(50))),
                    backgroundColor:Colors.green,
                    foregroundColor:Colors.white,
                    elevation:10,
                    shadowColor:Colors.black
                  ),
                  onPressed:(){
                    Navigator.push(context,MaterialPageRoute(builder:(context)=>const StudProfApp()));
                  },
                  child:const Text("Student",
                    style:TextStyle(
                      fontSize:40,
                      fontWeight:FontWeight.w400
                    ))
                )
              )
            ]
          )
      ),
      backgroundColor:Colors.white
    );
  }
}
