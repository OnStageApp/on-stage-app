import 'package:email_validator/email_validator.dart';

mixin PhoneEmailValidator {
  int _phoneNumberCharacter(String phone) {
    final isUS = phone.contains('+1');
    final isRO = phone.contains('+40');
    final isIL = phone.contains('+972');

    if (isUS) {
      return 12;
    } else if (isRO) {
      return 12;
    } else if (isIL) {
      return 13;
    }

    return 0;
  }

  bool isEmailValid(String? email) {
    final isEmailValid = EmailValidator.validate(email ?? '');
    return isEmailValid;
  }

  bool isPhoneNumberValid(String? phone) {
    final isValid = (phone ?? '').length >= _phoneNumberCharacter(phone ?? '');

    return isValid;
  }
}
