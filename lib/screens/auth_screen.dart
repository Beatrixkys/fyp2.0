import 'package:flutter/material.dart';
import 'package:fyp2/screens/components/loading.dart';
import 'package:fyp2/services/local_auth.dart';
import 'package:fyp2/services/validator.dart';

import '../constant.dart';
import '../services/auth.dart';
import 'components/animated_image.dart';
import 'components/round_components.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _auth = AuthService();
  String error = '';
  String email = "";
  String password = "";
  String name = "";

  //Form
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final val = Validator();

  bool showSignIn = true;
  bool loading = false;

  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState!.reset();
      error = '';
      emailController.text = '';
      passwordController.text = '';
      nameController.text = '';
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            body: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  const SizedBox(
                      width: double.infinity,
                      child: AnimatedImage(
                        image1: "assets/cloud.png",
                        image2: "assets/bird.png",
                      )),
                  space,
                  SizedBox(
                    child: Text(
                      showSignIn ? "Sign In" : "Register",
                      style: kHeadingTextStyle,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (showSignIn == false)
                          (RoundTextField(
                            controller: nameController,
                            title: "Name",
                            isPassword: false,
                            onSaved: (String? value) {
                              name != value;
                            },
                            validator: val.nameVal,
                          )),
                        space,
                        RoundTextField(
                            controller: emailController,
                            title: "Email",
                            isPassword: false,
                            onSaved: (String? value) {
                              email != value;
                            },
                            validator: val.emailVal),
                        const SizedBox(
                          height: 20,
                        ),
                        RoundTextField(
                          controller: passwordController,
                          title: "Password",
                          isPassword: true,
                          onSaved: (String? value) {
                            password != value;
                          },
                          validator: val.passwordVal,
                        ),

                        smallSpace,
                        if (showSignIn == true)
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/resetpassword');
                            },
                            child: Text(
                              "Forget Password?",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark),
                            ),
                          ),
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: 300,
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    var password =
                                        passwordController.value.text;
                                    var email = emailController.value.text;
                                    var name = nameController.value.text;

                                    dynamic result = showSignIn
                                        ? await _auth
                                            .signInWithEmailAndPassword(
                                                email, password, context)
                                        : await _auth.register(
                                            email, password, name, context);

                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        error = "Please supply valid email";
                                        //TODO! Show POP UP ERROR
                                      });
                                    }

                                    if (!mounted) return;
                                    Navigator.pushNamed(context,
                                        showSignIn ? '/home' : '/setupprofile');
                                  }
                                },
                                style: kButtonStyle,
                                child: Text(
                                  showSignIn ? 'Log In' : 'Register',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ),
                              Divider(
                                height: 20.0,
                                color: Theme.of(context).primaryColor,
                              ),
                              const Center(
                                child: Text(
                                  "Don't Have An Account?",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              smallSpace,
                              ElevatedButton(
                                onPressed: () => toggleView(),
                                style: kButtonStyle,
                                child: Text(
                                  showSignIn ? 'Register' : 'Sign In',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),

                        space,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class BioAuthScreen extends StatefulWidget {
  const BioAuthScreen({Key? key}) : super(key: key);

  @override
  State<BioAuthScreen> createState() => _BioAuthScreenState();
}

class _BioAuthScreenState extends State<BioAuthScreen> {
  bool isAuthenticating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Center(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 200, horizontal: 50),
                  child: Column(
                    children: [
                      const Text(
                        'Click Lock to Scan for Double Authentication',
                        style: kTitleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      space,
                      IconButton(
                        icon: const Icon(Icons.fingerprint),
                        iconSize: 100,
                        color: Theme.of(context).primaryColorDark,
                        highlightColor: Colors.white,
                        onPressed: () async {
                          bool isAuthenticated =
                              await LocalAuthApi.authenticate();

                          if (isAuthenticated) {
                            if (!mounted) return;
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final controller = ScrollController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final val = Validator();

  bool loading = false;
  String email = " ";
  String error = " ";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 100),
            SizedBox(
              height: 100,
              child: Image.asset('assets/bird.png'),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(5),
              child: const Center(
                child: Text(
                  "Forgot Password?",
                  style: kHeadingTextStyle,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(5),
              child: const Text(
                "Reset Below",
                style: kHeadingTextStyle,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(5),
              child: Form(
                key: _formKey,
                child: RoundTextField(
                  controller: emailController,
                  title: "Email",
                  isPassword: false,
                  onSaved: (String? value) {
                    email != value;
                  },
                  validator: val.emailVal,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pushNamed(context, '/');
                },
                style: kButtonStyle,
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
