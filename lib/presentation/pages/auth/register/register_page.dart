import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/app/routes/app_routes.dart';
import 'package:flutter_boilerplate/core/constants/string_constants.dart';
import 'package:flutter_boilerplate/core/utils/validators.dart';
import 'package:flutter_boilerplate/presentation/widgets/common/custom_button.dart';
import 'package:flutter_boilerplate/presentation/widgets/common/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Register logic would go here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(StringConstants.registrationSuccessful),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.register),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      Text(
                        'Create an Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill out the form to get started',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Name field
                      CustomTextField(
                        controller: _nameController,
                        labelText: StringConstants.fullName,
                        hintText: 'John Doe',
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: 20),

                      // Email field
                      CustomTextField(
                        controller: _emailController,
                        labelText: StringConstants.email,
                        hintText: 'example@email.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 20),

                      // Password field
                      CustomTextField(
                        controller: _passwordController,
                        labelText: StringConstants.password,
                        hintText: '********',
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password field
                      CustomTextField(
                        controller: _confirmPasswordController,
                        labelText: StringConstants.confirmPassword,
                        hintText: '********',
                        obscureText: _obscureConfirmPassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                        validator: (value) =>
                            Validators.validateConfirmPassword(
                          value,
                          _passwordController.text,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Register button
                      CustomButton(
                        text: StringConstants.register,
                        onPressed: _register,
                      ),
                      const SizedBox(height: 24),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.login);
                            },
                            child: const Text(StringConstants.login),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
