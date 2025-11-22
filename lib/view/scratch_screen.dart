// import 'dart:io';
// import 'dart:math'; // for pi
// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:confetti/confetti.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart'; // kIsWeb
// import 'package:flutter/rendering.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:scratcher/scratcher.dart';
// import 'package:softech_scratch_n_win/utils/colors.dart';
// import 'package:softech_scratch_n_win/utils/custom.dart';

// const Color kPrimaryTextColor = Color(0xFF333333);

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

// class _ScratchScreenState extends State<ScratchScreen>
//     with SingleTickerProviderStateMixin {
//   bool _revealed = false;

//   static const String offerExpiryText = 'Offer valid until 30 Nov 2025.';

//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _opacityAnimation;

//   // 🎉 Confetti controllers (left + right)
//   late ConfettiController _leftConfetti;
//   late ConfettiController _rightConfetti;

//   // For capturing the coupon as an image
//   final GlobalKey _couponKey = GlobalKey();

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

//     _leftConfetti = ConfettiController(duration: const Duration(seconds: 2));
//     _rightConfetti = ConfettiController(duration: const Duration(seconds: 2));

//     if (widget.alreadyPlayed) {
//       _revealed = true;
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _controller.forward();
//         _leftConfetti.play();
//         _rightConfetti.play();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _leftConfetti.dispose();
//     _rightConfetti.dispose();
//     super.dispose();
//   }

//   String get _name => widget.name;
//   int get _discount => widget.discount;
//   String get _email => widget.email;
//   String get _code => widget.code;

//   Future<void> _downloadCouponImage() async {
//     try {
//       final boundary =
//           _couponKey.currentContext?.findRenderObject()
//               as RenderRepaintBoundary?;

//       if (boundary == null) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Unable to capture coupon. Please try again.'),
//             ),
//           );
//         }
//         return;
//       }

//       // Render widget to image
//       final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//       final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       final Uint8List pngBytes = byteData!.buffer.asUint8List();

//       if (kIsWeb) {
//         // 🌐 WEB:
//         // Direct "save to gallery" is not supported.
//         // Best cross-platform behaviour: share the code as text.
//         final message =
//             'Hi Softroniics,\n'
//             'I got $_discount% discount from the Scratch & Win campaign.\n\n'
//             'Name: $_name\n'
//             'Email: $_email\n'
//             'Phone: ${widget.phone}\n'
//             'Discount code: $_code\n';

//         await Share.share(
//           message,
//           subject: 'Softroniics Scratch & Win Discount',
//         );

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'On web, please take a screenshot to save the coupon image.',
//               ),
//             ),
//           );
//         }
//       } else {
//         // 📱 MOBILE / DESKTOP APP: save to gallery
//         final result = await ImageGallerySaver.saveImage(
//           pngBytes,
//           name: 'softroniics_coupon_${widget.code}',
//           quality: 100,
//         );

//         if (mounted) {
//           final isSuccess =
//               (result['isSuccess'] == true ||
//               result['success'] ==
//                   true); // different versions use different keys

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 isSuccess
//                     ? 'Coupon image saved to your gallery.'
//                     : 'Could not save coupon image. Please try again.',
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Could not download coupon. Please try again.'),
//         ),
//       );
//     }
//   }

//   // 🎟 Shareable coupon card (this is what gets captured)
//   Widget _buildCouponCard() {
//     return RepaintBoundary(
//       key: _couponKey,
//       child: Container(
//         width: 300,
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//               color: Colors.black.withOpacity(0.08),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // top icon
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Color(0xFFFFF3E0),
//               ),
//               child: const Icon(
//                 Icons.card_giftcard,
//                 size: 32,
//                 color: Colors.orange,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // main title
//             Text(
//               'You Won',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey.shade800,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '${widget.discount}% OFF!',
//               style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),

//             // ID / code
//             SelectableText(
//               'ID: ${widget.code}',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey.shade600,
//                 letterSpacing: 0.5,
//               ),
//             ),

//             const SizedBox(height: 24),

