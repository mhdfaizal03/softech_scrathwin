// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:scratcher/scratcher.dart';
// import 'package:url_launcher/url_launcher.dart';

// // --- New UI constants (from 2nd design) ---
// const Color kBackgroundColor = Color(0xFFF0F0F0);
// const Color kPrimaryTextColor = Color(0xFF333333);
// const Color kCardColor = Color(0xFFF9A825); // gold / orange

// class ScratchScreen extends StatefulWidget {
//   final String name;
//   final int age;
//   final String email;
//   final String phone;
//   final int discount;
//   final String code;
//   final bool alreadyPlayed;

//   const ScratchScreen({
//     super.key,
//     required this.name,
//     required this.age,
//     required this.email,
//     required this.phone,
//     required this.discount,
//     required this.code,
//     this.alreadyPlayed = false,
//   });

//   @override
//   State<ScratchScreen> createState() => _ScratchScreenState();
// }

// // Animation mixin kept as-is
// class _ScratchScreenState extends State<ScratchScreen>
//     with SingleTickerProviderStateMixin {
//   bool _revealed = false;

//   static const String offerExpiryText = 'Offer valid until 30 Nov 2025.';
//   static const Color primaryPurple = Color(0xFF673AB7);

//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 0.9,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

//     _opacityAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(_controller);

//     if (widget.alreadyPlayed) {
//       _revealed = true;
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _controller.forward();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   // WhatsApp logic unchanged
//   Future<void> _openWhatsApp() async {
//     const String phoneNumber = '919876543210';

//     final message =
//         'Hi Softroniics, I got $_discount% discount from the Scratch & Win campaign. '
//         'My name: $_name, email: $_email, discount code: $_code.';

//     final uri = Uri.parse(
//       'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
//     );

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not open WhatsApp.')),
//         );
//       }
//     }
//   }

//   String get _name => widget.name;
//   int get _discount => widget.discount;
//   String get _email => widget.email;
//   String get _code => widget.code;

//   // Gift icon styled like second UI
//   Widget _buildGiftIcon({double size = 70}) {
//     return const Icon(Icons.card_giftcard, color: Color(0xFFE8B975), size: 70);
//   }

//   // Logos row like second UI
//   Widget _buildLogos() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: const [
//         Text(
//           'Softroniics',
//           style: TextStyle(
//             color: Color(0xFF9C27B0),
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//           ),
//         ),
//         SizedBox(width: 20),
//         Text(
//           'The Animation\nCampus',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Color(0xFF9C27B0),
//             fontWeight: FontWeight.bold,
//             fontSize: 14,
//             height: 1.1,
//           ),
//         ),
//       ],
//     );
//   }

//   // 🔹 New "won" UI but logic same
//   Widget _buildDiscountContent(BuildContext context) {
//     return FadeTransition(
//       opacity: _opacityAnimation,
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Header text (like WonScreen)
//             const Text(
//               "Congratulations!",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//                 color: kPrimaryTextColor,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 "You unlocked a special training discount from\nSoftroniics and The Animation Campus",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16, color: kPrimaryTextColor),
//               ),
//             ),
//             const SizedBox(height: 30),

