import 'package:flutter/cupertino.dart';
import 'package:my_app/app/sign-_n/email_signin_model.dart';
import 'package:my_app/app/sign-_n/vaildate.dart';
import 'package:my_app/service/auth.dart';

class EmailSignInChangeModel with EmailAndPasswordValidator, ChangeNotifier {
  EmailSignInChangeModel({
    required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.SignIn,
    this.isLoading = false,
  });

  final AuthBase auth;
  String email;
  String password;
  bool isLoading;
  EmailSignInFormType formType;

  String get primaryText {
    return formType == EmailSignInFormType.SignIn
        ? 'Sign In'
        : 'Register an account';
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

  Future<void> submit() async {
    updateWith(
      isLoading: true,
    );

    try {
      await Future.delayed(const Duration(seconds: 3));

      if (formType == EmailSignInFormType.SignIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(
            email, password);
      }
    } catch (error) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.SignIn
        ? EmailSignInFormType.Register
        : EmailSignInFormType.SignIn;
    updateWith(formType: formType, isLoading: false, email: '', password: '');
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;

    notifyListeners();
  }
}
