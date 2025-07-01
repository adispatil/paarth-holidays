import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/extensions/text_style_extension.dart';
import 'login_controller.dart';
import '../forgot_password/forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Logo Section
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 256,
                        height: 86,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Login Title
                Text('Log In', style: TextStyleExtension.h1),
                const SizedBox(height: 40),
                // Email Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyleExtension.bodyMedium.withColor(
                        const Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: Color(0xFFEEEEEE),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: Color(0xFFEEEEEE),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF7D00),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Password Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: TextStyleExtension.bodyMedium.withColor(
                        const Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Obx(
                      () => TextField(
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                              color: Color(0xFFEEEEEE),
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                              color: Color(0xFFEEEEEE),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF7D00),
                              width: 1.5,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.to(() => const ForgotPasswordScreen()),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyleExtension.bodyMedium.withColor(
                        const Color(0xFFFF7D00),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login Button
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7D00),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      elevation: 5,
                      shadowColor: const Color(
                        0xFFFF7D00,
                      ).withValues(alpha: 0.3),
                    ),
                    child:
                        controller.isLoading.value
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              'Log In',
                              style: TextStyleExtension.buttonPrimary,
                            ),
                  ),
                ),
                const SizedBox(height: 20),
                // Or Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or',
                        style: TextStyleExtension.bodyMedium.withColor(
                          const Color(0xFFAAAAAA),
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),
                // Google Login Button
                GestureDetector(
                  onTap: controller.loginWithGoogle,
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(1, 5),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google_logo.png',
                          width: 26,
                          height: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Log In With Google',
                          style: TextStyleExtension.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyleExtension.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: controller.goToSignUp,
                      child: Text(
                        'Sign Up Here',
                        style: TextStyleExtension.bodyMedium.withColor(
                          const Color(0xFFFF7D00),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