//             // name + email
//             Text(
//               widget.name,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               widget.email,
//               style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 👇 Capture coupon card as image and share
//   // Future<void> _shareCouponImage() async {
//   //   try {
//   //     final boundary =
//   //         _couponKey.currentContext?.findRenderObject()
//   //             as RenderRepaintBoundary?;

//   //     if (boundary == null) {
//   //       if (mounted) {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //           const SnackBar(
//   //             content: Text('Unable to capture coupon. Please try again.'),
//   //           ),
//   //         );
//   //       }
//   //       return;
//   //     }

//   //     // Render the widget to an image
//   //     final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//   //     final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//   //     final Uint8List pngBytes = byteData!.buffer.asUint8List();

//   //     if (kIsWeb) {
//   //       // 🌐 WEB: share TEXT (image file sharing is not supported on web)
//   //       final message =
//   //           'Hi Softroniics,\n'
//   //           'I got $_discount% discount from the Scratch & Win campaign.\n\n'
//   //           'Name: $_name\n'
//   //           'Email: $_email\n'
//   //           'Phone: ${widget.phone}\n'
//   //           'Discount code: $_code\n';

//   //       await Share.share(
//   //         message,
//   //         subject: 'Softroniics Scratch & Win Discount',
//   //       );
//   //     } else {
//   //       // 📱 MOBILE / DESKTOP: share coupon PNG as file
//   //       final xFile = XFile.fromData(
//   //         pngBytes,
//   //         mimeType: 'image/png',
//   //         name: 'softroniics_coupon_${widget.code}.png',
//   //       );

//   //       await Share.shareXFiles(
//   //         [xFile],
//   //         text: 'My Softroniics Scratch & Win discount coupon',
//   //         subject: 'Softroniics Discount Coupon',
//   //       );
//   //     }
//   //   } catch (e) {
//   //     if (!mounted) return;
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text('Could not share coupon. Please try again.'),
//   //       ),
//   //     );
//   //   }
//   // }

//   Future<void> _shareCouponImage() async {
//     try {
//       final boundary =
//           _couponKey.currentContext?.findRenderObject()
//               as RenderRepaintBoundary?;

//       if (boundary == null) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Unable to capture coupon. Please try again.'),
//             ),
//           );
//         }
//         return;
//       }

//       // Render the widget to an image
//       final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//       final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       final Uint8List pngBytes = byteData!.buffer.asUint8List();

//       // 🔹 Common message used for both web + app
//       final message =
//           'Hi Softroniics,\n'
//           'I got $_discount% discount from the Scratch & Win campaign.\n\n'
//           'Name: $_name\n'
//           'Email: $_email\n'
//           'Phone: ${widget.phone}\n'
//           'Discount code: $_code\n';

//       if (kIsWeb) {
//         // 🌐 WEB: cannot attach files reliably, so share TEXT only
//         await Share.share(
//           message,
//           subject: 'Softroniics Scratch & Win Discount',
//         );
//       } else {
//         // 📱 MOBILE / DESKTOP: share coupon PNG as file + the same message
//         final xFile = XFile.fromData(
//           pngBytes,
//           mimeType: 'image/png',
//           name: 'softroniics_coupon_${widget.code}.png',
//         );

//         await Share.shareXFiles(
//           [xFile],
//           text: message,
//           subject: 'Softroniics Scratch & Win Discount',
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Could not share coupon. Please try again.'),
//         ),
//       );
//     }
//   }

//   Widget _buildGiftIcon({double size = 70}) {
//     return Icon(
//       Icons.card_giftcard,
//       color: const Color(0xFFE8B975),
//       size: size,
//     );
//   }

//   Widget _buildLogos() {
//     return SoftCampus(); // your custom widget
//   }

//   // 🔹 "won" UI – shown after scratch / if alreadyPlayed
//   Widget _buildDiscountContent(BuildContext context) {
//     return FadeTransition(
//       opacity: _opacityAnimation,
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 10),
//               const Text(
//                 "Congratulations!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: kPrimaryTextColor,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Text(
//                   "You unlocked a special training discount from\nSoftroniics and The Animation Campus",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: kPrimaryTextColor),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // 🎟 Coupon card (captured for sharing)
//               _buildCouponCard(),
//               const SizedBox(height: 12),
//               Text(
//                 offerExpiryText,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),

