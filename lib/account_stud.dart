import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:project_myapp/login_page.dart";

class StudProfApp extends StatefulWidget {
  const StudProfApp({super.key});


  @override
  State<StudProfApp> createState() => _StudProfAppState();
}

class _StudProfAppState extends State<StudProfApp> {

  //create FormState
  final _studprofkey = GlobalKey<FormState>();

  //creating controllers
  TextEditingController username = TextEditingController();
  TextEditingController studclass = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confpass = TextEditingController();

  bool visibility = true;
  bool isloading = false;

  @override
  void dispose(){
    username.dispose();
    studclass.dispose();
    phone.dispose();
    super.dispose();
  }


  //Signup & fetching UID from user authentication
  Future signUp() async{

    String mail = email.text.trim();
    String password = pass.text.trim();

    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email:mail,password:password);
    String uid = userCredential.user!.uid;
    await addUserData(uid);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Registered Successfully"),
        backgroundColor: Colors.green,
      ),
    );
  }

  //add user data into uid document within "students" collection
  Future addUserData(String uid) async{
    await FirebaseFirestore.instance.collection("students").doc(uid).set({
      "role":"student",
      "name":username.text.trim(),
      "class":studclass.text.trim(),
      "phone":phone.text.trim(),
      "created Date":DateTime.timestamp(),
      "created Time":DateTime.timestamp(),
    });
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SignInApp()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar:AppBar(
        title:const Text("Student Account",
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
        )
      ),
      body:Form(
        key:_studprofkey,
        child:ListView(
          children:[
            Padding(
              padding:const EdgeInsets.all(10),
              child:Container(
                height:120,
                decoration:BoxDecoration(
                  image:DecorationImage(
                    image:AssetImage("assets/images/student.png"),
                    fit:BoxFit.fitHeight
                  )
                )
              )
            ),
            Padding(
              padding:const EdgeInsets.all(10),
              child:TextFormField(
                controller:username,
                validator:(username){
                  if(username!.isEmpty){
                    return "Username can't be empty";
                  }
                  return null;
                },
                decoration:InputDecoration(
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.all(Radius.circular(30)),
                  ),
                  prefixIcon:Icon(Icons.person,color:Colors.black),
                  labelText:"Username",
                  labelStyle:TextStyle(
                    color:Colors.black
                  ),
                  hintText:"Example: Jhon",
                  hintStyle:TextStyle(
                    color:Colors.black45
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius:BorderRadius.all(Radius.circular(30)),
                    borderSide:BorderSide(color:Colors.blue,width:2)
                  )
                )
              )
            ),
            Padding(
              padding:const EdgeInsets.all(10),
              child:TextFormField(
                controller:studclass,
                validator:(studclass){
                  if(studclass!.isEmpty){
                    return "Class can't be empty";
                  }
                  return null;
                },
                decoration:InputDecoration(
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(30)
                  ),
                  prefixIcon:Icon(Icons.home,color:Colors.black),
                  labelText:"Class",
                  labelStyle:TextStyle(
                    color:Colors.black
                  ),
                  hintText:"Enter your class",
                  hintStyle:TextStyle(
                    color:Colors.black45
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius:BorderRadius.all(Radius.circular(30)),
                    borderSide:BorderSide(
                      color:Colors.blue,
                      width:2
                    )
                  )
                )
              )
            ),
            Padding(
              padding:const EdgeInsets.all(10),
              child:TextFormField(
                maxLength:10,
                keyboardType:TextInputType.number,
                decoration:InputDecoration(
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.all(Radius.circular(30)),
                  ),
                  prefixIcon:Icon(Icons.phone_android,color:Colors.black),
                  labelText:"Phone (Optional)",
                  labelStyle:TextStyle(
                    color:Colors.black
                  ),
                  hintText:"Example: 070*******",
                  hintStyle:TextStyle(
                    color:Colors.black45
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(30),
                    borderSide:BorderSide(
                      color:Colors.blue,
                      width:2
                    )
                  )
                )
              )
            ),
            Padding(
              padding:const EdgeInsets.all(10),
              child:TextFormField(
                controller:email,
                validator:(email){
                  if(email!.isEmpty){
                    return "Email can't be empty";
                  }
                  return null;
                },
                decoration:InputDecoration(
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(30)
                  ),
                  prefixIcon:Icon(Icons.mail,color:Colors.black),
                  labelText:"E-mail",
                  labelStyle:TextStyle(
                    color:Colors.black
                  ),
                  hintText:"Example@gmail.com",
                  hintStyle:TextStyle(
                    color:Colors.black45
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius:BorderRadius.all(Radius.circular(30)),
                    borderSide:BorderSide(color:Colors.blue,width:2)
                  )
                )
              )
            ),
            Padding(
              padding:const EdgeInsets.all(10),
              child:TextFormField(
                controller:pass,
                validator:(pass){
                  if(pass!.isEmpty){
                    return "Password can't be empty";
                  }
                  return null;
                },
                obscureText:visibility,
                decoration:InputDecoration(
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(30)
                  ),
                  prefixIcon:Icon(Icons.key,color:Colors.black),
                  labelText:"Password",
                  labelStyle:TextStyle(
                    color:Colors.black
                  ),
                  hintText:"Enter password",
                  hintStyle:TextStyle(
                    color:Colors.black45
                  ),
                  suffixIcon:IconButton(
                    onPressed:(){
                      setState((){
                        visibility = !visibility;
                      });
                    },
                    icon: visibility?Icon(Icons.visibility,color:Colors.black):Icon(Icons.visibility_off,color:Colors.black)
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderRadius:BorderRadius.circular(30),
                    borderSide:BorderSide(
                      color:Colors.blue,
                      width:2
                    )
                  )
                )
              )
            ),
            Padding(
              padding:const EdgeInsets.all(10),
              child:TextFormField(
                obscureText:visibility,
                controller:confpass,
                validator:(confpass){
                  if(confpass!.isEmpty){
                    return "This field can't be left empty";
                  }
                  else if(pass.text != confpass){
                    return "Password isn't matched with the password you entered above";
                  }
                  return null;
                },
                decoration:InputDecoration(
                  border:OutlineInputBorder(
                    borderRadius:BorderRadius.all(Radius.circular(30)),
                  ),
                  prefixIcon:Icon(Icons.key,color:Colors.black),
                  labelText:"Confirm password",
                  labelStyle:TextStyle(
                    color:Colors.black
                  ),
                  hintText:"Re-enter password",
                  hintStyle:TextStyle(
                    color:Colors.black45
                  ),
                  suffixIcon:IconButton(
                    onPressed:(){
                      setState((){
                        visibility = !visibility;
                      });
                    },
                    icon:visibility?Icon(Icons.visibility,color:Colors.black):Icon(Icons.visibility_off,color:Colors.black)
                  )
                )
              )
            ),
            Padding(
              padding:const EdgeInsets.fromLTRB(10,20,10,0),
              child:ElevatedButton(


                  onPressed: () async {
                    if (_studprofkey.currentState!.validate()) {
                      try {

                        await signUp();

                      }
                      catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: ${error.toString()}"),
                              backgroundColor: Colors.red[400],
                            ),
                          );
                      }
                    }
                  },


                style:ElevatedButton.styleFrom(
                  shape:RoundedRectangleBorder(
                    borderRadius:BorderRadius.all(Radius.circular(30)),
                  ),
                  backgroundColor:Colors.green,
                  foregroundColor:Colors.white,
                ),
                child:const Text("Sign up",
                  style:TextStyle(
                    fontSize:20,
                  )
                )
              )
            ),
            Row(
              children:[
                Expanded(
                  child: Divider(
                    thickness:1,
                    indent:10,
                    endIndent:10,
                    color:Colors.black
                  ),
                ),
                Padding(
                  padding:const EdgeInsets.fromLTRB(10,10,10,10),
                  child:const Text("or",
                    style:TextStyle(
                      fontSize:17,
                      color:Colors.black45
                    )
                  ),
                ),
                Expanded(
                  child:Divider(
                    thickness:1,
                    indent:10,
                    endIndent:10,
                    color:Colors.black
                  )
                )
              ]
            ),
            Padding(
              padding:const EdgeInsets.only(top:0),
              child:Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children:[
                  Text("Already have an account?"),
                  TextButton(
                    onPressed:(){
                      Navigator.push(context,MaterialPageRoute(builder:(context)=>const SignInApp()));
                    },
                    child:Text("Sign in",
                      style:TextStyle(
                        color:Colors.blue,
                        decoration:TextDecoration.underline,
                        decorationColor:Colors.blue,
                        decorationThickness:1
                      )
                    )
                  )
                ]
              )
            )
          ]
        )
      ),
      backgroundColor:Colors.white
    );
  }
}
//
