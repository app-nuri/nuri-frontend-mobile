import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Sehati/providers/auth_provider.dart';
import 'package:Sehati/view/registerlogin/register_screen.dart';
import 'package:Sehati/view/homeprofile/home.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  // Error messages for each field
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    // Clear any previous errors when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).clearErrors();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Email validation regex
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Method to show error dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Color(0xFFFC5C9C),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Color(0xFF4C617F),
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF4DBAFF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFC7286), // #FC7286
              Color(0xFFFE8987), // #FE8987
            ],
          ),
        ),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.08,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: constraints.maxHeight * 0.03),
                              
                              // Logo - Center aligned
                              Center(
                                child: Image.asset(
                                  'assets/images/prenava_logo.png',
                                  width: constraints.maxWidth * 0.35,
                                  height: constraints.maxWidth * 0.35,
                                  color: Colors.white,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              
                              SizedBox(height: constraints.maxHeight * 0.02),
                              
                              // Welcome Text - Aligned with card edge
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selamat datang kembali Moms!!',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: constraints.maxHeight * 0.008),
                                    Text(
                                      'Aplikasi cerdas Nuri siap membantu Moms !!',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(height: constraints.maxHeight * 0.025),
                              
                              // White Card Form - Flexible to fit remaining space
                              Flexible(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.89), // 89% opacity
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.all(constraints.maxWidth * 0.06),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Title inside card
                                          Center(
                                            child: Text(
                                              'Selamat Datang',
                                              style: GoogleFonts.poppins(
                                                color: const Color(0xFF424242),
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Center(
                                            child: Text(
                                              'Masuk untuk melanjutkan',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                color: const Color(0xFF9E9E9E),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          
                                          const SizedBox(height: 24),
                                      
                                      // Error message
                                      if (authProvider.error != null)
                                        Container(
                                          padding: const EdgeInsets.all(12.0),
                                          margin: const EdgeInsets.only(bottom: 16.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF0F0),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: const Color(0xFFFC7286).withOpacity(0.3),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.error_outline,
                                                color: Color(0xFFFC7286),
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  authProvider.error!,
                                                  style: GoogleFonts.poppins(
                                                    color: const Color(0xFFFC7286),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      
                                          // Email field
                                          Text(
                                            'Email',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF424242),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildInputField(
                                            controller: _emailController,
                                            hintText: 'Masukkan email Anda',
                                            keyboardType: TextInputType.emailAddress,
                                            onChanged: (value) {
                                              setState(() {
                                                if (value.isEmpty) {
                                                  _emailError = 'Email tidak boleh kosong';
                                                } else if (!_isValidEmail(value)) {
                                                  _emailError = 'Format email tidak valid';
                                                } else {
                                                  _emailError = null;
                                                }
                                              });
                                            },
                                          ),
                                          if (_emailError != null)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4, left: 4),
                                              child: Text(
                                                _emailError!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: const Color(0xFFFC7286),
                                                ),
                                              ),
                                            ),
                                          const SizedBox(height: 16),
                                          
                                          // Password field
                                          Text(
                                            'Kata Sandi',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF424242),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildInputField(
                                            controller: _passwordController,
                                            hintText: 'Masukkan sandi Anda',
                                            obscureText: _obscurePassword,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscurePassword 
                                                    ? Icons.visibility_off_outlined
                                                    : Icons.visibility_outlined,
                                                color: const Color(0xFF9E9E9E),
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _obscurePassword = !_obscurePassword;
                                                });
                                              },
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                if (value.isEmpty) {
                                                  _passwordError = 'Password tidak boleh kosong';
                                                } else {
                                                  _passwordError = null;
                                                }
                                              });
                                            },
                                          ),
                                          if (_passwordError != null)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4, left: 4),
                                              child: Text(
                                                _passwordError!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: const Color(0xFFFC7286),
                                                ),
                                              ),
                                            ),
                                        
                                          const SizedBox(height: 16),
                                          
                                          // Checkbox row for remember me and forgot password
                                          Row(
                                            children: [
                                              // Remember me checkbox (hardcoded)
                                              SizedBox(
                                                height: 18,
                                                width: 18,
                                                child: Checkbox(
                                                  value: false, // Hardcoded
                                                  onChanged: (value) {
                                                    // TODO: Implement remember me functionality
                                                  },
                                                  activeColor: const Color(0xFFFC7286),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Ingatkan saya',
                                                style: GoogleFonts.poppins(
                                                  color: const Color(0xFF757575),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const Spacer(),
                                              // Forgot password
                                              TextButton(
                                                onPressed: () {
                                                  // TODO: Implement forgot password functionality
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Fitur lupa kata sandi akan segera hadir',
                                                        style: GoogleFonts.poppins(),
                                                      ),
                                                      backgroundColor: const Color(0xFFFC7286),
                                                    ),
                                                  );
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  minimumSize: Size.zero,
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                ),
                                                child: Text(
                                                  'Lupa kata sandi?',
                                                  style: GoogleFonts.poppins(
                                                    color: const Color(0xFFFC7286),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          
                                          const SizedBox(height: 24),
                                          
                                          // Login Button
                                          SizedBox(
                                            width: double.infinity,
                                            height: 52,
                                        child: ElevatedButton(
                                          onPressed: authProvider.isLoading
                                              ? null
                                              : () async {
                                                  // Clear previous errors
                                                  authProvider.clearErrors();
                                                  
                                                  // Manual validation
                                                  bool hasError = false;
                                                  setState(() {
                                                    // Validate email
                                                    if (_emailController.text.isEmpty) {
                                                      _emailError = 'Email tidak boleh kosong';
                                                      hasError = true;
                                                    } else if (!_isValidEmail(_emailController.text)) {
                                                      _emailError = 'Format email tidak valid';
                                                      hasError = true;
                                                    } else {
                                                      _emailError = null;
                                                    }

                                                    // Validate password
                                                    if (_passwordController.text.isEmpty) {
                                                      _passwordError = 'Password tidak boleh kosong';
                                                      hasError = true;
                                                    } else {
                                                      _passwordError = null;
                                                    }
                                                  });
                                                  
                                                  if (!hasError) {
                                                    try {
                                                      final success = await authProvider.login(
                                                        _emailController.text,
                                                        _passwordController.text,
                                                      );
                                                      
                                                      if (success && mounted) {
                                                        // Successfully logged in, navigate to home screen
                                                        Navigator.of(context).pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                            builder: (_) => const HomePage(),
                                                          ),
                                                          (route) => false, // Remove all routes from stack
                                                        );
                                                      } else if (!success && mounted) {
                                                        // Login failed - show specific error dialog
                                                        _showErrorDialog(
                                                          'Login Gagal',
                                                          'Email atau password yang Anda masukkan salah. Silakan periksa kembali kredensial Anda.',
                                                        );
                                                      }
                                                    } catch (e) {
                                                      // Handle unexpected errors
                                                      if (mounted) {
                                                        _showErrorDialog(
                                                          'Terjadi Kesalahan',
                                                          'Terjadi kesalahan saat mencoba masuk. Silakan coba lagi.',
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: const Color(0xFFFC7286),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            disabledBackgroundColor: const Color(0xFFFC7286).withOpacity(0.5),
                                          ),
                                          child: authProvider.isLoading
                                              ? const SizedBox(
                                                  width: 24, 
                                                  height: 24,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  ),
                                                )
                                              : Text(
                                                  'MASUK',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 16),
                                        
                                        // Register link inside card
                                        Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Belum Punya Akun? ',
                                                style: GoogleFonts.poppins(
                                                  color: const Color(0xFF757575),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) => const RegisterScreen(),
                                                    ),
                                                  );
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  minimumSize: Size.zero,
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                ),
                                                child: Text(
                                                  'Daftar',
                                                  style: GoogleFonts.poppins(
                                                    color: const Color(0xFFFC7286),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
  
  // Clean modern input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFFBDBDBD),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFFC7286),
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: GoogleFonts.poppins(
          color: const Color(0xFF424242),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        onChanged: onChanged,
      ),
    );
  }
}