import 'package:flutter/material.dart';

Size textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );
  return textPainter.size;
}

class TimeWidget extends StatelessWidget {
  const TimeWidget({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final size = textSize(
      '0',
      Theme.of(context)
          .textTheme
          .headlineMedium!
          .copyWith(fontFamily: 'BlackOpsOne'),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: size.width,
        child: Center(
          child: Text(
            number.toString(),
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontFamily: 'BlackOpsOne'),
          ),
        ),
      ),
    );
  }
}
