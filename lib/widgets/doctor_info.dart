import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({
    Key? key,
    required this.text,
    required this.icon,
    // this.press,
  }) : super(key: key);

  final String text, icon;

  // final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Color.fromRGBO(51, 192, 179, 1),
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        // onPressed: press,
        onPressed: () {},
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: Color(0XFF33C0B3),
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            // const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
