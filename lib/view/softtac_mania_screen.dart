import 'package:flutter/material.dart';
import 'package:softech_scratch_n_win/utils/colors.dart';
import 'package:softech_scratch_n_win/utils/custom.dart';

class SoftTacManiaScreen extends StatelessWidget {
  const SoftTacManiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide =
            constraints.maxWidth >= 800; // Web / desktop breakpoint

        if (isWide) {
          return const _DesktopWebLayout();
        } else {
          return const _MobileLayout();
        }
      },
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double contentHeight =
        size.height * 0.45; // bottom content area (dynamic)

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image

          // Bottom content card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: contentHeight,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFF7F7F7),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              child: const SafeArea(
                top: false,
                child: _ContentSection(isWide: false),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .75,
            child: Image.asset(
              width: double.infinity,
              "assets/images/pro.png",
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopWebLayout extends StatelessWidget {
  const _DesktopWebLayout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side: image (takes remaining space)
          Expanded(
            child: SizedBox.expand(
              child: Image.asset("assets/images/pro.png", fit: BoxFit.cover),
            ),
          ),

          // Right side: content panel
          Container(
            width: 480, // fixed width panel for web/desktop
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 32.0,
            ),
            color: const Color(0xFFF7F7F7),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 420),
                child: _ContentSection(isWide: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final bool isWide;
  const _ContentSection({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: isWide
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        // --- Titles and Description ---
        Column(
          crossAxisAlignment: isWide
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            const Text(
              'SoftTac Mania',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Play Big. Win Bigger.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Scan. Play. Win exclusive discounts on Softroniics\nand The Animation Campus training programs!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black54,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // --- Get Started Button ---
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
              debugPrint('Get Started tapped!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // --- Logos (Bottom Section) ---
        SoftCampus(),
      ],
    );
  }
}
