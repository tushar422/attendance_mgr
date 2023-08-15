import 'package:email_validator/email_validator.dart';

String? validateEmail(String? email) {
  return EmailValidator.validate(email ?? "")
      ? null
      : "This email looks incorrect";
}

String? validatePassword(String? pass) {
  print('jisd');
  return (pass ?? "").length >= 6
      ? null
      : "Password must be of length greater than 6";
}

String? validateUsername(String? user) {
  return (user ?? "").length >= 3
      ? null
      : "Password must be of length greater than 3";
}
