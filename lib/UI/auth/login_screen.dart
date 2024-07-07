import 'package:docup_app/UI/auth/signup_screen.dart';
import 'package:docup_app/UI/posts/upload_screen.dart';
import 'package:docup_app/Widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Login',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        //helperText: 'abc@gmail.com',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Pasword',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  ],
                )),
            RoundButton(
              title: 'Login',
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _auth.signInWithEmailAndPassword(
                      email: emailController.text.toString(),
                      password: passController.text.toString());
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UploadScreen()));
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Text('Dont hava an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text('Sign up'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
