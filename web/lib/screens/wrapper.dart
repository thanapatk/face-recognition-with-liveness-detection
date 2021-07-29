import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/screens/auth/sign_in.dart';
import 'package:web/screens/home/home.dart';
import 'package:web/shared/loading.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _isSignIn = context.watch<bool?>();
    return _isSignIn == null
        ? FoldingCubeLoading(
            size: _size.width * 0.03,
            backgroundColor: Theme.of(context).backgroundColor)
        : _isSignIn
            ? Home()
            : const SignIn();
  }
}
