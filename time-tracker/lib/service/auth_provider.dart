import 'package:flutter/cupertino.dart';
import 'package:my_app/service/auth.dart';

class AuthAppProvider extends InheritedWidget {
  const AuthAppProvider({
    super.key,
    required this.auth,
    required super.child,
  });

  final AuthBase auth;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static AuthBase of(BuildContext context) {
    AuthAppProvider? provider = context.dependOnInheritedWidgetOfExactType<AuthAppProvider>();
    return provider!.auth;
  }

}