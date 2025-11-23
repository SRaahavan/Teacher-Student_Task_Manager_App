// import "package:flutter/material.dart";
// import "package:cloud_firestore/cloud_firestore.dart";
// import "package:firebase_auth/firebase_auth.dart";
//
// class Check extends StatefulWidget {
//   const Check({super.key});
//
//   @override
//   State<Check> createState() => _StudProfState();
// }
//
// class _StudProfState extends State<Check> {
//   String name = "";
//   String role = "";
//   String userID = "";
//   List<Map<String, dynamic>> allTasks = [];
//   bool isLoadingTasks = true;
//
//   @override
//   void initState(){
//     super.initState();
//     getUserData();
//     fetchAllTasks();
//   }
//
//   Future <void> getUserData() async{
//     try{
//       String uid = await FirebaseAuth.instance.currentUser!.uid;
//
//       DocumentSnapshot studSnapshot = await FirebaseFirestore.instance
//           .collection("students")
//           .doc(uid)
//           .get();
//
//       if (studSnapshot.exists) {
//         Map<String, dynamic> data = studSnapshot.data() as Map<String, dynamic>;
//
//         setState(() {
//           name = data["name"] ?? "N/A";
//           role = data["role"] ?? "N/A";
//           userID = uid;
//         });
//       }
//     }
//     catch(e){
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text("Error: $e"),
//               backgroundColor:Colors.red[400]
//           )
//       );
//     }
//   }
//
//   Future<void> fetchAllTasks() async {
//     try {
//       setState(() {
//         isLoadingTasks = true;
//       });
//
//       List<Map<String, dynamic>> tasks = [];
//
//       // Get all teachers
//       QuerySnapshot teachersSnapshot = await FirebaseFirestore.instance
//           .collection("teachers")
//           .get();
//
//       // Loop through each teacher
//       for (var teacherDoc in teachersSnapshot.docs) {
//         String teacherId = teacherDoc.id;
//
//         // Get all tasks from this teacher's tasks subcollection
//         QuerySnapshot tasksSnapshot = await FirebaseFirestore.instance
//             .collection("teachers")
//             .doc(teacherId)
//             .collection("tasks")
//             .orderBy("created at", descending: true)
//             .get();
//
//         // Add each task to the list
//         for (var taskDoc in tasksSnapshot.docs) {
//           Map<String, dynamic> taskData = taskDoc.data() as Map<String, dynamic>;
//           taskData['taskId'] = taskDoc.id; // Store document ID
//           tasks.add(taskData);
//         }
//       }
//
//       // Sort all tasks by creation date (newest first)
//       tasks.sort((a, b) {
//         Timestamp timeA = a['created at'] as Timestamp;
//         Timestamp timeB = b['created at'] as Timestamp;
//         return timeB.compareTo(timeA);
//       });
//
//       setState(() {
//         allTasks = tasks;
//         isLoadingTasks = false;
//       });
//
//     } catch (e) {
//       setState(() {
//         isLoadingTasks = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error fetching tasks: $e"),
//           backgroundColor: Colors.red[400],
//         ),
//       );
//     }
//   }
//
//   String formatTimestamp(Timestamp timestamp) {
//     DateTime dateTime = timestamp.toDate();
//     return "${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:AppBar(
//         title:Text(name.toUpperCase(),
//             style:TextStyle(
//                 color:Colors.white,
//                 fontSize:24,
//                 fontWeight:FontWeight.bold
//             )),
//         centerTitle:true,
//         backgroundColor:Colors.blue,
//         iconTheme:IconThemeData(
//             color:Colors.white,
//             size:30
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: fetchAllTasks,
//             tooltip: "Refresh Tasks",
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           // User Info Section
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(15),
//             decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 border: Border(
//                     bottom: BorderSide(color: Colors.blue[200]!, width: 2)
//                 )
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                     "User role: $role",
//                     style: TextStyle(
//                         color: Colors.blue[800],
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold
//                     )
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                     "UID: $userID",
//                     style: TextStyle(
//                         color: Colors.blue[800],
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500
//                     )
//                 ),
//               ],
//             ),
//           ),
//
//           // Tasks Section Header
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Row(
//               children: [
//                 Icon(Icons.assignment, color: Colors.blue, size: 28),
//                 SizedBox(width: 10),
//                 Text(
//                   "All Tasks",
//                   style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue[900]
//                   ),
//                 ),
//                 Spacer(),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(20)
//                   ),
//                   child: Text(
//                     "${allTasks.length}",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//
//           // Tasks List
//           Expanded(
//             child: isLoadingTasks
//                 ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 15),
//                   Text(
//                     "Loading tasks...",
//                     style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 16
//                     ),
//                   )
//                 ],
//               ),
//             )
//                 : allTasks.isEmpty
//                 ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.inbox_outlined,
//                     size: 80,
//                     color: Colors.grey[400],
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     "No tasks available",
//                     style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     "Tasks will appear here when teachers create them",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[500],
//                     ),
//                     textAlign: TextAlign.center,
//                   )
//                 ],
//               ),
//             )
//                 : RefreshIndicator(
//               onRefresh: fetchAllTasks,
//               child: ListView.builder(
//                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 itemCount: allTasks.length,
//                 itemBuilder: (context, index) {
//                   Map<String, dynamic> task = allTasks[index];
//
//                   String title = task['title'] ?? 'No Title';
//                   String description = task['description'] ?? 'No Description';
//                   String deadline = task['deadline'] ?? 'No Deadline';
//                   String createdBy = task['created by'] ?? 'Unknown';
//
//                   // Extract teacher name from "Name_UID" format
//                   String teacherName = createdBy.split('_')[0];
//
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         gradient: LinearGradient(
//                           colors: [Colors.white, Colors.blue[50]!],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Title
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     title,
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.blue[900],
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 10,
//                                       vertical: 5
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.green[100],
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.person,
//                                         size: 16,
//                                         color: Colors.green[800],
//                                       ),
//                                       SizedBox(width: 5),
//                                       Text(
//                                         teacherName,
//                                         style: TextStyle(
//                                           color: Colors.green[800],
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             SizedBox(height: 12),
//
//                             // Description
//                             Container(
//                               padding: EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[100],
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Icon(
//                                     Icons.description_outlined,
//                                     color: Colors.grey[700],
//                                     size: 20,
//                                   ),
//                                   SizedBox(width: 10),
//                                   Expanded(
//                                     child: Text(
//                                       description,
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         color: Colors.grey[800],
//                                         height: 1.4,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                             SizedBox(height: 12),
//
//                             // Deadline
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.calendar_today,
//                                   color: Colors.red[700],
//                                   size: 18,
//                                 ),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   "Deadline: ",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                                 Text(
//                                   deadline,
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.red[700],
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             SizedBox(height: 8),
//
//                             // Created At
//                             if (task['created at'] != null)
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.access_time,
//                                     color: Colors.grey[600],
//                                     size: 16,
//                                   ),
//                                   SizedBox(width: 8),
//                                   Text(
//                                     "Posted: ${formatTimestamp(task['created at'])}",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey[600],
//                                       fontStyle: FontStyle.italic,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//     );
//   }
// }


import "package:flutter/material.dart";

class Check extends StatelessWidget{
   const Check({super.key});

   @override
  Widget build(BuildContext context){
     return Scaffold(
       appBar:AppBar(
         backgroundColor:Colors.blue,
         title:const Text("Tasks",
          style:TextStyle(
            color:Colors.white,
            fontSize:24,
            fontWeight:FontWeight.bold
          )
         ),
         centerTitle:true,
         actions:[
           IconButton(
             onPressed:(){

             },
             icon:Icon(Icons.menu)
           )
         ],
         iconTheme:IconThemeData(
           color:Colors.white,
           size:28
         )
       ),
       body:Center(
         child:Column(
           mainAxisAlignment:MainAxisAlignment.start,
           children:[
             Padding(
               padding:const EdgeInsets.all(10),
               child:Container(
                 height:220,
                 width:400,
                 decoration:BoxDecoration(
                   gradient:LinearGradient(
                     colors:[Colors.blue,Colors.white],
                     begin:Alignment.topLeft,
                     end:Alignment.bottomRight
                   ),
                   borderRadius:BorderRadius.all(
                     Radius.circular(30)
                   ),
                   boxShadow:[
                     BoxShadow(
                       spreadRadius:2,
                       blurRadius:10,
                       color:Colors.black45
                     )
                   ]
                 ),
                 child:Stack(
                   children:[
                     Container(
                         padding:const EdgeInsets.all(20),
                         child:const Text("Title",
                             style:TextStyle(
                                 color:Colors.white,
                                 fontSize:24
                             )
                         )
                     ),
                     Positioned(
                         right:20,
                         top:10,
                         child:Container(
                           height:32,
                             padding:const EdgeInsets.all(7),
                             decoration:BoxDecoration(
                               color:Colors.green[100],
                               borderRadius: BorderRadius.all(Radius.circular(10))
                             ),
                             child:const Text("Raahavan",
                                 style:TextStyle(
                                     color:Colors.black87,
                                     fontWeight:FontWeight.w500,
                                     fontSize:14,
                                 )
                             )
                         )
                     ),
                     Positioned(
                       top:50,
                       child:Container(
                           padding:const EdgeInsets.all(20),
                           child:const Text("Description:",
                               style:TextStyle(
                                   color:Colors.white,
                                   fontSize:16
                               )
                           )
                       )
                     ),
                     Positioned(
                         top:80,
                         child:Container(
                             padding:const EdgeInsets.all(20),
                             child:const Text("Posted at:",
                                 style:TextStyle(
                                     color:Colors.white,
                                     fontSize:16
                                 )
                             )
                         )
                     ),
                     Positioned(
                         top:110,
                         child:Container(
                             padding:const EdgeInsets.all(20),
                             child:const Text("Deadline:",
                                 style:TextStyle(
                                     color:Colors.white,
                                     fontSize:16
                                 )
                             )
                         )
                     )
                   ]
                 ),
               )
             )
           ]
         )
       )
     );
   }
}
//