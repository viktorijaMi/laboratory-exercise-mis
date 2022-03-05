import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lab3_mis/model/user.dart';
import 'package:lab3_mis/providers/global_providers.dart';
import 'package:lab3_mis/service/authentication_service.dart';
import 'package:lab3_mis/service/exams_service.dart';
import 'package:lab3_mis/model/student_exam.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:lab3_mis/ui/laboratory_form.dart';
import 'package:lab3_mis/ui/sign_in.dart';
import 'package:lab3_mis/ui/table_calendar.dart';

final List<String> subjects = [
  "Vestacka inteligencija",
  "Bazi na podatoci",
  "Operativni sistemi",
  "MIS",
  "Napredno programiranje",
  "Agentno bazirani sistemi",
  "Voved vo bioinformatika",
  "Obrabotka na slika",
  "Kalkulus 1",
  "Kalkulus 2",
  "Kalkulus 3",
  "Verojatnost",
  "Diskrenta matematika 1",
  "Diskretna matematika 2",
  "Veb bazirani sistemi",
  "Strukturno programiranje",
  "Objektno programiranje",
  "APS",
  "Mobilni platformi"
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthenticationService authenticationService = AuthenticationService();

  void showGestureDetector(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: OtherScreen(),
              behavior: HitTestBehavior.opaque);
        });
  }

  void pushToScreen(PersistedUser? user, BuildContext context) {
    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TableCalendar(user.exams!)),
      );
    }
  }

  Widget showSubjectDateWidget(PersistedUser? user, int index) {
    if (user != null && user.exams != null && user.exams.length != 0) {
      bool studentExamExists =
          user.exams.any((element) => element.subject == subjects[index]);
      if (studentExamExists != false) {
        StudentExam studentExam = user.exams
            .firstWhere((element) => element.subject == subjects[index]);
        if (studentExam.exam == true) {
          String labelText =
              "Exam Date: " + studentExam.term.toDate().toString();
          return Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(labelText),
                ElevatedButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => LaboratoryForm(
                        studentExam: studentExam))),
                    child: Text("Add laboratory"))
              ],
            ),
          );
        } else {
          String labelText =
              "Midterm Date: " + studentExam.term.toDate().toString();
          return Padding(
            padding: EdgeInsets.all(10),
            child: Text(labelText),
          );
        }
      } else {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "No dates chosen for this subject",
          ),
        );
      }
    } else {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "No dates chosen for this subject",
        ),
      );
    }
  }

  Widget showNotificationForEvent(PersistedUser? user) {
    if (user != null && user.exams
            .any((element) => element.term.compareTo(Timestamp.now()) == 0)) {
      return SnackBar(
        content: Text('You have an exam today'),
        duration: Duration(seconds: 2),
      );
    } else
      return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, child) {
      PersistedUser? user = ref.watch(persistedUserProvider)?.user;
      return Scaffold(
          appBar: AppBar(title: Text(widget.title), actions: [
            IconButton(
              icon: Icon(Icons.calendar_today_rounded),
              onPressed: () => pushToScreen(user, context),
            ),
            IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () => showGestureDetector(context),
            ),
            IconButton(
                onPressed: () => this
                    .authenticationService
                    .signOut()
                    .then((value) => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SignInPage()),
                        )),
                icon: Icon(Icons.door_back_door_rounded))
          ]),
          body: ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (contx, index) {
              return Card(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.cyan.shade200,
                          width: 3,
                        ),
                      ),
                      child: Text(
                        subjects[index],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan.shade900),
                      ),
                    ),
                    showSubjectDateWidget(user, index),
                    showNotificationForEvent(user),
                  ]));
            },
          ));
    });
  }
}

class OtherScreen extends StatefulWidget {
  const OtherScreen({Key? key}) : super(key: key);

  @override
  _OtherScreenState createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  final ExamsService _examsService = ExamsService();
  String selectedSubject = subjects[0];
  bool exam = false;
  DateTime date = new DateTime.now();

  String selectedExamType = "Exam";

  List<String> examsList = ["Exam", "Midterm"];

  pushToScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }

  void addDateTimeForSubjectExam() {
    _examsService.addExamTermsToUser(new StudentExam(
        subject: selectedSubject, exam: exam, term: Timestamp.fromDate(date)));
    pushToScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AlertDialog(
            title: Text(
              "Choose your date and time for the exam/midterm",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            content: Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    child: DropdownButton(
                      value: selectedSubject,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 34,
                      elevation: 20,
                      style: const TextStyle(color: Colors.blueGrey),
                      underline: Container(height: 4, color: Colors.blue),
                      onChanged: (String? newSubject) {
                        setState(() {
                          selectedSubject = newSubject!;
                        });
                      },
                      items: subjects.map<DropdownMenuItem<String>>((String e) {
                        return DropdownMenuItem<String>(
                            value: e, child: Text(e));
                      }).toList(),
                    )),
                Column(children: [
                  for (var examName in examsList)
                    ListTile(
                        title: Text(examName),
                        leading: Radio(
                            value: examName,
                            activeColor: Colors.deepPurple,
                            groupValue: selectedExamType,
                            onChanged: (String? value) {
                              setState(() {
                                exam = true;
                                selectedExamType = value!;
                              });
                            })),
                ]),
                ElevatedButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2022, 1, 22),
                          maxTime: DateTime(2022, 9, 30), onChanged: (date) {
                        setState(() {
                          date = date;
                        });
                      }, onConfirm: (date) {
                        setState(() {
                          date = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text("Pick the date and time")),
                ElevatedButton(
                    onPressed: () => addDateTimeForSubjectExam(),
                    child: Text("SAVE"))
              ],
            )));
  }
}
