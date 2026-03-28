import 'package:flutter/material.dart';
import 'package:freshfit/HomeScreen.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/strings.dart';
import '../../../core/utils/validators.dart';
import '../auth_controller.dart';
import 'signup_screen.dart';

const _kBg = Color(0xFFF2EBE2);
const _kAccent = Color(0xFF614051);
const _kAccentFade = Color(0x99614051);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
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

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authController = context.read<AuthController>();
      final success = await authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authController.successMessage ?? AppStrings.loginSuccess),
              backgroundColor: _kAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authController.errorMessage ?? AppStrings.loginError),
              backgroundColor: Colors.red.shade800,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildHeader(),
                  const SizedBox(height: 36),
                  _buildWelcomeText(),
                  const SizedBox(height: 28),
                  _buildLoginForm(),
                  const SizedBox(height: 12),
                  _buildForgotPassword(),
                  const SizedBox(height: 24),
                  _buildLoginButton(),
                  const SizedBox(height: 20),
                  _buildSignUpLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Logo box — eggplant bg, beige text
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _kAccent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: _kAccent, width: 2),
          ),
          child: const Center(
            child: Text(
              'FF',
              style: TextStyle(
                color: _kBg,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          AppStrings.appName,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: _kAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.welcomeBack,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
            color: _kAccent,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppStrings.loginSubtitle,
          style: const TextStyle(
            fontSize: 14,
            color: _kAccentFade,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // App image
          Center(
            child: Image.asset(
              'assets/img.png',
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 28),

          // Email field
          _borderedField(
            controller: _emailController,
            label: AppStrings.email,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),

          const SizedBox(height: 14),

          // Password field
          _borderedField(
            controller: _passwordController,
            label: AppStrings.password,
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            validator: Validators.password,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: _kAccentFade,
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ],
      ),
    );
  }

  /// Shared bordered text field matching the card/filter pill style
 Widget _borderedField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType? keyboardType,
  bool obscureText = false,
  String? Function(String?)? validator,
  Widget? suffixIcon,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    validator: validator,
    style: const TextStyle(color: _kAccent, fontSize: 15, fontWeight: FontWeight.w600),
    cursorColor: _kAccent,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: _kAccentFade, fontWeight: FontWeight.w600),
      prefixIcon: Icon(icon, color: _kAccentFade, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      floatingLabelStyle: const TextStyle(color: _kAccent, fontWeight: FontWeight.w700),
      errorStyle: const TextStyle(color: Colors.redAccent),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: _kAccent, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: _kAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    ),
  );
}

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {}, // TODO: forgot password
        child: const Text(
          AppStrings.forgotPassword,
          style: TextStyle(
            color: _kAccent,
            fontWeight: FontWeight.w700,
            fontSize: 13,
            decoration: TextDecoration.underline,
            decorationColor: _kAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Consumer<AuthController>(
      builder: (context, authController, _) {
        return GestureDetector(
          onTap: authController.isLoading ? null : _handleLogin,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: authController.isLoading ? _kAccentFade : _kAccent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: _kAccent, width: 2),
            ),
            child: Center(
              child: authController.isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(_kBg),
                      ),
                    )
                  : const Text(
                      AppStrings.login,
                      style: TextStyle(
                        color: _kBg,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: 0.4,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppStrings.dontHaveAccount,
          style: TextStyle(color: _kAccentFade, fontWeight: FontWeight.w500, fontSize: 13),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SignupScreen()),
          ),
          child: const Text(
            AppStrings.signup,
            style: TextStyle(
              color: _kAccent,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              decoration: TextDecoration.underline,
              decorationColor: _kAccent,
            ),
          ),
        ),
      ],
    );
  }
}