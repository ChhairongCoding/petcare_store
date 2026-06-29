import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:petcare_store/config/core/routes/app_routes.dart';
import 'package:petcare_store/src/features/auth/controller/auth_controller.dart';
import 'package:petcare_store/src/widgets/text_form_field_widgets.dart';
import 'package:petcare_store/src/widgets/reusables/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cfPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthController controller = Get.find<AuthController>();

  bool isObscure = true;
  bool isObscureCf = true;

  void tappedOpsecured() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  void tappedOpsecuredCf() {
    setState(() {
      isObscureCf = !isObscureCf;
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
                  hintText: "Name",
                  controller: nameController,
                  prefixIcon: Icons.person,
                ),
                SizedBox(height: 16),
                TextFormFieldWidget(
                  controller: emailController,
                  label: "Email",
                  hintText: "Email",
                  validator: validateEmail,
                  prefixIcon: Icons.email,
                ),
                SizedBox(height: 16),
                TextFormFieldWidget(
                  controller: passwordController,
                  label: "Password",
                  hintText: "Password",
                  obscureText: isObscure,
                  icon: isObscure ? Icons.visibility_off : Icons.visibility,
                  onPressed: tappedOpsecured,
                  prefixIcon: Icons.lock,
                ),
                SizedBox(height: 16),

                TextFormFieldWidget(
                  label: "Confirm Password",
                  hintText: "Confirm Password",
                  controller: cfPasswordController,
                  obscureText: isObscureCf,
                  icon: isObscureCf ? Icons.visibility_off : Icons.visibility,
                  onPressed: tappedOpsecuredCf,
                  prefixIcon: Icons.lock,
                  validator: (value) {
                    if (value != passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                Obx(
                  () => CustomButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Get.snackbar(
                          "Form Validated",
                          "Sign Up form validated successfully! Ready for backend integration.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.9),
                          colorText: Colors.white,
                        );
                      }
                    },
                    label: 'Sign Up',
                    isLoading: controller.isLoading.value,
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
                      borderRadius: BorderRadius.circular(16),
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
                        Image.asset("assets/images/google.png", height: 24),
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
