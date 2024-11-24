//import 'dart:developer';
import 'package:bookauditorium/home_screen.dart';
import 'package:bookauditorium/services/firebase_Auth.dart';
import 'package:bookauditorium/sign_up_screen.dart';
import 'package:bookauditorium/widgets/custom_loader.dart';
import 'package:bookauditorium/widgets/custom_text_field.dart';
import 'package:bookauditorium/widgets/social_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import the sign-up screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool admin  =  false ;
class _LoginScreenState extends State<LoginScreen> {
  final Authservice _auth = Authservice();
  final FirebaseAuth _authh = FirebaseAuth.instance;
  bool isLoading = false;
  final _email = TextEditingController();
  final _password = TextEditingController();
  User? _user;

  @override
  void initState() {
    super.initState();
    // Check if the user is already logged in when the app starts
    _checkLoggedInUser();

    // Listen for changes in authentication state
    _authh.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  void _checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? uid = prefs.getString('uid');

    if (email != null && uid != null) {
      // User is already logged in, navigate to HomeScreen
      goToHome(context);
    }
  }


  // Check for the saved login state from SharedPreferences
  Future<void> _checkLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? uid = prefs.getString('uid');

    if (email != null && uid != null) {
      // User is already logged in, navigate to home screen
      goToHome(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome configurations
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 255, 255, 255),
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 85)),
              const SizedBox(height: 20),
              const Text('Login',
                  style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 32,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              CustomTextField(
                  label: 'Email',
                  hintText: 'abcd@gmail.com',
                  textStyle: const TextStyle(fontFamily: 'Lora'),
                  controller: _email),
              const SizedBox(height: 20),
              CustomTextField(
                  label: 'Password',
                  hintText: 'Password',
                  isPassword: true,
                  textStyle: const TextStyle(fontFamily: 'Lora'),
                  controller: _password),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => ForgotPasswordPage()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Forgot your password?',
                          style: TextStyle(
                              fontFamily: 'Lora',
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_forward,
                          color: Colors.red, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(

                    onPressed: (){
                      FocusManager.instance.primaryFocus?.unfocus();
                      //
                      if(_email.text.isEmpty && _password.text.isEmpty){
                        Fluttertoast.showToast(msg: "Please enter both fields");
                      }
                      else if(_email.text.isEmpty){
                        Fluttertoast.showToast(msg: "Please enter Email");
                      }
                      else if(_password.text.isEmpty){
                        Fluttertoast.showToast(msg: "Please enter password");
                      }
                      else{
                        _login();
                      }
                    },

                    style: ElevatedButton.styleFrom(

                      backgroundColor: const Color(0xFFFFCC00),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text('LOGIN',
                        style: TextStyle(
                            fontFamily: 'Lora',
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
                  },
                  child: const Text("Don't have an account? Sign up here",
                      style: TextStyle(
                          fontFamily: 'Lora',
                          color: Colors.blue,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 120),
              const Center(
                  child: Text('Or login with social account',
                      style: TextStyle(
                          fontFamily: 'Lora',
                          fontSize: 16,
                          fontWeight: FontWeight.bold))),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      // onTap: () async {
                      //   await _auth.signInWithGoogle();
                      // },
                      child: const SocialButton(
                          imagePath: 'assets/images/google_icon.png')),
                  const SizedBox(width: 30),
                  const SocialButton(
                      imagePath: 'assets/images/facebook_icon.png'),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

 Future<void> _login() async {
  await CustomLoader.showLoaderForTask(
    context: context,
    task: () async {
      try {
        print("Entered email: ${_email.text}");
        print("Entered password: ${_password.text}");
        
        // Firebase Authentication to check user credentials
        final result = await _auth.loginWithEmailAndPassword(
          _email.text,
          _password.text,
        );
        
        if (result != null) {
          print('Firebase login result: $result');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', result['email']!);
          await prefs.setString('uid', result['auth_id']!);
          
          // Fetch user role from Firebase Firestore (authentication collection)
          var userDoc = await FirebaseFirestore.instance
              .collection('authentication')
              .doc(result['auth_id']) // Using the user's auth_id
              .get();

          if (userDoc.exists) {
            var role = userDoc.data()?['role']; // Get role from the Firestore document
            
            if (role == 'admin') {
              setState(() {
                admin =  true;
              });
              await prefs.setString('admin', "true");
              print('Admin login successful!');
              // Navigate to Admin Dashboard
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
              // );
            } else if(role == 'user'){
              print('User login successful!');
              // Navigate to Home Screen for regular users
              goToHome(context);
            }
          } else {
            print('User document not found in Firestore.');
          }
        } else {
         Fluttertoast.showToast(msg: "Invaliad User");
        }
      } catch (error) {
        print("Error during login: $error");
      }
    },
  );
}



  void goToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}