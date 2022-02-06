import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lab3_mis/model/user.dart';
import 'package:lab3_mis/providers/global_providers.dart';
import 'package:lab3_mis/service/authentication_service.dart';
import 'package:lab3_mis/service/exams_service.dart';
import 'package:lab3_mis/ui/first_page.dart';
import 'package:lab3_mis/model/student_exam.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:lab3_mis/ui/home_page.dart';
import 'package:lab3_mis/ui/register.dart';
import 'package:lab3_mis/ui/sign_in.dart';
import 'package:lab3_mis/ui/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lab3_mis/ui/wrapper.dart';
import 'package:provider/provider.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        User? user = snapshot.data;
        ref.watch(userProvider)!.setUser(user);
      }
      return MaterialApp(
        title: 'Student organizer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/wrapper': (context) => const Wrapper(),
          '/authenticate': (context) => FirstPage(),
          '/login': (context) => SignInPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => const MyHomePage(title: "Student organizer app"),
        },
        home: Wrapper(),
      );
    },
    );
  }
}
