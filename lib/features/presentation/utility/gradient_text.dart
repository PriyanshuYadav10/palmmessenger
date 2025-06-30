import 'package:flutter/material.dart';
import 'package:palmmessenger/config/theme/app_themes.dart';

class GradientText extends StatelessWidget {
   GradientText(
    this.text, {
    this.style,
  });

  final String text;
  final TextStyle? style;
var gradient = LinearGradient(colors: [
    ColorResources.thirdColor,
    ColorResources.secondaryColor, 
  ]);
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text,textAlign: TextAlign.center, style: style),
    );
  }
}