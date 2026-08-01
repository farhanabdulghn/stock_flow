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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  void _onLogin() {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      _showValidationError();
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    ref.read(authProvider.notifier).login(email, password);

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoute.mainFrame,
      (route) => false,
    );
  }

  void _showValidationError() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: colorScheme.errorContainer,
          content: Row(
            children: [
              PhosphorIcon(
                PhosphorIconsDuotone.xCircle,
                color: colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Lengkapi email dan password terlebih dahulu.',
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

    if (email.isEmpty) {
      return 'Email wajib diisi';
    }

    final emailPattern = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$');

    if (!emailPattern.hasMatch(email)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 42),

                    _LoginHeader(colorScheme: colorScheme),

                    const SizedBox(height: 40),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
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
                                const SizedBox(height: 6),
                                Text(
                                  'Masukkan email dan password untuk melanjutkan.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                Text(
                                  'Alamat Email',
                                  style: theme.textTheme.labelLarge,
                                ),
                                const SizedBox(height: 8),

                                TextFormField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
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

                                const SizedBox(height: 18),

                                Text(
                                  'Password',
                                  style: theme.textTheme.labelLarge,
                                ),
                                const SizedBox(height: 8),

                                TextFormField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  validator: _passwordValidator,
                                  onFieldSubmitted: (_) {
                                    _onLogin();
                                  },
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
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
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

                                const SizedBox(height: 24),

                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.icon(
                                    onPressed: _onLogin,
                                    icon: const PhosphorIcon(
                                      PhosphorIconsRegular.signIn,
                                      size: 20,
                                    ),
                                    label: const Text('Masuk'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    _LoginTerms(colorScheme: colorScheme),
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

class _LoginHeader extends StatelessWidget {
  const _LoginHeader({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
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
        const SizedBox(height: 22),
        Text(
          'Selamat Datang',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Kelola stok dan transaksi barang dengan lebih mudah.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _LoginTerms extends StatelessWidget {
  const _LoginTerms({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

    return Text.rich(
      TextSpan(
        style: normalStyle,
        children: [
          const TextSpan(text: 'Dengan masuk, Anda menyetujui '),
          TextSpan(text: 'Ketentuan Layanan', style: linkStyle),
          const TextSpan(text: ' dan '),
          TextSpan(text: 'Kebijakan Privasi', style: linkStyle),
          const TextSpan(text: ' kami.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
