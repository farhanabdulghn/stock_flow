import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:untitled/app_routes.dart';
import 'package:untitled/states/stores/auth/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  Future<void> _onLogin() async {
    if (_isSubmitting) return;

    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      _showValidationError();
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await ref.read(authProvider.notifier).login(email, password);

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoute.mainFrame,
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      _showLoginError(_getReadableError(error));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _fillDemoAccount({required String email, required String password}) {
    _emailController.text = email;
    _passwordController.text = password;

    _formKey.currentState?.validate();

    FocusScope.of(context).unfocus();
  }

  String _getReadableError(Object error) {
    return error
        .toString()
        .replaceFirst('Invalid argument(s): ', '')
        .replaceFirst('Bad state: ', '')
        .replaceFirst('Exception: ', '');
  }

  void _showValidationError() {
    _showErrorSnackBar('Lengkapi email dan password terlebih dahulu.');
  }

  void _showLoginError(String message) {
    _showErrorSnackBar(message);
  }

  void _showErrorSnackBar(String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: colorScheme.errorContainer,
          content: Row(
            spacing: 10,
            children: [
              PhosphorIcon(
                PhosphorIconsDuotone.xCircle,
                color: colorScheme.error,
                size: 20,
              ),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) return 'Email wajib diisi';

    final emailPattern = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$');

    if (!emailPattern.hasMatch(email)) return 'Format email tidak valid';

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }

    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final normalStyle = theme.textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
      height: 1.6,
    );

    final linkStyle = theme.textTheme.bodySmall?.copyWith(
      color: colorScheme.primary,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
      decorationColor: colorScheme.primary,
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 42),
                    Column(
                      children: [
                        Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: PhosphorIcon(
                            PhosphorIconsDuotone.package,
                            color: colorScheme.primary,
                            size: 42,
                          ),
                        ),
                        SizedBox(height: 22),
                        Text(
                          'Selamat Datang',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Kelola stok dan transaksi barang dengan lebih mudah.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: AutofillGroup(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Masuk ke Akun',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Masukkan akun Admin atau Operator '
                                  'untuk melanjutkan.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 24),
                                Text(
                                  'Alamat Email',
                                  style: theme.textTheme.labelLarge,
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  enabled: !_isSubmitting,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [
                                    AutofillHints.email,
                                    AutofillHints.username,
                                  ],
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  validator: _emailValidator,
                                  onFieldSubmitted: (_) {
                                    _passwordFocusNode.requestFocus();
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'nama@email.com',
                                    prefixIcon: PhosphorIcon(
                                      PhosphorIconsRegular.envelopeSimple,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 18),
                                Text(
                                  'Password',
                                  style: theme.textTheme.labelLarge,
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  enabled: !_isSubmitting,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  validator: _passwordValidator,
                                  onFieldSubmitted: (_) => _onLogin(),
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan password',
                                    prefixIcon: const PhosphorIcon(
                                      PhosphorIconsRegular.lockKey,
                                      size: 20,
                                    ),
                                    suffixIcon: IconButton(
                                      tooltip: _obscurePassword
                                          ? 'Tampilkan password'
                                          : 'Sembunyikan password',
                                      onPressed: _isSubmitting
                                          ? null
                                          : () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                      icon: PhosphorIcon(
                                        _obscurePassword
                                            ? PhosphorIconsRegular.eyeSlash
                                            : PhosphorIconsRegular.eye,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 22),
                                Text(
                                  'Akun Demo',
                                  style: theme.textTheme.labelLarge,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  spacing: 10,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: _isSubmitting
                                            ? null
                                            : () {
                                                _fillDemoAccount(
                                                  email: 'admin@stockflow.com',
                                                  password: 'admin123',
                                                );
                                              },
                                        icon: PhosphorIcon(
                                          PhosphorIconsRegular.shieldCheck,
                                          size: 18,
                                        ),
                                        label: Text('Admin'),
                                      ),
                                    ),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: _isSubmitting
                                            ? null
                                            : () {
                                                _fillDemoAccount(
                                                  email:
                                                      'operator@stockflow.com',
                                                  password: 'operator123',
                                                );
                                              },
                                        icon: PhosphorIcon(
                                          PhosphorIconsRegular.user,
                                          size: 18,
                                        ),
                                        label: Text('Operator'),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: _isSubmitting ? null : _onLogin,
                                    icon: _isSubmitting
                                        ? SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : PhosphorIcon(
                                            PhosphorIconsRegular.signIn,
                                            size: 20,
                                          ),
                                    label: Text(
                                      _isSubmitting ? 'Memproses...' : 'Masuk',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Text.rich(
                      TextSpan(
                        style: normalStyle,
                        children: [
                          TextSpan(text: 'Dengan masuk, Anda menyetujui '),
                          TextSpan(text: 'Ketentuan Layanan', style: linkStyle),
                          TextSpan(text: ' dan '),
                          TextSpan(text: 'Kebijakan Privasi', style: linkStyle),
                          TextSpan(text: ' kami.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
