import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web/screens/auth/sign_in.dart';
import 'package:web/screens/home/home.dart';
import 'package:web/shared/loading.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isSignIn = context.watch<bool?>();
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
        : _isSignIn
            ? Home()
            : const SignIn();
  }
}
