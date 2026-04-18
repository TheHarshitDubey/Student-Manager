import 'package:flutter/material.dart';
import 'package:student_manager/add_Screen.dart';
import 'package:student_manager/database.dart';
import 'package:student_manager/student.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final data = await DatabaseHelper.instance.getStudents();
    setState(() {
      students = data;
    });
  }

  void deleteStudent(int id) async {
    await DatabaseHelper.instance.deleteStudent(id);
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: students.isEmpty
          ? const Center(child: Text("Add Student"))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(student.name),
                    subtitle:
                        Text("Age: ${student.age}, Course: ${student.course}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                 IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddEditScreen(student: student),
                              ),
                            );
                            fetchStudents();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteStudent(student.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditScreen(),),
    );

    if (result == true) {
      fetchStudents();
    }
  },
  child: const Icon(Icons.add),
),
    );
  }
}