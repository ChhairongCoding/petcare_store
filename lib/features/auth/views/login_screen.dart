import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/config/core/routes/app_routes.dart';
import 'package:petcare_store/features/auth/controller/auth_controller.dart';
import 'package:petcare_store/widgets/text_form_field_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController controller = Get.find<AuthController>();

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
    return Scaffold(body: _buildBody(context));
  }

  _buildBody(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 60),
          Image.asset('assets/icons/logo/ic_launcher.png', height: 100),
          SizedBox(height: 20),
          Text('Login', style: Theme.of(context).textTheme.titleLarge),
          Text(
            "Welcome to Pet Care Store",
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Colors.grey.shade600),
          ),
          SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormFieldWidget(
                  label: "Email",
                  hintText: "Enter Email",
                  controller: emailController,
                  validator: validateEmail,
                ),

                SizedBox(height: 12),
                TextFormFieldWidget(
                  label: "Password",
                  hintText: "Enter Password",
                  controller: passwordController,
                  obscureText: isObscure,
                  icon: isObscure ? Icons.visibility_off : Icons.visibility,
                  onPressed: tappedOpsecured,
                ),
                SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Text("Forget Password"),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: Text("Login"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
                controller.login(emailController.text, passwordController.text);
              },
            ),
          ),
          SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: Container(height: 0.5, color: Colors.grey)),
              Text("or", style: Theme.of(context).textTheme.bodyLarge),
              Expanded(child: Container(height: 0.5, color: Colors.grey)),
            ],
          ),
          SizedBox(height: 32),

          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(4),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  CachedNetworkImage(
                    height: 50,
                    width: 50,
                    imageUrl:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png",
                  ),
                  Text(
                    "Continue with Google",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.signup),
                child: Text("Sign Up"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
