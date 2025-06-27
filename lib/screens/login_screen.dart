import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:practise_app/services/api_service.dart';
import 'package:practise_app/services/token_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
//logic of login 
void _onLogin() async {
  if (_formKey.currentState!.validate()) {
    final email = _emailController.text.trim();

    try {
      final response = await ApiService.loginUser(email);
      if (response.statusCode == 200) {
        final responseData = response.data;

        final accessToken = responseData['access'] ?? responseData['user']['access'];

        await TokenService.saveToken(accessToken);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/all-products');
        final token = await TokenService.getToken();

        print("before logout: $token");
      }
    } on DioException catch (e) {
      String errorMessage = 'Login failed';

      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        if (statusCode == 404 || responseData.toString().contains("User not found")) {
          errorMessage = 'Login failed: User does not exist. Please sign up first.';
        } else if (statusCode == 400) {
          errorMessage = 'Invalid login request.';
        } else {
          errorMessage = 'Login failed: ${responseData['message'] ?? 'Unknown error'}';
        }
      } else {
        errorMessage = 'Network error: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(12));

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: FadeTransition(
        opacity: _fadeIn,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Login to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onLogin(),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: borderRadius,
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _onLogin,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      'Don’t have an account? Sign up',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
