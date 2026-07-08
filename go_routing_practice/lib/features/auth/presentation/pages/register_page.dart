import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Register page — demonstrates context.push() / context.pop() navigation.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please sign in.'),
          backgroundColor: AppColors.success,
        ),
      );
      // pop() goes back to login (pushed via context.push)
      if (context.canPop()) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Account'),
        // canPop() + pop() back navigation
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Text('Join us today', style: AppTextStyles.displayMedium),
                const SizedBox(height: 8),
                const Text(
                  'Create your account to get started',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 40),

                // Name field
                TextFormField(
                  controller: _nameController,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline,
                        color: AppColors.textSecondary),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 16),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined,
                        color: AppColors.textSecondary),
                  ),
                  validator: (v) =>
                      v == null || !v.contains('@') ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline,
                        color: AppColors.textSecondary),
                  ),
                  validator: (v) =>
                      v == null || v.length < 4 ? 'Min 4 characters' : null,
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Create Account'),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?',
                        style: AppTextStyles.bodyMedium),
                    TextButton(
                      onPressed: () {
                        // context.go() replaces the entire stack with login
                        context.go(AppRoutes.login);
                      },
                      child: const Text('Sign In',
                          style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),

                // Router concept callout
                const SizedBox(height: 24),
                _RouterConceptBox(
                  concept: 'context.push() vs context.go()',
                  explanation:
                      'push() adds to stack (back button works)\ngo() replaces entire stack (no back)\n\n'
                      'Register was opened with push() → back returns to login.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RouterConceptBox extends StatelessWidget {
  const _RouterConceptBox({
    required this.concept,
    required this.explanation,
  });

  final String concept;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline,
                  color: AppColors.secondary, size: 16),
              const SizedBox(width: 8),
              Text(concept,
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 8),
          Text(explanation, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
