import 'package:flutter/cupertino.dart';

class SoftCampus extends StatelessWidget {
  const SoftCampus({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(width: 100, "assets/images/softroniics.png"),
        SizedBox(width: 30),
        Image.asset(width: 85, "assets/images/acamp.png"),
      ],
    );
  }
}
