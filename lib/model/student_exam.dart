import 'package:cloud_firestore/cloud_firestore.dart';

class StudentExam {
  String subject;
  bool exam;
  Timestamp term;

  StudentExam({required this.subject, required this.exam, required this.term});

  factory StudentExam.fromJson(Map<String, dynamic> json) => StudentExam(
    subject: json["subject"],
    exam: json["exam"],
    term: json["term"]
  );

  Map<String, dynamic> toJson() => {
    "subject": subject,
    "exam": exam,
    "term": term,
  };
}