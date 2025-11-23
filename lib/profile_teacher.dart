import "package:flutter/material.dart";
import "package:project_myapp/records.dart";
import "package:project_myapp/task_page.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class TeacherProf extends StatefulWidget {
  const TeacherProf({super.key});

  @override
  State<TeacherProf> createState() => _TeacherProfState();
}

class _TeacherProfState extends State<TeacherProf> {
  List <Map<String,dynamic>> allTasks = [];
  String name = "";
  String role = "";
  String userID = "";
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    getUserData();
    getTask();
  }

  Future <void> getUserData() async{
    try{
      String uid = await FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot teachSnapshot = await FirebaseFirestore.instance
          .collection("teachers")
          .doc(uid)
          .get();

      if(teachSnapshot.exists){
        Map<String,dynamic> data = teachSnapshot.data() as Map<String,dynamic>;

        setState((){
          name = data["name"]?? "N/A";
          role = data["role"]?? "N/A";
          userID = uid;

        });
      }
    }
    catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error: $error"),
              backgroundColor:Colors.red[400]
          )
      );
    }
  }

  Future <void> getTask() async{
    setState(() {
      isLoading = true;
    });

    try{
      List <Map<String,dynamic>> tasks = [];

      QuerySnapshot teacherSnapshot = await FirebaseFirestore.instance
          .collection("teachers")
          .get();

      for(var teacherDoc in teacherSnapshot.docs){
        String teacherId = teacherDoc.id;

        QuerySnapshot taskSnapshot = await FirebaseFirestore.instance
            .collection("teachers")
            .doc(teacherId)
            .collection("tasks")
            .get();

        for(var taskDoc in taskSnapshot.docs){
          Map<String,dynamic> taskData = taskDoc.data() as Map<String,dynamic>;
          taskData["taskId"] = taskDoc.id;
          taskData["teacherId"] = teacherDoc.id;
          tasks.add(taskData);
        }
      }

      setState((){
        allTasks = tasks;
        isLoading = false;
      });
    }
    catch(error){
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error: $error"),
              backgroundColor:Colors.red[400]
          )
      );
    }
  }

  Future<void> _refreshData() async {
    await getUserData();
    await getTask();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data refreshed successfully"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        )
    );
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
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: _refreshData,
              tooltip: "Refresh",
            )
          ],
        ),
        body:SafeArea(
          child: Stack(
              children:[
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
                    left:10,
                    right:10,
                    top:80,
                    bottom:10,
                    child: isLoading
                        ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                        : ListView.builder(
                        itemCount:allTasks.length,
                        itemBuilder:(context,index){

                          Map<String,dynamic> task = allTasks[index];

                          String taskName = task["title"] ?? "No name";
                          String desc = task["description"] ?? "No description";
                          String teacher = task["created by"] ?? "No name";
                          String deadline = task["deadline"] ?? "No deadline";
                          String createdAt = (task["created at"] ?? "No time").toString();

                          String uid = FirebaseAuth.instance.currentUser!.uid;
                          List <String> name = teacher.split("_");

                          if(uid==name[1]){
                            return Padding(
                                padding:const EdgeInsets.all(10),
                                child:Card(
                                    shape:RoundedRectangleBorder(
                                        borderRadius:BorderRadius.all(
                                            Radius.circular(30)
                                        )
                                    ),
                                    elevation:5,
                                    child:Container(
                                        height:200,
                                        width:250,
                                        decoration:BoxDecoration(
                                            gradient:LinearGradient(
                                                colors:[Colors.white,Colors.blue],
                                                begin:Alignment.topLeft,
                                                end:Alignment.bottomRight
                                            ),
                                            borderRadius:BorderRadius.all(Radius.circular(30))
                                        ),
                                        child:Stack(
                                            children:[
                                              Row(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children:[
                                                    Text(taskName.toUpperCase(),
                                                        style:TextStyle(
                                                            fontSize:20,
                                                            fontWeight:FontWeight.bold,
                                                            color:Colors.black45
                                                        )
                                                    )
                                                  ]
                                              ),
                                              Positioned(
                                                  bottom:0,
                                                  child:Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                        children:[
                                                          SizedBox(
                                                            height: 30,
                                                            child: ElevatedButton.icon(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => Records(
                                                                      taskId: task["taskId"],
                                                                      teacherId: task["teacherId"],
                                                                      taskTitle: taskName,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              icon: Icon(Icons.list),
                                                              label: const Text("Records"),
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.white,
                                                                foregroundColor: Colors.blue,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width:120
                                                          ),
                                                          SizedBox(
                                                              height:30,
                                                              child:ElevatedButton.icon(
                                                                  onPressed:() async {
                                                                    try{
                                                                      await FirebaseFirestore.instance
                                                                          .collection("teachers")
                                                                          .doc(uid)
                                                                          .collection("tasks")
                                                                          .doc(task["taskId"])
                                                                          .delete();

                                                                      await getTask(); // Refresh the list

                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                          SnackBar(
                                                                              content:Text("Task deleted successfully"),
                                                                              backgroundColor:Colors.green
                                                                          )
                                                                      );
                                                                    }
                                                                    catch(e)
                                                                    {
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                          SnackBar(
                                                                              content:Text("Error: $e"),
                                                                              backgroundColor:Colors.red
                                                                          )
                                                                      );
                                                                    }
                                                                  },
                                                                  icon:Icon(
                                                                    Icons.delete,
                                                                  ),
                                                                  label:const Text("Delete"),
                                                                  style:ElevatedButton.styleFrom(
                                                                      backgroundColor:Colors.white,
                                                                      foregroundColor:Colors.red
                                                                  )
                                                              )
                                                          )
                                                        ]
                                                    ),
                                                  )
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
                                                            Text(name[0],
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
                                                  child:Text("Description: $desc",
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
                                            ]
                                        )
                                    )
                                )
                            );
                          }
                          else{
                            return Padding(
                                padding:const EdgeInsets.all(10),
                                child:Card(
                                    shape:RoundedRectangleBorder(
                                        borderRadius:BorderRadius.all(
                                            Radius.circular(30)
                                        )
                                    ),
                                    elevation:5,
                                    child:Container(
                                        height:200,
                                        width:250,
                                        decoration:BoxDecoration(
                                            gradient:LinearGradient(
                                                colors:[Colors.white,Colors.blue],
                                                begin:Alignment.topLeft,
                                                end:Alignment.bottomRight
                                            ),
                                            borderRadius:BorderRadius.all(Radius.circular(30))
                                        ),
                                        child:Stack(
                                            children:[
                                              Row(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children:[
                                                    Text(taskName.toUpperCase(),
                                                        style:TextStyle(
                                                            fontSize:20,
                                                            fontWeight:FontWeight.bold,
                                                            color:Colors.black45
                                                        )
                                                    )
                                                  ]
                                              ),
                                              Positioned(
                                                  bottom:0,
                                                  child:Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                        children:[
                                                          SizedBox(
                                                            height: 30,
                                                            child: ElevatedButton.icon(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => Records(
                                                                      taskId: task["taskId"],
                                                                      teacherId: task["teacherId"],
                                                                      taskTitle: taskName,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              icon: Icon(Icons.list),
                                                              label: const Text("Records"),
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.white,
                                                                foregroundColor: Colors.blue,
                                                              ),
                                                            ),
                                                          ),
                                                        ]
                                                    ),
                                                  )
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
                                                            Text(name[0],
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
                                                  child:Text("Description: $desc",
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
                                              )
                                            ]
                                        )
                                    )
                                )
                            );
                          }

                        }
                    )
                ),


                Positioned(// task button
                  bottom:30,
                  right:30,
                  child: SizedBox(
                    width:70,
                    height:70,
                    child: FloatingActionButton(
                        onPressed:(){
                          Navigator.push(context,MaterialPageRoute(builder:(context)=>TaskPage()));
                        },
                        splashColor:Colors.white54,
                        backgroundColor:Colors.blue,
                        foregroundColor:Colors.white,
                        elevation:10,
                        child:Icon(Icons.add,size:28)
                    ),
                  ),
                )
              ]
          ),
        ),
        backgroundColor:Colors.white
    );
  }
}

//