//               const SizedBox(height: 32),

//               Row(
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       height: 55,
//                       child: ElevatedButton(
//                         onPressed: _shareCouponImage,
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: Colors.black,
//                           backgroundColor: Colors.white,
//                           side: BorderSide(color: Colors.grey[300]!),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Text(
//                               'Share Coupon',
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             SizedBox(width: 10),
//                             Icon(CupertinoIcons.share),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: SizedBox(
//                       height: 55,
//                       child: OutlinedButton(
//                         onPressed: () => _downloadCouponImage(),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.buttonColor,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             side: BorderSide.none,
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           elevation: 3,
//                         ),

//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Text('Download', style: TextStyle(fontSize: 16)),
//                             SizedBox(width: 10),
//                             Icon(CupertinoIcons.arrow_down_to_line),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 24),
//               const Text(
//                 'Show this coupon image, your email or phone\n'
//                 'at Softroniics reception to claim your offer.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 12),
//               ),
//               const SizedBox(height: 40),
//               _buildLogos(),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // 🔹 scratch UI – discount hidden under scratcher
//   Widget _buildScratchCard(BuildContext context) {
//     final scratchContent = Container(
//       width: 300,
//       height: 300,
//       decoration: BoxDecoration(
//         color: Colors.white,
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
//         const SizedBox(height: 10),
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

//         ClipRRect(
//           borderRadius: BorderRadius.circular(30),
//           child: Scratcher(
//             brushSize: 40,
//             threshold: 50,
//             color: AppColors.buttonColor,
//             onThreshold: () {
//               setState(() {
//                 _revealed = true;
//               });
//               _controller.forward();

//               _leftConfetti.play();
//               _rightConfetti.play();

//               if (mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('You got $_discount% OFF! Use code $_code.'),
//                   ),
//                 );
//               }
//             },
//             child: scratchContent,
//           ),
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
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 420),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         if (canShowActions)
//                           _buildDiscountContent(context)
//                         else
//                           _buildScratchCard(context),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // 🎉 Left confetti (shooting to the right)
//             Align(
//               alignment: Alignment.topLeft,
//               child: ConfettiWidget(
//                 confettiController: _leftConfetti,
//                 blastDirection: 0, // 0 rad → right
//                 emissionFrequency: 0.010,
//                 numberOfParticles: 70,
//                 gravity: 0.15,
//               ),
//             ),

//             // 🎉 Right confetti (shooting to the left)
//             Align(
//               alignment: Alignment.topRight,
//               child: ConfettiWidget(
//                 confettiController: _rightConfetti,
//                 blastDirection: pi, // π rad → left
//                 emissionFrequency: 0.010,
//                 numberOfParticles: 70,
//                 gravity: 0.15,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math'; // for pi
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:scratcher/scratcher.dart';
import 'package:softech_scratch_n_win/utils/colors.dart';
import 'package:softech_scratch_n_win/utils/custom.dart';

const Color kPrimaryTextColor = Color(0xFF333333);

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

