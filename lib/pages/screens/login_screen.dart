import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:untitled/app_routes.dart';
import 'package:untitled/states/stores/auth/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;

      ref.read(authProvider.notifier).login(email, password);

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoute.mainFrame,
        (route) => false,
      );
    } else {
      final mq = MediaQuery.of(context);
      final size = mq.size;
      final width = size.width * 0.24;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.up,
          backgroundColor: Color(0xFFFEF2F2),
          margin: EdgeInsets.only(
            bottom: size.height - 180,
            left: width,
            right: width,
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(color: Color(0xFFB91C1C).withValues(alpha: 0.1)),
          ),
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              PhosphorIcon(
                PhosphorIconsDuotone.xCircle,
                color: Color(0xFFB91C1C),
                size: 16,
              ),
              Text(
                'Isi form yang dibutuhkan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Color(0xFFB91C1C),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final linkStyle = GoogleFonts.plusJakartaSans(
      fontWeight: FontWeight.w600,
      color: Color(0xFF3B82F6),
      decoration: TextDecoration.underline,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 139, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                  decoration: InputDecoration(hintText: 'Alamat Email'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Email wajib diisi' : null,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 18,
                        color: const Color(0xFF71747D),
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onLogin,
                    child: Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 41),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Dengan membuat akun atau masuk, Anda setuju dengan ',
              ),
              TextSpan(text: 'Ketentuan Layanan', style: linkStyle),
              TextSpan(text: ' dan '),
              TextSpan(text: 'Kebijakan Privasi', style: linkStyle),
              TextSpan(text: ' kami'),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
