
import 'package:flutter/material.dart';
import 'package:lab3_mis/model/student_exam.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TableCalendar extends StatelessWidget {
  TableCalendar(this.exams);

  final List<StudentExam> exams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 1,
        dataSource: MeetingDataSource(getAppointments(this.exams)),
      )
    );
  }

}

List<Appointment> getAppointments(List<StudentExam> exams) {
  List<Appointment> meetings = <Appointment>[];
  for(var exam in exams) {
    final DateTime today = exam.term.toDate();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    meetings.add(Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: exam.subject,
        color: Colors.blue));
  }

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}