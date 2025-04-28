import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const GoogleButton({
    super.key,
    required this.onPressed,
    this.text = 'Continue with Google',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 320),
      height: 56,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onPressed,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade600
                        : Colors.grey.shade300,
                width: 1,
              ),
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGoogleIcon(),
                  const SizedBox(width: 16),
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: GoogleLogoPainter()),
    );
  }
}

class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Colors from Google's logo
    final Paint bluePaint = Paint()..color = const Color(0xFF4285F4);
    final Paint greenPaint = Paint()..color = const Color(0xFF34A853);
    final Paint yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final Paint redPaint = Paint()..color = const Color(0xFFEA4335);

    // Drawing areas for the different parts of the logo
    final Rect upperLeftQuadrant = Rect.fromLTRB(0, 0, width / 2, height / 2);
    final Rect upperRightQuadrant = Rect.fromLTRB(
      width / 2,
      0,
      width,
      height / 2,
    );
    final Rect lowerLeftQuadrant = Rect.fromLTRB(
      0,
      height / 2,
      width / 2,
      height,
    );
    final Rect lowerRightQuadrant = Rect.fromLTRB(
      width / 2,
      height / 2,
      width,
      height,
    );

    // Draw the logo's parts
    canvas.drawRect(upperLeftQuadrant, bluePaint);
    canvas.drawRect(upperRightQuadrant, redPaint);
    canvas.drawRect(lowerLeftQuadrant, yellowPaint);
    canvas.drawRect(lowerRightQuadrant, greenPaint);

    // Draw a white circle in the middle
    final Paint whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(width / 2, height / 2), width * 0.3, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