//             // Main white card (from WonScreen design)
//             Container(
//               width: 300,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Gift circle
//                   Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: Colors.yellow[100]?.withOpacity(0.5),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Center(child: _buildGiftIcon(size: 60)),
//                   ),
//                   const SizedBox(height: 16),
//                   // Dynamic discount text
//                   Text(
//                     'You Won\n$_discount% Off!',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: kPrimaryTextColor,
//                       height: 1.1,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Dynamic code
//                   Text(
//                     'CODE: $_code',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // WhatsApp + Back buttons (logic same, only style changed)
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton.icon(
//                 onPressed: _openWhatsApp,
//                 icon: const Icon(CupertinoIcons.share),
//                 label: const Text('Share on WhatsApp to Claim'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade600,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   elevation: 3,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: OutlinedButton(
//                 onPressed: () {
//                   Navigator.popUntil(context, (route) => route.isFirst);
//                 },
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: primaryPurple,
//                   side: BorderSide(color: primaryPurple.withOpacity(0.5)),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//                 child: const Text(
//                   'Back to Home',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Instructions + expiry (kept)
//             const Text(
//               'Show this screen, your email/phone, or discount code '
//               'to the Softroniics team to claim your offer.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               offerExpiryText,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//             ),

//             const SizedBox(height: 24),
//             _buildLogos(),
//           ],
//         ),
//       ),
//     );
//   }

//   // 🔹 New scratch UI (matches ScratchCardScreen)
//   // Widget for the initial scratchable card
//   Widget _buildScratchCard(BuildContext context) {
//     // This is the content that will be REVEALED as you scratch
//     final scratchContent = Container(
//       width: 300,
//       height: 300,
//       decoration: BoxDecoration(
//         color: Colors.white, // revealed card background
//         borderRadius: BorderRadius.circular(30.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Gift icon
//           Container(
//             width: 90,
//             height: 90,
//             decoration: BoxDecoration(
//               color: Colors.yellow[100]?.withOpacity(0.6),
//               shape: BoxShape.circle,
//             ),
//             child: Center(child: _buildGiftIcon(size: 60)),
//           ),
//           const SizedBox(height: 16),
//           // Discount text
//           Text(
//             'You Won\n$_discount% Off!',
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: kPrimaryTextColor,
//               height: 1.2,
//             ),
//           ),
//           const SizedBox(height: 10),
//           // Code text
//           Text(
//             'CODE: $_code',
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Text(
//           "Your Scratch Card\nIs Ready!",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: kPrimaryTextColor,
//           ),
//         ),
//         const SizedBox(height: 40),

//         // 🔥 Scratcher with discount INSIDE the card
//         Scratcher(
//           brushSize: 40,
//           threshold: 50,
//           // This is the SCRATCH LAYER color (what you see before scratching)
//           color: kCardColor, // gold overlay
//           onThreshold: () {
//             setState(() {
//               _revealed = true;
//             });
//             _controller.forward();

//             if (mounted) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('You got $_discount% OFF! Use code $_code.'),
//                 ),
//               );
//             }
//           },
//           // This is what appears UNDER the scratch
//           child: scratchContent,
//         ),

//         const SizedBox(height: 30),

//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 40.0),
//           child: Text(
//             "Scratch to reveal your exclusive Softroniics\nand The Animation Campus offer.",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14, color: kPrimaryTextColor),
//           ),
//         ),

//         const SizedBox(height: 40),
//         _buildLogos(),
//         const SizedBox(height: 30),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool canShowActions = _revealed || widget.alreadyPlayed;

//     return Scaffold(
//       backgroundColor: kBackgroundColor,
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 420),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.arrow_back_ios,
//                           color: Colors.black54,
//                         ),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     if (canShowActions)
//                       _buildDiscountContent(context)
//                     else
//                       _buildScratchCard(context),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:math'; // for pi

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import 'package:softech_scratch_n_win/utils/colors.dart';
import 'package:softech_scratch_n_win/utils/custom.dart';
import 'package:url_launcher/url_launcher.dart';

// --- New UI constants (from 2nd design) ---
const Color kBackgroundColor = Color(0xFFF0F0F0);
const Color kPrimaryTextColor = Color(0xFF333333);
const Color kCardColor = Color(0xFFF9A825); // gold / orange

class ScratchScreen extends StatefulWidget {
  final String name;
  final int age;
  final String email;
  final String phone;
  final int discount;
  final String code;
  final bool alreadyPlayed;

  const ScratchScreen({
    super.key,
    required this.name,
    required this.age,
    required this.email,
    required this.phone,
    required this.discount,
    required this.code,
    this.alreadyPlayed = false,
  });

  @override
  State<ScratchScreen> createState() => _ScratchScreenState();
}

// Animation mixin kept as-is
class _ScratchScreenState extends State<ScratchScreen>
    with SingleTickerProviderStateMixin {
  bool _revealed = false;

  static const String offerExpiryText = 'Offer valid until 30 Nov 2025.';
  static const Color primaryPurple = Color(0xFF673AB7);

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // 🎉 Confetti controllers (left + right)
  late ConfettiController _leftConfetti;
  late ConfettiController _rightConfetti;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    // confetti runs for 2 seconds each time we play
    _leftConfetti = ConfettiController(duration: const Duration(seconds: 2));
    _rightConfetti = ConfettiController(duration: const Duration(seconds: 2));

    if (widget.alreadyPlayed) {
      _revealed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.forward();
        // 🎉 also show confetti if user already has claim page
        _leftConfetti.play();
        _rightConfetti.play();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _leftConfetti.dispose();
    _rightConfetti.dispose();
    super.dispose();
  }

  // WhatsApp logic unchanged
  Future<void> _openWhatsApp() async {
    const String phoneNumber = '919876543210';

    final message =
        'Hi Softroniics, I got $_discount% discount from the Scratch & Win campaign. '
        'My name: $_name, email: $_email, discount code: $_code.';

    final uri = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp.')),
        );
      }
    }
  }

  String get _name => widget.name;
  int get _discount => widget.discount;
  String get _email => widget.email;
  String get _code => widget.code;

  // Gift icon styled like second UI
  Widget _buildGiftIcon({double size = 70}) {
    // size parameter kept for compatibility, but core UI same
    return Icon(
      Icons.card_giftcard,
      color: const Color(0xFFE8B975),
      size: size,
    );
  }

  // Logos row like second UI
  Widget _buildLogos() {
    return SoftCampus();
  }

  // 🔹 "won" UI – logic same as before, only confetti is external
  Widget _buildDiscountContent(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Congratulations!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "You unlocked a special training discount from\nSoftroniics and The Animation Campus",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: kPrimaryTextColor),
                ),
              ),
              const SizedBox(height: 30),

              Container(
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gift circle
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.yellow[100]?.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: _buildGiftIcon(size: 60)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You Won\n$_discount% Off!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryTextColor,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'CODE: $_code',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey[400]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Share', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 10),
                            Icon(CupertinoIcons.share),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: _openWhatsApp,
                        icon: Icon(CupertinoIcons.down_arrow),
                        label: const Text('Download'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 100),
              _buildLogos(),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 scratch UI – discount inside card (your current version)
  Widget _buildScratchCard(BuildContext context) {
    final scratchContent = Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gift icon
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.yellow[100]?.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Center(child: _buildGiftIcon(size: 60)),
          ),
          const SizedBox(height: 16),
          Text(
            'You Won\n$_discount% Off!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kPrimaryTextColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'CODE: $_code',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Your Scratch Card\nIs Ready!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: kPrimaryTextColor,
          ),
        ),
        const SizedBox(height: 40),

        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(30),
          child: Scratcher(
            brushSize: 40,
            threshold: 50,
            color: AppColors.buttonColor,
            onThreshold: () {
              setState(() {
                _revealed = true;
              });
              _controller.forward();

              // 🎉 trigger confetti when claim is revealed
              _leftConfetti.play();
              _rightConfetti.play();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You got $_discount% OFF! Use code $_code.'),
                  ),
                );
              }
            },
            child: scratchContent,
          ),
        ),

        const SizedBox(height: 30),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            "Scratch to reveal your exclusive Softroniics\nand The Animation Campus offer.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: kPrimaryTextColor),
          ),
        ),

        const SizedBox(height: 40),
        _buildLogos(),
        const SizedBox(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canShowActions = _revealed || widget.alreadyPlayed;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // main content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        if (canShowActions)
                          _buildDiscountContent(context)
                        else
                          _buildScratchCard(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 🎉 Left confetti (shooting to the right)
            Align(
              alignment: Alignment.topLeft,
              child: ConfettiWidget(
                confettiController: _leftConfetti,
                blastDirection: 0, // 0 rad → right
                emissionFrequency: 0.010,
                numberOfParticles: 70,
                gravity: 0.15,
              ),
            ),

            // 🎉 Right confetti (shooting to the left)
            Align(
              alignment: Alignment.topRight,
              child: ConfettiWidget(
                confettiController: _rightConfetti,
                blastDirection: pi, // π rad → left
                emissionFrequency: 0.010,
                numberOfParticles: 70,
                gravity: 0.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