class _ScratchScreenState extends State<ScratchScreen>
    with SingleTickerProviderStateMixin {
  bool _revealed = false;

  static const String offerExpiryText = 'Offer valid until 30 Nov 2025.';

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // 🎉 Confetti controllers (left + right)
  late ConfettiController _leftConfetti;
  late ConfettiController _rightConfetti;

  // For capturing the coupon as an image
  final GlobalKey _couponKey = GlobalKey();

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

    _leftConfetti = ConfettiController(duration: const Duration(seconds: 2));
    _rightConfetti = ConfettiController(duration: const Duration(seconds: 2));

    if (widget.alreadyPlayed) {
      _revealed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.forward();
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

  String get _name => widget.name;
  int get _discount => widget.discount;
  String get _email => widget.email;
  String get _code => widget.code;

  /// 🔧 Helper: capture the coupon widget as PNG bytes
  Future<Uint8List?> _captureCouponPng() async {
    try {
      final boundary =
          _couponKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<void> _downloadCouponImage() async {
    try {
      final pngBytes = await _captureCouponPng();

      if (pngBytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to capture coupon. Please try again.'),
            ),
          );
        }
        return;
      }

      if (kIsWeb) {
        // 🌐 WEB:
        // Best we can do generally is show the details + ask user to screenshot.
        final message =
            'Hi Softroniics,\n'
            'I got $_discount% discount from the Scratch & Win campaign.\n\n'
            'Name: $_name\n'
            'Email: $_email\n'
            'Phone: ${widget.phone}\n'
            'Discount code: $_code\n';

        await Share.share(
          message,
          subject: 'Softroniics Scratch & Win Discount',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'On web, please take a screenshot or use browser download of the coupon image.',
              ),
            ),
          );
        }
      } else {
        // 📱 MOBILE / DESKTOP APP: save to gallery
        final result = await ImageGallerySaver.saveImage(
          pngBytes,
          name: 'softroniics_coupon_${widget.code}',
          quality: 100,
        );

        if (mounted) {
          final isSuccess =
              (result['isSuccess'] == true || result['success'] == true);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isSuccess
                    ? 'Coupon image saved to your gallery.'
                    : 'Could not save coupon image. Please try again.',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not download coupon. Please try again.'),
        ),
      );
    }
  }

  Future<void> _shareCouponImage() async {
    try {
      final pngBytes = await _captureCouponPng();

      if (pngBytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to capture coupon. Please try again.'),
            ),
          );
        }
        return;
      }

      // 🔹 Common email-style message
      final message =
          'Hi Softroniics,\n'
          'I got $_discount% discount from the Scratch & Win campaign.\n\n'
          'Name: $_name\n'
          'Email: $_email\n'
          'Phone: ${widget.phone}\n'
          'Discount code: $_code\n';

      if (kIsWeb) {
        // 🌐 WEB: cannot reliably attach files → share TEXT only.
        await Share.share(
          message,
          subject: 'Softroniics Scratch & Win Discount',
        );
      } else {
        // 📱 MOBILE / DESKTOP: share coupon PNG as attachment + same message.
        final xFile = XFile.fromData(
          pngBytes,
          mimeType: 'image/png',
          name: 'softroniics_coupon_${widget.code}.png',
        );

        await Share.shareXFiles(
          [xFile],
          text: message,
          subject: 'Softroniics Scratch & Win Discount',
        );
        // User chooses Gmail / Mail from the share sheet to send email with image + text.
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not share coupon. Please try again.'),
        ),
      );
    }
  }

  Widget _buildGiftIcon({double size = 70}) {
    return Icon(
      Icons.card_giftcard,
      color: const Color(0xFFE8B975),
      size: size,
    );
  }

  Widget _buildLogos() {
    return SoftCampus(); // your custom widget
  }

  // 🎟 Shareable coupon card (this is what gets captured)
  Widget _buildCouponCard() {
    return RepaintBoundary(
      key: _couponKey,
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // top icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFF3E0),
              ),
              child: const Icon(
                Icons.card_giftcard,
                size: 32,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),

            // main title
            Text(
              'You Won',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.discount}% OFF!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // ID / code
            SelectableText(
              'ID: ${widget.code}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 24),

            // name + email
            Text(
              widget.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              widget.email,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 "won" UI – shown after scratch / if alreadyPlayed
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
            children: [
              const SizedBox(height: 10),
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
              const SizedBox(height: 24),

              // 🎟 Coupon card (captured for sharing)
              _buildCouponCard(),
              const SizedBox(height: 12),
              Text(
                offerExpiryText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _shareCouponImage,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Share Coupon',
                              style: TextStyle(fontSize: 16),
                            ),
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
                      child: OutlinedButton(
                        onPressed: _downloadCouponImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Download', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 10),
                            Icon(CupertinoIcons.arrow_down_to_line),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Text(
                'Show this coupon image, your email or phone\n'
                'at Softroniics reception to claim your offer.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 40),
              _buildLogos(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 scratch UI – discount hidden under scratcher
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
        const SizedBox(height: 10),
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
          borderRadius: BorderRadius.circular(30),
          child: Scratcher(
            brushSize: 40,
            threshold: 50,
            color: AppColors.buttonColor,
            onThreshold: () {
              setState(() {
                _revealed = true;
              });
              _controller.forward();

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
