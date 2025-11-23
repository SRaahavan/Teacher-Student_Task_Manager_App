import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String createdBy ="";
  // String createdTime = DateTime.timestamp().toString();

  final _taskKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController deadline = TextEditingController();

  @override
  void initState(){
    super.initState();
    getTask();
  }

  Future <void> getTask() async{
    try{
      String uid = await FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot teacherSnapshot = await FirebaseFirestore.instance
          .collection("teachers")
          .doc(uid)
          .get();

      if (teacherSnapshot.exists) {
        Map<String, dynamic> data = teacherSnapshot.data() as Map<String,dynamic>;

        setState(() {
          createdBy = data["name"] ?? "N/A";
        });
      }
    }
    catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:Text("Error: $error")
        )
      );
    }
  }

  Future <void> addTask() async{
    try{
      String uid = await FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection("teachers")
          .doc(uid)
          .collection("tasks")
          .doc()
          .set({
        "title": title.text.trim(),
        "description": description.text.trim(),
        "deadline": deadline.text.trim(),
        "created by": "${createdBy}_$uid",
        "created at": DateTime.now()
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:const Text("Task added successfully"),
          backgroundColor:Colors.green,
          showCloseIcon:true,
        )
      );
    }
    catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:Text("Error: $error"),
          backgroundColor:Colors.red[400],
        )
      );
    }
  }

  Future <void> clear() async{
    title.clear();
    description.clear();
    deadline.clear();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text("Create Task",
        style:TextStyle(
          color:Colors.white,
          fontSize:24,
          fontWeight:FontWeight.bold
        )),
        centerTitle:true,
        backgroundColor:Colors.blue,
        iconTheme:IconThemeData(
          size:30,
          color:Colors.white
        )
      ),
      body:Form(
        key:_taskKey,
        child: SafeArea(
          child:Padding(
            padding: const EdgeInsets.only(top:20.0,left:10,right:10),
            child: ListView(
              children:[

                Padding(//title
                  padding:const EdgeInsets.only(top:20,bottom:20),
                  child:TextFormField(
                      validator:(title){
                        if(title!.isEmpty){
                          return "Title can't be empty";
                        }
                        return null;
                      },
                      controller:title,
                      decoration:InputDecoration(
                        labelText:"Title",
                        labelStyle:TextStyle(
                          color:Colors.black,
                          fontSize:20,
                          fontWeight:FontWeight.w400
                        ),
                        hintText:"Enter title for the task",
                        hintStyle:TextStyle(
                          color:Colors.black45,
                          fontStyle:FontStyle.italic
                        ),
                        border:OutlineInputBorder(
                          borderRadius:BorderRadius.circular(15),
                        ),
                          focusedBorder:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(15),
                              borderSide:BorderSide(
                                  color:Colors.blue,
                                  width:2
                              )
                          )
                      )
                  )
                ),

                Padding(//description
                    padding:const EdgeInsets.only(top:10,bottom:20),
                    child:TextFormField(
                        validator:(description){
                          if(description!.isEmpty){
                            return "Title can't be empty";
                          }
                          return null;
                        },
                        controller:description,
                      maxLines:4,
                        decoration:InputDecoration(
                          labelText:"Description",
                          labelStyle:TextStyle(
                              color:Colors.black,
                              fontSize:20,
                              fontWeight:FontWeight.w400
                          ),
                          hintText:"Enter description for the task",
                          hintStyle:TextStyle(
                              color:Colors.black45,
                              fontStyle:FontStyle.italic
                          ),
                          border:OutlineInputBorder(
                            borderRadius:BorderRadius.circular(15),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderRadius:BorderRadius.circular(15),
                            borderSide:BorderSide(
                              color:Colors.blue,
                              width:2
                            )
                          )
                        )
                    )
                ),

                Padding(//deadline
                    padding:const EdgeInsets.only(top:10,bottom:20),
                    child:TextFormField(
                        validator:(deadline){
                          if(deadline!.isEmpty){
                            return "Title can't be empty";
                          }
                          return null;
                        },
                        controller:deadline,
                        decoration:InputDecoration(
                          labelText:"Deadline",
                          labelStyle:TextStyle(
                              color:Colors.black,
                              fontSize:20,
                              fontWeight:FontWeight.w400
                          ),
                          hintText:"Enter deadline for the task",
                          hintStyle:TextStyle(
                              color:Colors.black45,
                              fontStyle:FontStyle.italic
                          ),
                          border:OutlineInputBorder(
                            borderRadius:BorderRadius.circular(15),
                          ),
                            focusedBorder:OutlineInputBorder(
                                borderRadius:BorderRadius.circular(15),
                                borderSide:BorderSide(
                                    color:Colors.blue,
                                    width:2
                                )
                            )
                        )
                    )
                ),

                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [

                    Padding(//cancel
                        padding:const EdgeInsets.all(20),
                        child:SizedBox(
                          height:50,
                          width:120,

                            child:ElevatedButton(
                                onPressed:(){
                                  title.clear();
                                  description.clear();
                                  deadline.clear();
                                },
                                style:ElevatedButton.styleFrom(
                                    foregroundColor:Colors.white,
                                    backgroundColor:Colors.red
                                ) ,
                                child:const Text("Clear",
                                    style:TextStyle(
                                        fontSize:18
                                    ))
                            )
                        )
                    ),

                    Padding(//add task
                      padding:const EdgeInsets.all(20),
                      child:SizedBox(
                        height:50,
                        width:120,

                        child:ElevatedButton(
                          onPressed:() async{
                            if(_taskKey.currentState!.validate()){
                              try{
                                // await getTask();
                                await addTask();
                                await clear();
                              }
                              catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:Text("Error: $e"),
                                    backgroundColor:Colors.red[400],
                                  )
                                );
                              }
                            }
                          },
                          style:ElevatedButton.styleFrom(
                            foregroundColor:Colors.white,
                            backgroundColor:Colors.green
                          ) ,
                          child:const Text("Add task",
                            style:TextStyle(
                              fontSize:18
                            ))
                        )
                      )
                    ),
                  ],
                )
              ]
            ),
          )
        ),
      )
    );
  }
}


//