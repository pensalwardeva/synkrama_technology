import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synkrama_technology/view/forgot_password.dart';
import '../controller/auth_controller.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true; // Variable to toggle password visibility

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final String email = emailController.text;
      final String password = passwordController.text;

      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? savedEmail = prefs.getString('email');
        final String? savedPassword = prefs.getString('password');

        if (savedEmail == null || savedPassword == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No user found. Please sign up first.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        bool emailIncorrect = savedEmail != email;
        bool passwordIncorrect = savedPassword != password;

        if (emailIncorrect && passwordIncorrect) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Incorrect email and password'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (emailIncorrect) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect email address'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (passwordIncorrect) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect password'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          await Provider.of<AuthController>(context, listen: false)
              .login(email, password);

          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonWidth = screenSize.width * 0.8; // Adjust width as needed

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: screenSize.height * 0.2,
              left: screenSize.width * 0.1,
              child: Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: screenSize.height * 0.4,
              left: screenSize.width * 0.1,
              right: screenSize.width * 0.1,
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "Enter Your E-mail Id",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.01,
                          horizontal: 10.0,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegExp.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword, // Toggle password visibility
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "Enter Your Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.01,
                          horizontal: 10.0,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword; // Toggle password visibility
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: screenSize.height * 0.01,
                              horizontal: screenSize.width * 0.3,
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.04,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Implement forgot password functionality here
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                              );
                            },
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.grey[800],
                                fontSize: screenSize.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenSize.height * 0.05,
                    ),
                    SizedBox(
                      width: buttonWidth, // Increased width to accommodate content
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Implement Google sign-in logic here
                        },
                        icon: Image.asset(
                          'assets/icons/google_icon.png', // Path to your asset image
                          width: screenSize.width * 0.08, // Adjusted icon size
                          height: screenSize.width * 0.08, // Adjusted icon size
                        ),
                        label: Text('Google'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.01,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    SizedBox(
                      width: buttonWidth,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Implement Facebook sign-in logic here
                        },
                        icon: Icon(Icons.facebook, size: screenSize.width * 0.06),
                        label: Text('Facebook'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff3b5998),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.01,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          'Create an account',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.grey[800],
                            fontSize: screenSize.width * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
