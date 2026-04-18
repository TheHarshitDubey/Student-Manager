import 'package:flutter/material.dart';
import 'package:student_manager/database.dart';
import 'package:student_manager/student.dart';


class AddEditScreen extends StatefulWidget {
  final Student? student;

  const AddEditScreen({super.key, this.student});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final courseController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      nameController.text = widget.student!.name;
      ageController.text = widget.student!.age.toString();
      courseController.text = widget.student!.course;
    }
  }

  void saveStudent() async {
  final name = nameController.text.trim();
  final age = int.tryParse(ageController.text.trim()) ?? 0;
  final course = courseController.text.trim();

  

  if (name.isEmpty || course.isEmpty) {

    return;
  }

  if (widget.student == null) {
    int id = await DatabaseHelper.instance.insertStudent(
      Student(name: name, age: age, course: course),
    );
  
  } else {
    await DatabaseHelper.instance.updateStudent(
      Student(
        id: widget.student!.id,
        name: name,
        age: age,
        course: course,
      ),
    );
  }

  Navigator.pop(context, true); 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.student == null ? "Add Student" : "Edit Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              
              controller: nameController,
              decoration: const InputDecoration(
              
                labelText: "Name"),
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Age"),
            ),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(labelText: "Course"),
            ),
            const SizedBox(height:15 ),
            ElevatedButton(
              onPressed: saveStudent,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}