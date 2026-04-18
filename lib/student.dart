class Student {
  int? id;
  String name;
  int age;
  String course;

  Student({
    this.id,
    required this.name,
    required this.age,
    required this.course,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'course': course,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      course: map['course'],
    );
  }
}