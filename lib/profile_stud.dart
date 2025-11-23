import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class StudProf extends StatefulWidget {
  const StudProf({super.key});

  @override
  State<StudProf> createState() => _StudProfState();
}

class _StudProfState extends State<StudProf> {

  List <Map<String,dynamic>> alltasks = [];
  Set<String> completedTasks = {};
  String name = "";
  String className = "";
  String role = "";
  String userID = "";
  bool isLoading = false;


  @override
  void initState(){
    super.initState();
    getUserData();
  }

  Future <void> getUserData() async{
    try{
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot studSnapshot = await FirebaseFirestore.instance
          .collection("students")
          .doc(uid)
          .get();

      if (studSnapshot.exists) {
        Map<String, dynamic> data = studSnapshot.data() as Map<String, dynamic>;

        setState(() {
          name = data["name"] ?? "N/A";
          role = data["role"] ?? "N/A";
          className = data["class"] ?? "N/A";
          userID = uid;
        });

        await getTasks();
      }
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error: $e"),
              backgroundColor:Colors.red[400]
          )
      );
    }
  }

  Future <void> getTasks() async{
    setState(() {
      isLoading = true;
    });

    try{
      List <Map<String, dynamic>> tasks = [];
      Set<String> completed = {};

      QuerySnapshot teacherSnapshot = await FirebaseFirestore.instance
          .collection("teachers")
          .get();

      for (var teacherDoc in teacherSnapshot.docs) {
        String teacherId = teacherDoc.id;

        QuerySnapshot taskSnapshot = await FirebaseFirestore.instance
            .collection("teachers")
            .doc(teacherId)
            .collection("tasks")
            .get();

        for (var taskDoc in taskSnapshot.docs) {
          Map<String, dynamic> taskData = taskDoc.data() as Map<String, dynamic>;
          taskData["taskId"] = taskDoc.id;
          taskData["teacherId"] = teacherDoc.id;
          tasks.add(taskData);

          List<dynamic> records = taskData["records"] ?? [];

          for (var record in records) {
            if (record["student uid"] == userID) {
              completed.add(taskDoc.id);
              break;
            }
          }
        }
      }

      setState((){
        alltasks = tasks;
        completedTasks = completed;
        isLoading = false;
      });
    }
    catch(e){
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error: $e"),
              backgroundColor:Colors.red[400]
          )
      );
    }
  }

  // Future<void> _refreshData() async {
  //   await getUserData();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Data refreshed successfully"),
  //         backgroundColor: Colors.green,
  //         duration: Duration(seconds: 1),
  //       )
  //   );
  // }

  Future <void> addRecords(String taskId, String teacherId) async{
    try{
      Map <String,dynamic> records = {
        "student uid" : userID,
        "student name" : name,
        "class" : className,
        "completed at" : DateTime.now().toString(),
      };

      await FirebaseFirestore.instance
          .collection("teachers")
          .doc(teacherId)
          .collection("tasks")
          .doc(taskId)
          .update({
        "records" : FieldValue.arrayUnion([records])
      });

      setState(() {
        completedTasks.add(taskId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:Text("Successfully marked as completed"),
              backgroundColor:Colors.green
          )
      );
    }
    catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:Text("Error: $error"),
              backgroundColor:Colors.red
          )
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          title:Text(name.toUpperCase(),
              style:TextStyle(
                  color:Colors.white,
                  fontSize:24,
                  fontWeight:FontWeight.bold
              )),
          centerTitle:true,
          backgroundColor:Colors.blue,
          iconTheme:IconThemeData(
              color:Colors.white,
              size:30
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.refresh, color: Colors.white),
          //     onPressed: _refreshData,
          //     tooltip: "Refresh",
          //   )
          // ],
        ),
        body:Stack(
          children: [
            Positioned(
                top:10,
                left:10,
                child:Text("User role: $role",
                    style:TextStyle(
                        color:Colors.blue[800],
                        fontSize:17,
                        fontWeight:FontWeight.bold
                    ))
            ),
            Positioned(
                top:40,
                left:10,
                child:Text("UID: $userID",
                    style:TextStyle(
                        color:Colors.blue[800],
                        fontSize:17,
                        fontWeight:FontWeight.bold
                    ))
            ),
            Positioned(
                top:120,
                left:10,
                bottom:10,
                right:10,
                child: isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                )
                    : ListView.builder(
                    itemCount:alltasks.length,
                    itemBuilder:(context,index){

                      Map<String,dynamic> task = alltasks[index];

                      String title = task["title"] ?? "No title";
                      String description = task["description"] ?? "No description";
                      String teacher = task["created by"] ?? "No name";
                      String createdAt = (task["created at"] ?? "No time").toString();
                      String deadline = task["deadline"] ?? "No deadline";

                      bool isCompleted = completedTasks.contains(task["taskId"]);

                      List<String> teacherName = teacher.split("_");

                      return Card(
                          margin:const EdgeInsets.all(10),
                          elevation:5,
                          shape:RoundedRectangleBorder(
                            borderRadius:BorderRadius.all(Radius.circular(30)),
                          ),
                          child:Container(
                              height:200,
                              width:250,
                              decoration:BoxDecoration(
                                  gradient:LinearGradient(
                                      colors:[Colors.white,Colors.blue],
                                      begin:Alignment.topLeft,
                                      end:Alignment.bottomRight
                                  ),
                                  borderRadius:BorderRadius.all(
                                      Radius.circular(30)
                                  )
                              ),
                              child:Stack(
                                  children:[
                                    Row(
                                        mainAxisAlignment:MainAxisAlignment.center,
                                        children:[
                                          Text(title.toUpperCase(),
                                              style:TextStyle(
                                                  color:Colors.black45,
                                                  fontSize:20,
                                                  fontWeight:FontWeight.w600
                                              )
                                          )
                                        ]
                                    ),
                                    Positioned(
                                        top:5,
                                        right:15,
                                        child:Container(
                                            padding:const EdgeInsets.all(3),
                                            decoration:BoxDecoration(
                                                color:Colors.green[100],
                                                borderRadius:BorderRadius.all(Radius.circular(20))
                                            ),
                                            child:Row(
                                                children:[
                                                  Icon(
                                                      Icons.person,
                                                      color:Colors.black,
                                                      size:15
                                                  ),
                                                  SizedBox(width:5),
                                                  Text(teacherName[0],
                                                      style:TextStyle(
                                                          fontSize:11
                                                      )
                                                  )
                                                ]
                                            )
                                        )
                                    ),
                                    Positioned(
                                        top:40,
                                        left:20,
                                        child:Text("Description: $description",
                                            style:TextStyle(
                                                fontSize:11,
                                                color:Colors.black
                                            )
                                        )
                                    ),
                                    Positioned(
                                        top:70,
                                        left:20,
                                        child:Text("Published by: $teacher",
                                            style:TextStyle(
                                                fontSize:11,
                                                color:Colors.black
                                            )
                                        )
                                    ),
                                    Positioned(
                                        top:100,
                                        left:20,
                                        child:Text("published on: $createdAt.",
                                            style:TextStyle(
                                                fontSize:11,
                                                color:Colors.black
                                            )
                                        )
                                    ),
                                    Positioned(
                                        top:130,
                                        left:20,
                                        child:Text("Deadline: $deadline",
                                            style:TextStyle(
                                                fontSize:11
                                            )
                                        )
                                    ),
                                    Positioned(
                                        bottom:15,
                                        right:15,
                                        child:SizedBox(
                                            height:30,
                                            child:ElevatedButton(
                                                onPressed: isCompleted ? null : () async {
                                                  await addRecords(task["taskId"], task["teacherId"]);
                                                },
                                                style:ElevatedButton.styleFrom(
                                                    foregroundColor:Colors.white,
                                                    backgroundColor: isCompleted ? Colors.grey : Colors.green,
                                                    disabledBackgroundColor: Colors.grey,
                                                    disabledForegroundColor: Colors.white
                                                ),
                                                child: isCompleted ?
                                                Text("Completed") :
                                                Text("Done")
                                            )
                                        )
                                    )
                                  ]
                              )
                          )
                      );
                    }
                )
            )
          ],
        )
    );
  }
}
//