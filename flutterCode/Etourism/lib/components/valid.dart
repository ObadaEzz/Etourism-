// ignore_for_file: unnecessary_string_interpolations

import 'package:e_tourism/constant/message.dart';

validInput(String val, int min, int max, String s) {
  if (val.length > max) {
    return ("$messageinputMax $max");
  }
  if (val.isEmpty) {
    return ("$messageinputEmpty");
  }
  if (val.length < min) {
    return ("$messageinputMin $min");
  }
}
