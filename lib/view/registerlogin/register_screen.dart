import 'package:Sehati/view/homeprofile/dataprep.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Sehati/providers/auth_provider.dart';
import 'package:Sehati/view/registerlogin/login_screen.dart';
import 'package:google_fonts/google_fonts.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  bool _obscurePassword = true;
  
  // Error messages for each field
  String? _nameError;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).clearErrors();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  // Email validation regex
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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
                              SizedBox(height: constraints.maxHeight * 0.04),

                              // Welcome Text - Left aligned
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Selamat datang\nMoms',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),

                              SizedBox(height: constraints.maxHeight * 0.03),

                              // White Card Form
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
                                              'Daftar Akun',
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
                                              'Buat akun untuk melanjutkan',
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

                                          // Name field
                                          Text(
                                            'Nama',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF424242),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildInputField(
                                            controller: _nameController,
                                            hintText: 'Masukkan nama Anda',
                                            onChanged: (value) {
                                              setState(() {
                                                if (value.isEmpty) {
                                                  _nameError = 'Nama tidak boleh kosong';
                                                } else {
                                                  _nameError = null;
                                                }
                                              });
                                            },
                                          ),
                                          if (_nameError != null)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4, left: 4),
                                              child: Text(
                                                _nameError!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: const Color(0xFFFC7286),
                                                ),
                                              ),
                                            ),
                                          const SizedBox(height: 16),

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
                                                } else if (value.length < 6) {
                                                  _passwordError = 'Password minimal 6 karakter';
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

                                          const SizedBox(height: 24),

                                          // Register Button
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
                                                        // Validate name
                                                        if (_nameController.text.isEmpty) {
                                                          _nameError = 'Nama tidak boleh kosong';
                                                          hasError = true;
                                                        } else {
                                                          _nameError = null;
                                                        }

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
                                                        } else if (_passwordController.text.length < 6) {
                                                          _passwordError = 'Password minimal 6 karakter';
                                                          hasError = true;
                                                        } else {
                                                          _passwordError = null;
                                                        }
                                                      });

                                                      if (!hasError) {
                                                        try {
                                                          final success = await authProvider.register(
                                                            _nameController.text,
                                                            _emailController.text,
                                                            _passwordController.text,
                                                            _passwordConfirmationController.text,
                                                          );

                                                          if (success && mounted) {
                                                            // Successfully registered, navigate to DataFormPage
                                                            Navigator.of(context).pushAndRemoveUntil(
                                                              MaterialPageRoute(
                                                                builder: (_) => DataFormPage(),
                                                              ),
                                                              (route) => false,
                                                            );
                                                          }
                                                        } catch (e) {
                                                          // Error handling is managed by the provider
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
                                                      'DAFTAR',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                            ),
                                          ),

                                          const SizedBox(height: 16),

                                          // Login link
                                          Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Sudah Punya Akun? ',
                                                  style: GoogleFonts.poppins(
                                                    color: const Color(0xFF757575),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (_) => const LoginScreen(),
                                                      ),
                                                    );
                                                  },
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                    minimumSize: Size.zero,
                                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  ),
                                                  child: Text(
                                                    'Masuk',
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

  // Clean modern input field - matching login screen
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