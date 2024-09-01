import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app/sign-_n/email_signin_model.dart';
import 'package:my_app/common_wiget/button/button.dart';
import 'package:my_app/app/sign-_n/vaildate.dart';
import 'package:my_app/common_wiget/exception_alert_dialog/exception_alert_dialog.dart';
import 'package:my_app/service/auth.dart';
import 'package:provider/provider.dart';

class SignFormStateFul extends StatefulWidget with EmailAndPasswordValidator {
  SignFormStateFul({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<SignFormStateFul> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _emailValue => _emailController.text;
  String get _passwordValue => _passwordController.text;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInFormType _formType = EmailSignInFormType.SignIn;

  bool _isLoading = false;

  bool get isValidEmail =>
      widget.emailValidator.isEmpty(_emailValue) ||
      widget.emailValidator.isValidEmail(_emailValue);

  void _editEmailComplete() {
    final newFocus = isValidEmail ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    print('dispose called');
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    print('submitting...');
    print(
        'email: ${_emailController.text}, password: ${_passwordController.text}');

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);

      await Future.delayed(const Duration(seconds: 3));

      if (_formType == EmailSignInFormType.SignIn) {
        await auth.signInWithEmailAndPassword(_emailValue, _passwordValue);
      } else {
        await auth.createUserWithEmailAndPassword(_emailValue, _passwordValue);
      }

      Navigator.of(context).pop();

      print('done...');
    } on FirebaseAuthException catch (error) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: error,
      );
      print('done but error: ....');
      print(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType == EmailSignInFormType.SignIn
          ? _formType = EmailSignInFormType.Register
          : _formType = EmailSignInFormType.SignIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(BuildContext context) {
    final String primaryText = _formType == EmailSignInFormType.SignIn
        ? 'Sign In'
        : 'Create an account';

    final String secodaryText = _formType == EmailSignInFormType.SignIn
        ? 'Need an account? Register'
        : 'Have an account? Sign In';

    final bool enabledSubmit =
        (!widget.emailValidator.isEmpty(_emailValue) ||
                !widget.emailValidator.isEmpty(_passwordValue)) &&
            !_isLoading;

    return [
      TextFormField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@gmail.com',
          border: const OutlineInputBorder(),
          enabled: _isLoading == false,
        ),
        keyboardType: TextInputType.emailAddress,
        // textInputAction: TextInputAction.next,
        validator: (value) {
          if (widget.emailValidator.isEmpty(value ?? '')) {
            return 'Please enter your email';
          }

          if (!widget.emailValidator.isValidEmail(value ?? '')) {
            return 'Please enter a valid email address';
          }
          return null;
        },

        onChanged: (password) => _updateState(),
        onEditingComplete: _editEmailComplete,
      ),
      const SizedBox(
        height: 18.0,
      ),
      TextFormField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        decoration: InputDecoration(
          labelText: 'Password',
          border: const OutlineInputBorder(),
          enabled: _isLoading == false,
        ),
        obscureText: true,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (widget.passwordValidator.isEmpty(value ?? '')) {
            return 'Please enter your password';
          }

          return null;
        },
        onChanged: (password) => _updateState(),
        onEditingComplete: () {
          if (_formKey.currentState?.validate() == true) {
            _submit();
          }
        },
      ),
      const SizedBox(
        height: 12.0,
      ),
      ButtonSystem(
        onPressed: enabledSubmit
            ? () {
                if (_formKey.currentState?.validate() == true) {
                  _submit();
                }
              }
            : null,
        label: primaryText,
        bgColor: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(
        height: 12.0,
      ),
      TextButton(
          onPressed: () {
            _toggleFormType();
          },
          child: Text(secodaryText))
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Form(
        key: _formKey,
        child: SizedBox(
          width: screenWidth * 0.9 - 32.0,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(context)),
        ));
  }
}
