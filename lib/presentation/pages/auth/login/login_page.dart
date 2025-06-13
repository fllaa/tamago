import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/app/routes/app_routes.dart';
import 'package:flutter_boilerplate/core/constants/string_constants.dart';
import 'package:flutter_boilerplate/core/utils/validators.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/auth/login_viewmodel.dart';
import 'package:flutter_boilerplate/presentation/widgets/common/custom_button.dart';
import 'package:flutter_boilerplate/presentation/widgets/common/custom_text_field.dart';
import 'package:flutter_boilerplate/presentation/widgets/common/loading_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginViewModel>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            rememberMe: _rememberMe,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(StringConstants.loginSuccessful),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is LoginValidationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo
                          Icon(
                            Icons.flutter_dash,
                            size: 80,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),

                          // Title
                          Text(
                            StringConstants.login,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),

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
                          const SizedBox(height: 12),

                          // Remember me and Forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Remember me
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                  const Text('Remember me'),
                                ],
                              ),

                              // Forgot password
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.forgotPassword);
                                },
                                child:
                                    const Text(StringConstants.forgotPassword),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Login button
                          BlocBuilder<LoginViewModel, LoginState>(
                            builder: (context, state) {
                              return state is LoginLoading
                                  ? const LoadingWidget()
                                  : CustomButton(
                                      text: StringConstants.login,
                                      onPressed: _login,
                                    );
                            },
                          ),
                          const SizedBox(height: 24),

                          // Register link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.register);
                                },
                                child: const Text(StringConstants.register),
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
        ),
      ),
    );
  }
}
