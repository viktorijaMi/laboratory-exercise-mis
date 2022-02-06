import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab3_mis/model/user.dart';
import 'package:lab3_mis/model/user_dto.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final AuthenticationService _instance = AuthenticationService._internal();

  factory AuthenticationService() {
    return _instance;
  }
  AuthenticationService._internal();
  static const USERS_COLLECTION = "users";

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> signIn(
      {required String email, required String password}) async {
    if (email == null || password == null) {
      throw Exception('Email and password are required');
    }
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<PersistedUser> getPersistedUser() async {
    var currentUser = await _firebaseAuth.currentUser;
    dynamic json = {};
    await _firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser?.uid)
        .get()
        .then((DocumentSnapshot doc) {
      json = doc.data() as Map;
    });
    return Future.value(PersistedUser.fromJson(json));
  }

  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<PersistedUser> getUser(String uid) async {
    dynamic json = {};
    await _firestore
        .collection(USERS_COLLECTION)
        .doc(uid)
        .get()
        .then((DocumentSnapshot doc) {
      json = doc.data() as Map;
    });

    json.putIfAbsent("uid", () => uid);

    return Future<PersistedUser>.value(PersistedUser.fromJson(json));
  }

  Future<UserCredential> createUserWithEmailAndPassword(UserDto userDto) async {
    if (userDto.email == null || userDto.password == null) {
      throw Exception('Email and password are required');
    }

    String displayName =
        (userDto.firstName ?? "") + " " + (userDto.lastName ?? "");

    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: userDto.email.toString(),
            password: userDto.password.toString())
        .catchError((error) => throw error);

    if (displayName.isNotEmpty) {
      userCredential.user?.updateDisplayName(displayName);
    }

    if (!userCredential.user!.emailVerified) {
      userCredential.user?.sendEmailVerification();
    }

    userDto.uuid = userCredential.user?.uid;
    await storeUser(userDto);

    return userCredential;
  }

  Future<PersistedUser> storeUser(UserDto userDto) async {
    PersistedUser toPersist = PersistedUser(
      uuid: userDto.uuid,
      index: userDto.index,
      firstName: userDto.firstName,
      lastName: userDto.lastName,
      email: userDto.email,
    );
    await _firestore
        .collection(USERS_COLLECTION)
        .doc(userDto.uuid)
        .set(toPersist.toJson());
    return toPersist;
  }
}
