import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class Records extends StatefulWidget {
  final String taskId;
  final String teacherId;
  final String taskTitle;

  const Records({
    super.key,
    required this.taskId,
    required this.teacherId,
    required this.taskTitle,
  });

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  List<Map<String, dynamic>> studentRecords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getRecords();
  }

  Future<void> getRecords() async {
    try {
      DocumentSnapshot taskDoc = await FirebaseFirestore.instance
          .collection("teachers")
          .doc(widget.teacherId)
          .collection("tasks")
          .doc(widget.taskId)
          .get();

      if (taskDoc.exists) {
        Map<String, dynamic> data = taskDoc.data() as Map<String, dynamic>;
        List<dynamic> records = data["records"] ?? [];

        setState(() {
          studentRecords = records
              .map((record) => record as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Records - ${widget.taskTitle}",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white, size: 30),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      )
          : studentRecords.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 20),
            Text(
              "No students have completed this task yet",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Total Completed: ${studentRecords.length}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: studentRecords.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> record = studentRecords[index];

                  String studentName =
                      record["student name"] ?? "Unknown";
                  String studentClass = record["class"] ?? "N/A";
                  String completedAt =
                      record["completed at"] ?? "N/A";
                  String studentUid = record["student uid"] ?? "N/A";

                  // Format the date/time
                  String formattedDate = completedAt;
                  try {
                    DateTime dateTime = DateTime.parse(completedAt);
                    formattedDate =
                    "${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
                  } catch (e) {
                    // Keep original if parsing fails
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.blue[50]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 25,
                          child: Text(
                            studentName[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          studentName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.class_,
                                    size: 16, color: Colors.blue),
                                SizedBox(width: 5),
                                Text(
                                  "Class: $studentClass",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 16, color: Colors.green),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}