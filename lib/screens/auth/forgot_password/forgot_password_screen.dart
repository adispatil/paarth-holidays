import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/extensions/text_style_extension.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Forgot Password',
          style: TextStyleExtension.h2.withColor(Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: controller.formKey,
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
                          width: 200,
                          height: 67,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Forgot Password Title
                  Text('Forgot Password?', style: TextStyleExtension.h1),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    'Enter your registered email address and we\'ll send you a new password.',
                    textAlign: TextAlign.center,
                    style: TextStyleExtension.bodyMedium.withColor(
                      const Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Email Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: TextStyleExtension.bodyMedium.withColor(
                          const Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateEmail,
                        decoration: InputDecoration(
                          hintText: 'Enter your email address',
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
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Send Email Button
                  Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.sendPasswordResetEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7D00),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        elevation: 5,
                        shadowColor: const Color(0xFFFF7D00).withValues(alpha: 0.3),
                      ),
                      child: controller.isLoading.value
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
                              'Send Password Reset Email',
                              style: TextStyleExtension.buttonPrimary,
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Back to Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Remember your password? ',
                        style: TextStyleExtension.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          'Back to Login',
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
      ),
    );
  }
} 