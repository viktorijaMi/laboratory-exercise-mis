import 'package:lab3_mis/model/student_exam.dart';

class PersistedUser {
  String? uuid;
  String? index;
  String? firstName;
  String? lastName;
  String? email;
  List<StudentExam> exams;

  PersistedUser(
      {required this.uuid,
      this.index,
      this.firstName,
      this.lastName,
      this.email,
      this.exams = const []});

  factory PersistedUser.fromJson(dynamic json) {
    return PersistedUser(
        uuid: json['uuid'] as String,
        index: json['index'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
        exams: (json['exams'])
            .map<StudentExam>((e) => StudentExam.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'index': index,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'exams': exams?.map((exam) => exam.toJson()).toList()
    };
  }
}
