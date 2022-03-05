import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab3_mis/model/laboratory.dart';
import 'package:lab3_mis/model/student_exam.dart';
import 'package:lab3_mis/service/authentication_service.dart';
import 'package:lab3_mis/service/exams_service.dart';

class LaboratoriesService {
  final AuthenticationService _authenticationService = AuthenticationService();
  final ExamsService _examsService = ExamsService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const LABORATORIES_COLLECTION = "LABORATORIES_COLLECTION";

  Future<Laboratory?> addLaboratory(String laboratoryName,LatLng position, StudentExam exam) async{
    var persistedUser = await this._authenticationService.getPersistedUser();
    if (persistedUser != null) {

      Laboratory laboratory = new Laboratory(name: laboratoryName, location: new GeoPoint(position.latitude, position.longitude));
      await _firestore
          .collection(LABORATORIES_COLLECTION)
          .doc(laboratory.name)
          .set(laboratory.toJson());

      await _examsService.addLaboratoryToExam(laboratory, exam);
      return laboratory;
    } else {
      return null;
    }
  }

}