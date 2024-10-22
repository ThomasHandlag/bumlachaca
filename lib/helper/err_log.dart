// a class for extracting error code and return message from localize context

import 'package:flutter/material.dart';

String fromErrorCode(String? errCode, BuildContext context) {
  switch (errCode) {
    case "23505":
      return "This email is already in use";
    default:
      return "Unknown error";
  }
}
