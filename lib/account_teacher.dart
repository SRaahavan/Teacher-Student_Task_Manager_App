import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:project_myapp/login_page.dart";

class TeacherProfApp extends StatefulWidget {
  const TeacherProfApp({super.key});

  @override
  State<TeacherProfApp> createState() => _TeacherProfAppState();
}

class _TeacherProfAppState extends State<TeacherProfApp> {

  //create FormState
  final _teacherprofilekey = GlobalKey<FormState>();

  //create controllers
  TextEditingController username = TextEditingController();
  TextEditingController subject = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();

  @override
  void dispose(){
    username.dispose();
    subject.dispose();
    phone.dispose();
    super.dispose();
  }

  bool passvisibility = true;
  bool isloading = false;


  //Signup & fetching UID from user authentication
  Future signUp() async {

    String mail = email.text.trim();
    String password = pass.text.trim();

    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: mail, password: password);
    String uid = userCredential.user!.uid;
    await addUserData(uid);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Registered Successfully"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>SignInApp()));
  }

  //add user data into uid document within "teachers" collection
  Future addUserData(String uid) async {
    await FirebaseFirestore.instance.collection("teachers").doc(uid).set({
      "role": "teacher",
      "name": username.text.trim(),
      "subject": subject.text.trim(),
      "phone": phone.text.trim(),
    });
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
              title: const Text("Teacher Account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  )
              ),
              centerTitle: true,
              backgroundColor: Colors.blue,
              iconTheme: IconThemeData(
                  color: Colors.white,
                  size: 30
              )
          ),
          body: SafeArea(
            child: Form(
              key: _teacherprofilekey,
              child: ListView(
                // physics:NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          // constraints:BoxConstraints(
                          //   minHeight:150 ,
                          // ),
                            height: 120,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/teacher.png"),
                                    fit: BoxFit.fitHeight
                                )
                            )
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                            validator: (username) {
                              if (username!.isEmpty) {
                                return "Username can't be empty";
                              }
                              return null;
                            },
                            controller: username,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.black)
                                ),
                                prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.black),
                                labelText: "Username",
                                labelStyle: TextStyle(
                                    color: Colors.black
                                ),
                                hintText: "Example: Jhon",
                                hintStyle: TextStyle(
                                    color: Colors.black45
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 2)
                                )
                            )
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                            validator: (subject) {
                              if (subject!.isEmpty) {
                                return "Subject can't be empty";
                              }
                              return null;
                            },
                            controller: subject,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.black,)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2
                                    )
                                ),
                                labelText: "Subject",
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                hintText: "Example: Maths",
                                hintStyle: TextStyle(
                                    color: Colors.black45
                                ),
                                prefixIcon: Icon(
                                    Icons.menu_book_outlined,
                                    color: Colors.black)
                            )
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                            validator: (phone) {
                              if (phone!.isEmpty) {
                                return "Phone number can't be empty";
                              }
                              return null;
                            },
                            controller: phone,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.black)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2)
                                ),
                                labelText: "Phone",
                                labelStyle: TextStyle(
                                    color: Colors.black
                                ),
                                hintText: "Example: 070*******",
                                hintStyle: TextStyle(
                                    color: Colors.black45
                                ),
                                prefixIcon: Icon(
                                    Icons.phone_android,
                                    color: Colors.black
                                )
                            )
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                            validator: (email) {
                              if (email!.isEmpty) {
                                return "E-mail can't be empty";
                              }
                              return null;
                            },
                            controller: email,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.black)
                                ),
                                labelText: "E-mail",
                                labelStyle: TextStyle(
                                    color: Colors.black
                                ),
                                hintText: "Example@gmail.com",
                                hintStyle: TextStyle(
                                    color: Colors.black45
                                ),
                                prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.blue,
                                        width: 2)
                                )
                            )
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                            validator: (password) {
                              if (password!.isEmpty) {
                                return "Password can't be empty";
                              }
                              return null;
                            },
                            controller: pass,
                            obscureText: passvisibility,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.black)
                                ),
                                labelText: "Password",
                                labelStyle: TextStyle(
                                    color: Colors.black
                                ),
                                hintText: "Enter Password",
                                hintStyle: TextStyle(
                                    color: Colors.black45
                                ),
                                prefixIcon: Icon(
                                    Icons.key,
                                    color: Colors.black),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passvisibility = !passvisibility;
                                      });
                                    },
                                    icon: passvisibility
                                        ?
                                    Icon(Icons.visibility, color: Colors.black)
                                        :
                                    Icon(Icons.visibility_off, color: Colors
                                        .black)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.blue,
                                        width: 2)
                                )
                            )
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                            validator: (confirmpass) {
                              if (confirmpass!.isEmpty) {
                                return "This field can't be empty";
                              }
                              else if (pass.text != confirmpass) {
                                return "Password isn't matched with the password you entered above";
                              }
                              return null;
                            },
                            controller: confirmpass,
                            obscureText: passvisibility,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.black)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2
                                    )
                                ),
                                labelText: "Confirm password",
                                labelStyle: TextStyle(
                                    color: Colors.black
                                ),
                                hintText: "Re-enter password",
                                hintStyle: TextStyle(
                                    color: Colors.black45
                                ),
                                prefixIcon: Icon(Icons.key),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passvisibility = !passvisibility;
                                      });
                                    },
                                    icon: passvisibility
                                        ?
                                    Icon(Icons.visibility, color: Colors.black)
                                        :
                                    Icon(Icons.visibility_off, color: Colors
                                        .black)
                                )
                            )
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 15.0, right: 10.0),
                        child: ElevatedButton(


                            onPressed: () async {

                              if (_teacherprofilekey.currentState!.validate()) {

                                try {

                                  await signUp();

                                }catch (error){

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: ${error.toString()}"),
                                      backgroundColor: Colors.red[400],
                                    ),
                                  );
                                }
                              }
                            },


                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white
                            ),
                            child: const Text("Sign up",
                                style: TextStyle(
                                    fontSize: 20
                                )
                            )
                        )
                    ),
                    Row(
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Divider(
                                      thickness: 1,
                                      indent: 10,
                                      endIndent: 10,
                                      color: Colors.black
                                  )
                              )
                          ),
                          const Text("or",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 17
                              )
                          ),
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Divider(
                                      color: Colors.black,
                                      thickness: 1,
                                      indent: 10,
                                      endIndent: 10
                                  )
                              )
                          )
                        ]
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (
                                    context) => SignInApp()));
                              },
                              child: const Text("Sign in",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 1,
                                      decorationColor: Colors.blue
                                  )
                              )
                          )
                        ]
                    )
                  ]
              ),
            ),
          ),
          backgroundColor: Colors.white
      );
    }
  }

  //