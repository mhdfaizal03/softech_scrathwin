// admin_login_screen.dart
import 'package:flutter/material.dart';
import 'package:softech_scratch_n_win/admin/dashboard.dart';
import 'package:softech_scratch_n_win/utils/colors.dart';
import 'package:softech_scratch_n_win/utils/custom.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // TODO: move this to remote config / env in production
  final String _adminPassword = 'softroniics@admin123';

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordCtrl.text.trim() == _adminPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;

    final bool isTablet = width >= 700 && width < 1100;
    final bool isDesktop = width >= 1100;
    final bool isWide = isTablet || isDesktop;

    final double horizontalPadding = isDesktop
        ? width * 0.25
        : (isTablet ? 80.0 : 24.0);
    final double verticalPadding = isWide ? 48.0 : 32.0;
    final double maxCardWidth = isDesktop ? 450 : 400;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SoftTac Mania – Admin'),
        centerTitle: !isWide,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxCardWidth),
              child: Material(
                elevation: isWide ? 4 : 2,
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Admin Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'This section is restricted to Softroniics staff.\n'
                          'Please enter the admin password to continue.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 28),

                        // Password field
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Admin Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'Password is required'
                              : null,
                          onFieldSubmitted: (_) => _login(),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        const Divider(height: 24),
                        const SizedBox(height: 8),

                        // Branding – same as other screens
                        Center(child: SoftCampus()),
                      ],
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
