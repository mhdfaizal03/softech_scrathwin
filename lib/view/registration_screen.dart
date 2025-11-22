import 'dart:math';
import 'package:flutter/material.dart';
import 'package:softech_scratch_n_win/models/services/firestore_services.dart';
import 'package:softech_scratch_n_win/utils/colors.dart';
import 'package:softech_scratch_n_win/utils/custom.dart';
import 'scratch_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  final _service = FirestoreService();
  bool _loading = false;

  // 🎨 UI colors (from 2nd code)
  static const Color primaryButtonColor = Color(0xFFE8B975); // gold/orange
  static const Color inputFieldColor = Color(0xFFEFEFEF); // light grey
  static const Color primaryTextColor = Colors.black87;
  static const Color secondaryTextColor = Colors.black54;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final typedName = _nameCtrl.text.trim();
    final typedAge = int.parse(_ageCtrl.text.trim());
    final typedEmail = _emailCtrl.text.trim();
    final typedPhone = _phoneCtrl.text.trim();

    try {
      // 1️⃣ Check if this email OR phone already exists
      final existing = await _service.getEntryByEmailOrPhone(
        typedEmail,
        typedPhone,
      );

      if (existing != null) {
        final bool isExactMatch =
            typedName == existing.name &&
            typedAge == existing.age &&
            typedEmail == existing.email &&
            typedPhone == existing.phone;

        if (!isExactMatch) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Something went wrong. Please enter your details exactly as registered before.',
              ),
            ),
          );
          setState(() => _loading = false);
          return;
        }

        // Existing user with correct details → go to their page
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Welcome back! Loaded your existing Softroniics discount.',
            ),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScratchScreen(
              name: existing.name,
              age: existing.age,
              email: existing.email,
              phone: existing.phone,
              discount: existing.discount,
              code: existing.code,
              alreadyPlayed: true,
            ),
          ),
        );
        return;
      }

      // 2️⃣ New user → generate discount with limit on 25%
      final options = [10, 15, 20, 25];

      // Example: allow only 10 users per day to get 25%
      final canGive25 = await _service.canGiveDiscountToday(25, 10);
      if (!canGive25) {
        options.remove(25);
      }

      options.shuffle();
      final randomDiscount = options.first;

      // 3️⃣ Generate unique code: SOF-2025-XXXX
      final rng = Random();
      final randomNumber = 1000 + rng.nextInt(9000); // 1000–9999
      final code = 'SOF-2025-$randomNumber';

      // 4️⃣ Save new entry
      final entry = await _service.createEntry(
        name: typedName,
        age: typedAge,
        email: typedEmail,
        phone: typedPhone,
        discount: randomDiscount,
        code: code,
      );

      if (!mounted) return;

      // 5️⃣ Navigate with saved data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ScratchScreen(
            name: entry.name,
            age: entry.age,
            email: entry.email,
            phone: entry.phone,
            discount: entry.discount,
            code: entry.code,
            alreadyPlayed: false,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // same bg as 2nd code

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Header Section (from 2nd UI) ---
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "Let's Get You Started",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Fill in your details to unlock your\nscratch card.",
                        style: TextStyle(
                          fontSize: 16,
                          color: secondaryTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // --- Form Fields with same logic as code 1 ---
                    _buildFormSection(
                      title: 'Full Name',
                      hintText: 'Enter your full name',
                      keyboardType: TextInputType.name,
                      controller: _nameCtrl,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    _buildFormSection(
                      title: 'Age',
                      hintText: 'Enter your age',
                      keyboardType: TextInputType.number,
                      controller: _ageCtrl,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        final val = int.tryParse(v);
                        if (val == null || val <= 0) return 'Invalid age';
                        return null;
                      },
                    ),
                    _buildFormSection(
                      title: 'Email ID',
                      hintText: 'Enter your Email ID',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailCtrl,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (!v.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    _buildFormSection(
                      title: 'Contact Number',
                      hintText: 'Enter your mobile number',
                      keyboardType: TextInputType.phone,
                      controller: _phoneCtrl,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (v.trim().length < 10) return 'Too short';
                        return null;
                      },
                      isLastField: true,
                    ),

                    const SizedBox(height: 40),

                    // --- Claim Reward Button (calls _submit) ---
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 3,
                        ),
                        child: _loading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Claim My Reward',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.card_giftcard,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 80),

                    // --- Logos (Bottom Section) ---
                    SoftCampus(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔁 Reusable form section (styled like code 2 but using TextFormField + controllers)
  Widget _buildFormSection({
    required String title,
    required String hintText,
    required TextInputType keyboardType,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool isLastField = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLastField ? 0 : 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: inputFieldColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              style: const TextStyle(color: primaryTextColor),
              decoration:
                  InputDecoration(
                    hintText: '',
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    // we’ll override hint text below using copyWith
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                  ).copyWith(
                    hintText: hintText,
                    hintStyle: const TextStyle(color: secondaryTextColor),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
