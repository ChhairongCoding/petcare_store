import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:petcare_store/config/core/routes/app_routes.dart';

import 'package:petcare_store/widgets/text_form_field_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cfPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;

  void tappedOpsecured() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Email";
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  _body() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Image.asset('assets/icons/logo/ic_launcher.png', height: 100),
                SizedBox(height: 20),
                Text(
                  "Create an account",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        "Sign In",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                TextFormFieldWidget(
                  label: "Name",
                  controller: nameController,
                  prefixIcon: Icons.person,
                ),
                SizedBox(height: 16),
                TextFormFieldWidget(
                  controller: emailController,
                  label: "Email",
                  validator: validateEmail,
                  prefixIcon: Icons.email,
                ),
                SizedBox(height: 16),
                TextFormFieldWidget(
                  controller: passwordController,
                  label: "Password",
                  // obscureText: isObscure,
                  // icon: isObscure ? Icons.visibility_off : Icons.visibility,
                  // onPressed: tappedOpsecured,
                  // prefixIcon: Icons.lock,
                ),
                SizedBox(height: 16),

                TextFormFieldWidget(
                  label: "Confirm Password",
                  controller: cfPasswordController,
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey.shade400, thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Or continue with",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey.shade400, thickness: 1),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                GestureDetector(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          height: 24,
                          width: 24,
                          imageUrl:
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png",
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Continue with Google",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
