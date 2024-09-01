import 'dart:async';

import 'package:my_app/app/sign-_n/email_signin_model.dart';
import 'package:my_app/service/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  final AuthBase auth;

  final StreamController<EmailSignInModel> _modelcontroller =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelcontroller.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelcontroller.close();
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.SignIn
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
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
    );

    _modelcontroller.add(_model);
  }

  Future<void> submit() async {
    updateWith(
      isLoading: true,
    );

    try {
      await Future.delayed(const Duration(seconds: 3));

      if (_model.formType == EmailSignInFormType.SignIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (error) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
