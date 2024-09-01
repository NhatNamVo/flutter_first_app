import 'package:my_app/app/sign-_n/vaildate.dart';

enum EmailSignInFormType { SignIn, Register }

class EmailSignInModel with EmailAndPasswordValidator {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.SignIn,
    this.isLoading = false,
  });

  String get primaryText {
    return formType == EmailSignInFormType.SignIn
        ? 'Sign In'
        : 'Create an account';
  }

  String get secondaryText {
    return formType == EmailSignInFormType.SignIn
        ? 'Need an account? Register'
        : 'Have an account? Sign In';
  }

  bool get enabledSubmit {
    return (!emailValidator.isEmpty(email) &&
            !passwordValidator.isEmpty(password)) &&
        !isLoading;
  } 

  final String email;
  final String password;
  final bool isLoading;
  final EmailSignInFormType formType;

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
