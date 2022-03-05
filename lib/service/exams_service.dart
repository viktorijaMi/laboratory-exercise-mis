import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab3_mis/model/laboratory.dart';
import 'package:lab3_mis/model/student_exam.dart';
import 'package:lab3_mis/model/user.dart';
import 'package:lab3_mis/service/authentication_service.dart';

class ExamsService {
  final AuthenticationService _authenticationService = AuthenticationService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const USERS_COLLECTION = "users";


  Future<PersistedUser?> addExamTermsToUser(StudentExam studentExam) async{
    var persistedUser = await this._authenticationService.getPersistedUser();
    if (persistedUser != null) {

        persistedUser.exams!.add(studentExam);

        await _firestore
            .collection(USERS_COLLECTION)
            .doc(persistedUser.uuid)
            .set(persistedUser.toJson());

        return persistedUser;
    } else {
      return null;
    }
  }

  Future<PersistedUser?> addLaboratoryToExam(Laboratory laboratory, StudentExam exam) async{
    var persistedUser = await this._authenticationService.getPersistedUser();
    if (persistedUser != null) {

      var studentExams = persistedUser.exams.where((element) => element.subject != exam.subject).toList();

      exam.laboratory = laboratory;

      studentExams.add(exam);

      persistedUser.exams = studentExams;

      await _firestore
          .collection(USERS_COLLECTION)
          .doc(persistedUser.uuid)
          .set(persistedUser.toJson());

      return persistedUser;
    } else {
      return null;
    }
  }

}