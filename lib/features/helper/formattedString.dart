import 'package:intl/intl.dart';

String getFormattedString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  // Format the DateTime object
  String formattedTime = DateFormat('hh:mm a').format(dateTime);
  return formattedTime;
}


String getFormattedString2( int totaltime) {
  int hours = totaltime ~/ 60;
  int minutes = totaltime % 60;

// Format the duration as "1 h 20 min"
  String formattedDuration = '$hours h $minutes min';
  return formattedDuration;
}
String getFormattedString3(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  // Format the DateTime object
  String formattedTime = DateFormat('EEE, dd MMM').format(dateTime);
  print(dateString);
  print(formattedTime);
  return formattedTime;
}
String getFormattedString4(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  // Format the DateTime object
  String formattedTime = DateFormat('yyyy/MM/dd').format(dateTime);
  print('dateString-->$dateString');
  print('formattedTime-->$formattedTime');
  return formattedTime;
}
String getFormattedString5(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  // Format the DateTime object
  String formattedTime = DateFormat('MMM dd, yyyy').format(dateTime);
  print('dateString-->$dateString');
  print('formattedTime-->$formattedTime');
  return formattedTime;
}
String getFormattedString6(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);

  // Format the DateTime object
  String formattedTime = DateFormat('MMM d, yyyy, HH:mm').format(dateTime);
  print('dateString-->$dateString');
  print('formattedTime-->$formattedTime');
  return formattedTime;
}