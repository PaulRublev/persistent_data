import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  bool isSelected;
  final String imagePath;

  CustomImage({
    super.key,
    required this.isSelected,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: isSelected ? Colors.blue : Colors.grey,
      child: Image.asset(imagePath),
    );
  }
}
