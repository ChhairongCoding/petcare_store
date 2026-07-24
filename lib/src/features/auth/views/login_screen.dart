import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/features/auth/controller/auth_controller.dart';
import 'package:petcare_store/src/widgets/text_form_field_widgets.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Get.back();
                } else {
                  Get.offAllNamed(AppRoutes.mainScreen);
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Obx(
      () => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                  SizedBox(height: 12),
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
                child: controller.isLoading.value
                    ? SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Text("Login"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool success = await controller.login(
                      emailController.text,
                      passwordController.text,
                      context,
                    );
                    if (success) {
                      Get.offNamed(AppRoutes.mainScreen);
                    }
                  }
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
                    Image.asset("assets/images/google.png", height: 25),
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
    ),
  );
}
