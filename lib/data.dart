import 'package:dio/dio.dart';

class StudentData {
  final int id;
  final String firstName;
  final String lastName;
  final String course;
  final int score;
  final String createdAt;
  final String updateAt;

  //constructor
  StudentData(this.id, this.firstName, this.lastName, this.course,
      this.createdAt, this.updateAt, this.score);

  //Parse json to dart
  StudentData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        course = json['course'],
        score = json['score'],
        createdAt = json['created_at'],
        updateAt = json['updated_at'];
}

class HttpClient {
  //instance DIO OPTIONS
  static Dio instance =
      Dio(BaseOptions(baseUrl: 'http://expertdevelopers.ir/api/v1/'));
}

//---------------------------------------
//list  for return student data
Future<List<StudentData>> getStudents() async {
  final response = await HttpClient.instance.get('experts/student');
  print(response.data);
  //return
  final List<StudentData> students = [];
  if (response.data is List<dynamic>) {
    //translate json to dart foe each element
    for (var element in (response.data as List<dynamic>)) {
      students.add(StudentData.fromJson(element));
    }
  }
  print(students.toString());
  return students;
}

//--------------------------------------
//fun for save student field and send
Future<StudentData> saveStudent(
    String firstName, String lastName, String course, int score) async {
  final response = await HttpClient.instance.post('experts/student', data: {
    "first_name": firstName,
    "last_name": lastName,
    "course": course,
    "score": score,
  });
  //check response success
  if (response.statusCode == 200) {
    return StudentData.fromJson(response.data);
  } else {
    throw Exception();
  }
}
