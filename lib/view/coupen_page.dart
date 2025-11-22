import 'package:flutter/material.dart';

class CouponPage extends StatelessWidget {
  final String name;
  final String email;
  final String couponId;
  final int discount;

  const CouponPage({
    super.key,
    required this.name,
    required this.email,
    required this.couponId,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.8;
    final cardMaxWidth = 340.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // White coupon card
            Container(
              width: cardWidth > cardMaxWidth ? cardMaxWidth : cardWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top gift icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF3D6), // soft yellow
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.card_giftcard_rounded,
                      size: 32,
                      color: Color(0xFFFF9800),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // "You Won 25% OFF!"
                  Text(
                    'You Won',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$discount% OFF!',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ID text
                  Text(
                    'ID: $couponId',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      letterSpacing: 1.1,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Congratulations block
                  const Text(
                    'Congratulations!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      children: const [
                        TextSpan(text: 'You unlocked a '),
                        TextSpan(
                          text: 'special training discount \n',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: 'from Softroniics and The Animation Campus',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dashed divider (simple line)
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.grey[300], thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Name & email
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            // Side cut-outs (black circles)
            Positioned(
              left: 0,
              child: Transform.translate(
                offset: const Offset(-25, 0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Transform.translate(
                offset: const Offset(25, 0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
