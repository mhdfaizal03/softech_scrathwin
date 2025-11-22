// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:softech_scratch_n_win/models/services/firestore_services.dart';
// import 'package:softech_scratch_n_win/utils/colors.dart';
// import 'package:softech_scratch_n_win/utils/custom.dart';
// import 'scratch_screen.dart';

// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({super.key});

//   @override
//   State<RegistrationScreen> createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _ageCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _phoneCtrl = TextEditingController();

//   final _service = FirestoreService();
//   bool _loading = false;

//   // 🎨 UI colors (from 2nd code)
//   static const Color primaryButtonColor = Color(0xFFE8B975); // gold/orange
//   static const Color inputFieldColor = Color(0xFFEFEFEF); // light grey
//   static const Color primaryTextColor = Colors.black87;
//   static const Color secondaryTextColor = Colors.black54;

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _ageCtrl.dispose();
//     _emailCtrl.dispose();
//     _phoneCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _loading = true);

//     final typedName = _nameCtrl.text.trim();
//     final typedAge = int.parse(_ageCtrl.text.trim());
//     final typedEmail = _emailCtrl.text.trim();
//     final typedPhone = _phoneCtrl.text.trim();

//     try {
//       // 1️⃣ Check if this email OR phone already exists
//       final existing = await _service.getEntryByEmailOrPhone(
//         typedEmail,
//         typedPhone,
//       );

//       if (existing != null) {
//         final bool isExactMatch =
//             typedName == existing.name &&
//             typedAge == existing.age &&
//             typedEmail == existing.email &&
//             typedPhone == existing.phone;

//         if (!isExactMatch) {
//           if (!mounted) return;
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'Something went wrong. Please enter your details exactly as registered before.',
//               ),
//             ),
//           );
//           setState(() => _loading = false);
//           return;
//         }

