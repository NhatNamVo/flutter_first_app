import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app/sign-_n/email_signin_change_model.dart';
import 'package:my_app/common_wiget/button/button.dart';
import 'package:my_app/common_wiget/exception_alert_dialog/exception_alert_dialog.dart';
import 'package:my_app/service/auth.dart';
import 'package:provider/provider.dart';

class SignFormChangeNotifier extends StatefulWidget {
  const SignFormChangeNotifier({super.key, required this.model});

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return ChangeNotifierProvider<EmailSignInChangeModel>(
        create: (_) => EmailSignInChangeModel(auth: auth),
        child: Consumer<EmailSignInChangeModel>(
            builder: (_, model, __) => SignFormChangeNotifier(model: model)));
  }

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<SignFormChangeNotifier> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  void _editEmailComplete() {
    final isValidEmail = model.emailValidator.isEmpty(model.email) ||
        model.emailValidator.isValidEmail(model.email);

    final newFocus = isValidEmail ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
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

  Future<void> _submit() async {
    try {
      await widget.model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: error,
      );
    }
  }

  void _toggleFormType() {
    widget.model.toggleFormType();

    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      TextFormField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@gmail.com',
          border: const OutlineInputBorder(),
          enabled: model.isLoading == false,
        ),
        keyboardType: TextInputType.emailAddress,
        // textInputAction: TextInputAction.next,
        validator: (value) {
          if (model.emailValidator.isEmpty(value ?? '')) {
            return 'Please enter your email';
          }

          if (!model.emailValidator.isValidEmail(value ?? '')) {
            return 'Please enter a valid email address';
          }
          return null;
        },

        onChanged: widget.model.updateEmail,
        onEditingComplete: () => _editEmailComplete(),
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
          enabled: model.isLoading == false,
        ),
        obscureText: true,
        keyboardType: TextInputType.text,
        validator: (value) {
          if (model.passwordValidator.isEmpty(value ?? '')) {
            return 'Please enter your password';
          }

          return null;
        },
        onChanged: widget.model.updatePassword,
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
        onPressed: model.enabledSubmit
            ? () {
                if (_formKey.currentState?.validate() == true) {
                  _submit();
                }
              }
            : null,
        label: model.primaryText,
        bgColor: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(
        height: 12.0,
      ),
      TextButton(onPressed: _toggleFormType, child: Text(model.secondaryText))
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
              mainAxisSize: MainAxisSize.min, children: _buildChildren()),
        ));
  }
}
