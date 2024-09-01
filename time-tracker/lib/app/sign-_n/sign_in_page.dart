import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/app/sign-_n/sign_in_manager.dart';
import 'package:my_app/app/sign-_n/sign_in_email_page.dart';
import 'package:my_app/common_wiget/button/button.dart';
import 'package:my_app/common_wiget/button/social_button.dart';
import 'package:my_app/common_wiget/exception_alert_dialog/exception_alert_dialog.dart';
import 'package:my_app/service/auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key, required this.manager});
  final SignInManager manager;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
        create: (_) => SignInManager(auth: auth, isLoading: isLoading),
        child: Consumer<SignInManager>(
          builder: (_, manager, __) => SignInPage(manager: manager),
        )
      )
    )
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }

    showExceptionAlertDialog(context,
        title: 'Sign in faild', exception: exception);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      // final auth = Provider.of<AuthBase>(context, listen: false);
      manager.signInAnonymously();

      print('Sign in....');
    } on Exception catch (error) {
      _showSignInError(context, error);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on Exception catch (error) {
      _showSignInError(context, error);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => const EmailSignInPage()));
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<ValueNotifier<bool>>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time tracker',
            style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 5.0,
      ),
      body: _buildContent(context, isLoading.value),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildHeader(isLoading),
          const SizedBox(height: 16.0),
          SocialButton(
            icon: Image.asset('images/google-logo.png'),
            label: 'Sign In with Google',
            textColor: Colors.black,
            borderRadius: 8.0,
            bgColor: Colors.grey.shade300,
            height: 50.0,
            onPressed: () => _signInWithGoogle(context),
          ),

          const SizedBox(height: 12.0),

          ButtonSystem(
            label: 'Sign in with email',
            borderRadius: 8.0,
            bgColor: Colors.red.shade200,
            height: 50.0,
            onPressed: () {
              _signInWithEmail(context);
            },
          ),
          const SizedBox(height: 12.0),
          const Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12.0),
          ButtonSystem(
            label: 'Go anonymous',
            textColor: Colors.black,
            borderRadius: 8.0,
            bgColor: Color.fromARGB(255, 31, 171, 38),
            height: 50.0,
            onPressed: () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return const Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