//         // Existing user with correct details → go to their page
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'Welcome back! Loaded your existing Softroniics discount.',
//             ),
//           ),
//         );

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ScratchScreen(
//               name: existing.name,
//               age: existing.age,
//               email: existing.email,
//               phone: existing.phone,
//               discount: existing.discount,
//               code: existing.code,
//               alreadyPlayed: true,
//             ),
//           ),
//         );
//         return;
//       }

//       // 2️⃣ New user → generate discount with limit on 25%
//       final options = [10, 15, 20, 25];

//       // Example: allow only 10 users per day to get 25%
//       final canGive25 = await _service.canGiveDiscountToday(25, 10);
//       if (!canGive25) {
//         options.remove(25);
//       }

//       options.shuffle();
//       final randomDiscount = options.first;

//       // 3️⃣ Generate unique code: SOF-2025-XXXX
//       final rng = Random();
//       final randomNumber = 1000 + rng.nextInt(9000); // 1000–9999
//       final code = 'SOF-2025-$randomNumber';

//       // 4️⃣ Save new entry
//       final entry = await _service.createEntry(
//         name: typedName,
//         age: typedAge,
//         email: typedEmail,
//         phone: typedPhone,
//         discount: randomDiscount,
//         code: code,
//       );

//       if (!mounted) return;

//       // 5️⃣ Navigate with saved data
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ScratchScreen(
//             name: entry.name,
//             age: entry.age,
//             email: entry.email,
//             phone: entry.phone,
//             discount: entry.discount,
//             code: entry.code,
//             alreadyPlayed: false,
//           ),
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final double width = size.width;

//     // 🔹 Simple responsive breakpoints
//     final bool isTablet = width >= 700 && width < 1100;
//     final bool isDesktop = width >= 1100;
//     final bool isWide = isTablet || isDesktop;

//     // 🔹 Adaptive paddings & text sizes
//     final double horizontalPadding = isDesktop
//         ? width * 0.2
//         : (isTablet ? 48.0 : 24.0);

//     final double topBottomPadding = isWide ? 48.0 : 32.0;

//     final double headingFontSize = isDesktop ? 30 : (isTablet ? 28 : 26);

//     final double subtitleFontSize = isDesktop ? 18 : 16;

//     return Scaffold(
//       backgroundColor: Colors.white, // same bg

//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(
//               horizontal: horizontalPadding,
//               vertical: topBottomPadding,
//             ),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(maxWidth: isDesktop ? 650 : 500),
//               child: Material(
//                 elevation: isWide ? 4 : 0,
//                 borderRadius: BorderRadius.circular(isWide ? 16 : 0),
//                 color: Colors.white,
//                 child: Padding(
//                   padding: EdgeInsets.all(isWide ? 24.0 : 0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // --- Header Section ---
//                         const SizedBox(height: 20),
//                         Center(
//                           child: Text(
//                             "Let's Get You Started",
//                             style: TextStyle(
//                               fontSize: headingFontSize,
//                               fontWeight: FontWeight.bold,
//                               color: primaryTextColor,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             "Fill in your details to unlock your\nscratch card.",
//                             style: TextStyle(
//                               fontSize: subtitleFontSize,
//                               color: secondaryTextColor,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                         const SizedBox(height: 40),

//                         // --- Form Fields (same logic) ---
//                         _buildFormSection(
//                           title: 'Full Name',
//                           hintText: 'Enter your full name',
//                           keyboardType: TextInputType.name,
//                           controller: _nameCtrl,
//                           validator: (v) =>
//                               v == null || v.trim().isEmpty ? 'Required' : null,
//                         ),
//                         _buildFormSection(
//                           title: 'Age',
//                           hintText: 'Enter your age',
//                           keyboardType: TextInputType.number,
//                           controller: _ageCtrl,
//                           validator: (v) {
//                             if (v == null || v.trim().isEmpty) {
//                               return 'Required';
//                             }
//                             final val = int.tryParse(v);
//                             if (val == null || val <= 0) {
//                               return 'Invalid age';
//                             }
//                             return null;
//                           },
//                         ),
//                         _buildFormSection(
//                           title: 'Email ID',
//                           hintText: 'Enter your Email ID',
//                           keyboardType: TextInputType.emailAddress,
//                           controller: _emailCtrl,
//                           validator: (v) {
//                             if (v == null || v.trim().isEmpty) {
//                               return 'Required';
//                             }
//                             if (!v.contains('@')) {
//                               return 'Invalid email';
//                             }
//                             return null;
//                           },
//                         ),
//                         _buildFormSection(
//                           title: 'Contact Number',
//                           hintText: 'Enter your mobile number',
//                           keyboardType: TextInputType.phone,
//                           controller: _phoneCtrl,
//                           validator: (v) {
//                             if (v == null || v.trim().isEmpty) {
//                               return 'Required';
//                             }
//                             if (v.trim().length < 10) {
//                               return 'Too short';
//                             }
//                             return null;
//                           },
//                           isLastField: true,
//                         ),

//                         const SizedBox(height: 40),

//                         // --- Claim Reward Button (calls _submit) ---
//                         SizedBox(
//                           width: double.infinity,
//                           height: 55,
//                           child: ElevatedButton(
//                             onPressed: _loading ? null : _submit,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.buttonColor,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               elevation: 3,
//                             ),
//                             child: _loading
//                                 ? const SizedBox(
//                                     height: 24,
//                                     width: 24,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white,
//                                       ),
//                                     ),
//                                   )
//                                 : Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: const [
//                                       Text(
//                                         'Claim My Reward',
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       SizedBox(width: 8),
//                                       Icon(
//                                         Icons.card_giftcard,
//                                         color: Colors.white,
//                                         size: 20,
//                                       ),
//                                     ],
//                                   ),
//                           ),
//                         ),

//                         const SizedBox(height: 80),

//                         // --- Logos (Bottom Section) ---
//                         SoftCampus(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // 🔁 Reusable form section (same logic, just styled)
//   Widget _buildFormSection({
//     required String title,
//     required String hintText,
//     required TextInputType keyboardType,
//     required TextEditingController controller,
//     String? Function(String?)? validator,
//     bool isLastField = false,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: isLastField ? 0 : 20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: primaryTextColor,
//             ),
//           ),
//           const SizedBox(height: 8),
//           TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             validator: validator,
//             style: const TextStyle(color: primaryTextColor),
//             decoration: InputDecoration(
//               hintText: hintText,
//               filled: true,
//               fillColor: Colors.grey.shade300,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 15,
//                 vertical: 15,
//               ),
//               hintStyle: const TextStyle(color: secondaryTextColor),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
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
  final _qualificationCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  final _service = FirestoreService();
  bool _loading = false;

  // 🎨 UI colors
  static const Color primaryButtonColor = Color(0xFFE8B975); // gold/orange
  static const Color inputFieldColor = Color(0xFFEFEFEF); // light grey
  static const Color primaryTextColor = Colors.black87;
  static const Color secondaryTextColor = Colors.black54;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qualificationCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final typedName = _nameCtrl.text.trim();
    final typedQualification = _qualificationCtrl.text.trim();
    final typedEmail = _emailCtrl.text.trim();

    // Normalize phone → keep only digits (for consistent saving)
    final rawPhone = _phoneCtrl.text.trim();
    final typedPhone = rawPhone.replaceAll(RegExp(r'\D'), '');

    try {
      // 1️⃣ Check if this email OR phone already exists
      final existing = await _service.getEntryByEmailOrPhone(
        typedEmail,
        typedPhone,
      );

      if (existing != null) {
        // Exact match check (includes qualification – you can drop that if needed)
        final bool isExactMatch =
            typedName == existing.name &&
            typedQualification == existing.qualification &&
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
        qualification: typedQualification,
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
    final size = MediaQuery.of(context).size;
    final double width = size.width;

    // 🔹 Simple responsive breakpoints
    final bool isTablet = width >= 700 && width < 1100;
    final bool isDesktop = width >= 1100;
    final bool isWide = isTablet || isDesktop;

    // 🔹 Adaptive paddings & text sizes
    final double horizontalPadding = isDesktop
        ? width * 0.2
        : (isTablet ? 48.0 : 24.0);

    final double topBottomPadding = isWide ? 48.0 : 32.0;

    final double headingFontSize = isDesktop ? 30 : (isTablet ? 28 : 26);

    final double subtitleFontSize = isDesktop ? 18 : 16;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: topBottomPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isDesktop ? 650 : 500),
              child: Material(
                elevation: isWide ? 4 : 0,
                borderRadius: BorderRadius.circular(isWide ? 16 : 0),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(isWide ? 24.0 : 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            "Let's Get You Started",
                            style: TextStyle(
                              fontSize: headingFontSize,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Fill in your details to unlock your\nscratch card.",
                            style: TextStyle(
                              fontSize: subtitleFontSize,
                              color: secondaryTextColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // 🔹 Full Name
                        _buildFormSection(
                          title: 'Full Name',
                          hintText: 'Enter your full name',
                          keyboardType: TextInputType.name,
                          controller: _nameCtrl,
                          validator: _validateName,
                        ),

                        // 🔹 Qualification / Profession
                        _buildFormSection(
                          title: 'Qualification / Profession',
                          hintText: 'e.g. BSc Computer Science, Designer',
                          keyboardType: TextInputType.text,
                          controller: _qualificationCtrl,
                          validator: _validateQualification,
                        ),

                        // 🔹 Email
                        _buildFormSection(
                          title: 'Email ID',
                          hintText: 'Enter your Email ID',
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailCtrl,
                          validator: _validateEmail,
                        ),

                        // 🔹 Phone
                        _buildFormSection(
                          title: 'Contact Number',
                          hintText: 'Enter your mobile number',
                          keyboardType: TextInputType.phone,
                          controller: _phoneCtrl,
                          validator: _validatePhone,
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
        ),
      ),
    );
  }

  // 🔁 Reusable form section
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
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(color: primaryTextColor),
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.grey.shade300,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              hintStyle: const TextStyle(color: secondaryTextColor),
            ),
          ),
        ],
      ),
    );
  }

  // 🔒 Regex & validation helpers

  /// Name: letters + spaces, min 3 chars
  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final value = v.trim();
    final regex = RegExp(r'^[a-zA-Z\s]{3,}$');
    if (!regex.hasMatch(value)) {
      return 'Enter a valid name (only letters & spaces, min 3 chars)';
    }
    return null;
  }

  /// Qualification: at least 2 chars, allow letters, numbers, spaces, basic symbols
  String? _validateQualification(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final value = v.trim();
    if (value.length < 2) return 'Too short';
    final regex = RegExp(r'^[a-zA-Z0-9\s\.\-&/,]{2,}$');
    if (!regex.hasMatch(value)) {
      return 'Use letters, numbers & basic symbols only';
    }
    return null;
  }

  /// Email validation via regex
  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final value = v.trim();
    final regex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Phone: 10-digit Indian mobile, starting 6-9
  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';

    // strip spaces, dashes, +91 etc – keep only digits
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      return 'Enter a 10-digit mobile number';
    }

    final regex = RegExp(r'^[6-9]\d{9}$');
    if (!regex.hasMatch(digits)) {
      return 'Enter a valid Indian mobile number';
    }
    return null;
  }
}
