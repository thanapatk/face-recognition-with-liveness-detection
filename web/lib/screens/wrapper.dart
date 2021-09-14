import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web/models/user.dart';
import 'package:web/screens/auth/sign_in.dart';
import 'package:web/screens/home/home_wrapper.dart';
import 'package:web/services/database.dart';
import 'package:web/shared/loading.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isSignIn = context.watch<bool?>();
    final _user = context.watch<User?>();
    return _isSignIn == null
        ? FoldingCubeLoading(
            backgroundColor: Theme.of(context).backgroundColor,
            size: getValueForScreenType<double>(
              context: context,
              mobile: 60,
              tablet: 50,
              desktop: 40,
            ),
          )
        : (_isSignIn && _user != null)
            ? MultiProvider(
                providers: [
                  StreamProvider<UserData?>(
                    initialData: null,
                    create: (context) =>
                        DatabaseService(uid: _user.uid).userData,
                  ),
                  StreamProvider<Map<String, String>?>(
                    initialData: null,
                    create: (context) =>
                        DatabaseService(uid: _user.uid).machines,
                  ),
                ],
                child: const HomeWrapper(),
              )
            : const SignIn();
  }
}
