import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class Header extends StatelessWidget {
  final String text;
  const Header({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
         'assets/icons/e-shoping.svg',
          width: 300, 
          height: 120,
          color: Colors.deepPurple, 
        ),
        const SizedBox(height: 30),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const  TextStyle(
            fontSize: 24.0,
            color: Colors.deepPurple,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
