import 'package:flutter/material.dart';
import 'package:softech_scratch_n_win/utils/colors.dart';
import 'package:softech_scratch_n_win/utils/custom.dart';

class SoftTacManiaScreen extends StatelessWidget {
  const SoftTacManiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;

    // --- Simple breakpoints using MediaQuery ---
    final bool isMobile = width < 700;
    final bool isTablet = width >= 700 && width < 1100;
    final bool isDesktop = width >= 1100;

    if (isDesktop) {
      return const _DesktopWebLayout();
    } else {
      // mobile + tablet handled with the same layout,
      // just with dynamic heights / paddings using MediaQuery
      return _MobileTabletLayout(isTablet: isTablet);
    }
  }
}

class _MobileTabletLayout extends StatelessWidget {
  final bool isTablet;
  const _MobileTabletLayout({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double height = size.height;

    // More space for bottom content on tablets
    final double contentHeightFactor = isTablet ? 0.5 : 0.45;
    final double contentHeight = height * contentHeightFactor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // SafeArea so it doesn’t go under status bar / notch
        top: true,
        bottom: false,
        child: Stack(
          children: [
            // BACKGROUND IMAGE (goes first so it stays behind)
            SizedBox(
              height: height * 0.75,
              width: double.infinity,
              child: Image.asset("assets/images/pro.png", fit: BoxFit.cover),
            ),

            // BOTTOM CARD CONTENT
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: contentHeight,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32.0 : 24.0,
                  vertical: 24.0,
                ),
                decoration: BoxDecoration(color: Colors.white),
                child: const _ContentSection(isWide: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopWebLayout extends StatelessWidget {
  const _DesktopWebLayout();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width = size.width;

    // dynamic right panel width based on screen
    final double panelWidth = width * 0.36; // ~36% of screen
    final double clampedPanelWidth = panelWidth.clamp(
      420.0,
      520.0,
    ); // min–max width

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            // LEFT SIDE IMAGE
            Expanded(
              child: SizedBox.expand(
                child: Image.asset("assets/images/pro.png", fit: BoxFit.cover),
              ),
            ),

            // RIGHT SIDE CONTENT PANEL
            Container(
              width: clampedPanelWidth,
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 32.0,
              ),
              color: Colors.white,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: const _ContentSection(isWide: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final bool isWide;
  const _ContentSection({required this.isWide});

  @override
  Widget build(BuildContext context) {
    // Extra horizontal padding on wide layout
    final EdgeInsets contentPadding = isWide
        ? const EdgeInsets.only(right: 12.0)
        : EdgeInsets.zero;

    // Use SingleChildScrollView to avoid overflow on small screens
    return Padding(
      padding: contentPadding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // Ensures button/logos stay near bottom on tall screens
                minHeight: constraints.maxHeight > 0
                    ? constraints.maxHeight
                    : 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: isWide
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  // --- TITLES & DESCRIPTION ---
                  Column(
                    crossAxisAlignment: isWide
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'SoftTac Mania',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Play Big. Win Bigger.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
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

                  const SizedBox(height: 24),

                  // --- GET STARTED BUTTON ---
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

                  // --- LOGOS (BOTTOM SECTION) ---
                  const SoftCampus(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
