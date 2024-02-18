import 'package:cloud_firestore/cloud_firestore.dart';

String timeStampToDateTime(Timestamp value) {
  final DateTime tsdate = value.toDate();
  final DateTime newDate = DateTime(tsdate.year, tsdate.month, tsdate.day);
  return newDate.toString().split(" ")[0];
}
