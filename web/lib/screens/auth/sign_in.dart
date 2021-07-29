import 'package:flutter/material.dart';
import 'package:web/services/auth.dart';
import 'package:web/shared/constant.dart';
import 'package:web/shared/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _loading = false;

  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: _loading
            ? FoldingCubeLoading(size: _size.width * 0.03)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          //offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    width: 0.4 * _size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 30.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  'images/SWU_Prasanmit_Demonstration_Sec_TH_Color.png',
                              imageBuilder: (context, imageProvider) => Image(
                                image: imageProvider,
                                width: _size.width * .3,
                              ),
                              placeholder: (context, url) => SizedBox(
                                width: _size.width * .3,
                                height: (_size.width * .3) * 0.3243593902,
                                child: WaveLoading(size: _size.width * 0.03),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Text(
                              'PSM Attendance',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: email,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: textInputDecoration.copyWith(
                                  hintText: "Email"),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Enter your email';
                                } else if (!val.endsWith('@spsm.ac.th')) {
                                  return 'Not a valid SPSM email.';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) => setState(() => email = val),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              initialValue: password,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: textInputDecoration.copyWith(
                                hintText: "Password",
                                suffixIcon: password.isEmpty
                                    ? null
                                    : IconButton(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        icon: Icon(_obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined),
                                        color: Colors.grey[500],
                                        onPressed: () => setState(() =>
                                            _obscurePassword =
                                                !_obscurePassword),
                                      ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter your password' : null,
                              onChanged: (val) =>
                                  setState(() => password = val),
                            ),
                            if (error.isNotEmpty)
                              Text(
                                error,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Colors.red),
                              ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: _size.width * .2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _loading = true);
                                    dynamic result = await _authService
                                        .signInWithEmailAndPassword(
                                            email: email, password: password);
                                    if (result == null) {
                                      setState(() {
                                        _loading = false;
                                        error = "Invalid Credentials";
                                      });
                                    }
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
