abstract class StringValidator {
  bool isEmpty(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isEmpty(String value) {
    return !value.isNotEmpty;
  }
}

abstract class EmailValidator extends StringValidator {
  bool isValidEmail(String value);
}

class EmailStringValidator implements EmailValidator {
  @override
  bool isEmpty(String value) {
    return !value.isNotEmpty;
  }

  @override
  bool isValidEmail(String value) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
  }
}

mixin EmailAndPasswordValidator {
  final EmailStringValidator emailValidator = EmailStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
}
