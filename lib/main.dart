import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:softech_scratch_n_win/admin/admin_login_screen.dart';
import 'package:softech_scratch_n_win/firebase_options.dart';
import 'package:softech_scratch_n_win/view/registration_screen.dart';
import 'package:softech_scratch_n_win/view/softtac_mania_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SoftroniicsScratchApp());
}

class SoftroniicsScratchApp extends StatelessWidget {
  const SoftroniicsScratchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Softroniics Scratch & Win',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.aBeeZeeTextTheme(),
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/onboard',
      routes: {
        '/': (_) => const RegistrationScreen(),
        '/admin-login': (_) => const AdminLoginScreen(),
        '/onboard': (_) => SoftTacManiaScreen(),
      },
    );
  }
}
