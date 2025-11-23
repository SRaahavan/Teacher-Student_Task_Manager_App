import "package:flutter/material.dart";
import "package:project_myapp/login_page.dart";

class StudRecords extends StatefulWidget {
  const StudRecords({super.key});

  @override
  State<StudRecords> createState() => _StudRecordsState();
}

class _StudRecordsState extends State<StudRecords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text("Student Name",
          style:TextStyle(
            color:Colors.white,
            fontSize:24,
            fontWeight:FontWeight.w600
          )
        ),
        centerTitle:true,
        backgroundColor:Colors.blue,
      ),
      body:SafeArea(
        child:Center(
          child:SizedBox(
            child:ElevatedButton(
              onPressed:(){
                Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>SignInApp()));
              },
              style:ElevatedButton.styleFrom(
                backgroundColor:Colors.blue,
                foregroundColor:Colors.white,
              ),
              child:const Text("Log out")
            )
          )
        ),
      ),
      backgroundColor:Colors.white
    );
  }
}

//
