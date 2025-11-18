import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:project_myapp/role_select.dart";
import "package:project_myapp/profile_stud.dart";
import "package:project_myapp/profile_teacher.dart";

class SignInApp extends StatefulWidget {
  const SignInApp({super.key});

  @override
  State<SignInApp> createState() => _SignInAppState();
}

class _SignInAppState extends State<SignInApp> {

  //Form State
  final _signInFormKey = GlobalKey<FormState>();

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool textVisible = true;
  String role = "";



  //Firebase Sign in authentication
  Future<void> login() async{
    String email = username.text.trim();
    String pass = password.text.trim();
    await FirebaseAuth.instance.signInWithEmailAndPassword(email:email,password:pass);
  }


  //get user role from firestore
  Future<void> getUserRole() async {

    //get UID
    final uid = FirebaseAuth.instance.currentUser!.uid;

    //get user role from "teachers" collection
    try {
      DocumentSnapshot teacherSnapshot = await FirebaseFirestore.instance
          .collection("teachers")
          .doc(uid)
          .get();

      if (teacherSnapshot.exists) {
        setState(() {
          role = (teacherSnapshot.data() as Map<String, dynamic>)["role"].toString();
        });
        print("User role: $role");
      }

      //get user role from "students" collection
      else {
        DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
            .collection("students")
            .doc(uid)
            .get();

        if (studentSnapshot.exists) {
          setState(() {
            role = (studentSnapshot.data() as Map<String, dynamic>)["role"].toString();
          });
          print("User role: $role");
        }
      }

      //Navigate according to role
      if(role=="teacher"){
        Navigator.push(context,MaterialPageRoute(builder:(context)=>TeacherProf()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:const Text("Successfully login as Teacher"),
            backgroundColor:Colors.green,
            elevation:10,
            shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
            showCloseIcon:true
          )
        );
      }
      else if(role=="student"){
        Navigator.push(context,MaterialPageRoute(builder:(context)=>StudProf()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:const Text("Successfully login as Student"),
            backgroundColor:Colors.green,
            elevation:10,
            shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
            showCloseIcon:true
          )
        );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:const Text("User not found"),
              backgroundColor:Colors.red[400],
              elevation:10,
              shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20))
            )
        );
      }

    } catch (error) {
      print("Error fetching user data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $error"),
            backgroundColor:Colors.red[400],
            showCloseIcon:true
          )
      );
    }
  }

  Future<void> clear() async{
    username.clear();
    password.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading:false,
        backgroundColor:Colors.blue,
        title:const Text("MyApp",
          style:TextStyle(
            color:Colors.white,
            fontSize:24,
            fontWeight:FontWeight.w600
          )
        ),
        centerTitle:true,
      ),
      body:Form(
        key:_signInFormKey,
        child: Center(
          child:ListView(
            children:[
              Container(
                height:350,
                width:double.infinity,
                decoration:BoxDecoration(
                  image:DecorationImage(
                    image:AssetImage("assets/images/welcome.png"),
                    fit:BoxFit.fill
                  )
                )
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10,50,10,0),
                child:TextFormField(
                  validator:(username){
                    if(username!.isEmpty){
                      return "Username can't be empty. Enter your Email address.";
                    }
                    return null;
                  },
                  controller:username,
                  decoration:InputDecoration(
                    prefixIcon:Icon(
                      Icons.person_rounded,
                      color:Colors.black
                    ),
                    border:OutlineInputBorder(
                      borderRadius:BorderRadius.all(Radius.circular(30)),
                      borderSide:const BorderSide(color:Colors.black)
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderRadius:BorderRadius.all(Radius.circular(30)),
                      borderSide:BorderSide(
                        color:Colors.blue,
                        width:2
                      ),
                    ),
                    labelText:("E-mail"),
                    labelStyle:TextStyle(
                      color:Colors.black
                    ),
                    hintText:("Example@gmail.com"),
                    hintStyle:TextStyle(
                      color:Colors.black45
                    )
                  )
                )
              ),
              Padding(
                padding:const EdgeInsets.fromLTRB(10,25,10,0),
                child:TextFormField(
                  validator:(password){
                    if(password!.isEmpty){
                      return "Password can't be empty. Enter your password";
                    }
                    return null;
                },
                  controller:password,
                  obscureText:textVisible,
                  decoration:InputDecoration(
                    prefixIcon:Icon(
                      Icons.key,
                      color:Colors.black
                    ),
                    suffixIcon:IconButton(
                      onPressed:(){
                        setState((){
                          textVisible = !textVisible;
                        });
                      },
                      icon: textVisible ? Icon(
                        Icons.visibility,
                        color:Colors.black
                      ): Icon(
                        Icons.visibility_off,
                        color:Colors.black
                      )
                    ),
                    border:OutlineInputBorder(
                      borderRadius:BorderRadius.all(Radius.circular(30)),
                      borderSide:BorderSide(color:Colors.black)
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderRadius:BorderRadius.all(Radius.circular(30)),
                      borderSide:BorderSide(
                        color:Colors.blue,
                        width:2
                      )
                    ),
                    labelText:("Password"),
                    labelStyle:TextStyle(
                      color:Colors.black
                    ),
                    hintText:("Password"),
                    hintStyle:TextStyle(
                      color:Colors.black45
                    )
                  )
                )
              ),
              Row(
                mainAxisAlignment:MainAxisAlignment.end,
                children:[
                  Padding(
                    padding:const EdgeInsets.fromLTRB(0,0,5,0),
                    child:TextButton(
                        onPressed:(){

                        },
                        child:Text("Forgot password?",
                          style:TextStyle(
                              decoration:TextDecoration.underline,
                              decorationColor:Colors.blue,
                              decorationThickness:1,
                              color:Colors.blueAccent
                          )
                        )
                    ),
                  )
                ]
                  ),
              SizedBox(height:10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    minimumSize:Size(100,45),
                    shadowColor:Colors.black,
                    backgroundColor:Colors.blue,
                    foregroundColor:Colors.white
                  ),

                  onPressed:() async{
                    if(_signInFormKey.currentState!.validate()){

                      try{

                        await login();
                          print("login successful");

                        await getUserRole();
                          print("Role fetched: $role");

                        await clear();

                      }
                      catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $e"),
                            backgroundColor:Colors.red[400],
                            elevation:10,
                            shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20)),
                            showCloseIcon:true
                          )
                        );
                      }
                    }
                  },

                  child:const Text("Log in",
                    style:TextStyle(
                      fontSize:17,
                      fontWeight:FontWeight.w800
                    )
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                            thickness: 1,
                            indent:10,
                            endIndent:10,
                            color: Colors.black,
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("or",
                          style:TextStyle(
                            color:Colors.black45,
                            fontSize:17
                          )
                        ),
                      ),
                      Expanded(
                          child: Divider(
                            thickness: 1,
                            indent:10,
                            endIndent:10,
                            color: Colors.black,
                          )
                      ),
                    ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    minimumSize:Size(350,50),
                    backgroundColor:Colors.green[600],
                    foregroundColor:Colors.white
                  ),
                  onPressed:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const TeacherRoleApp() ));
                  },
                  child:const Text("Create account",
                    style:TextStyle(
                      fontSize:20,
                      fontWeight:FontWeight.bold
                    )
                  )
                ),
              )
            ]
          )
        ),
      ),
      backgroundColor:Colors.white
    );
  }
}