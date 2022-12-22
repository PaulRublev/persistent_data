import 'package:flutter/material.dart';

import 'custom_image.dart';

class ImagePicker extends StatefulWidget {
  final Function(String) callback;
  final String? imagePath;

  const ImagePicker({super.key, required this.callback, this.imagePath});

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  static const String jellySad = 'jelly-sad.png';
  static const String jellyConfused = 'jelly-confused.png';
  static const String jellyArmored = 'jelly-armored.png';
  static const String assetsPath = 'assets/images/';

  final String confused = '$assetsPath$jellyConfused';
  final String armored = '$assetsPath$jellyArmored';
  final String sad = '$assetsPath$jellySad';

  String current = '';

  @override
  void initState() {
    super.initState();
    current = widget.imagePath ?? confused;
    widget.callback(current);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => _changeCurrent(confused),
            child: CustomImage(
              isSelected: current == confused ? true : false,
              imagePath: '$assetsPath$jellyConfused',
            ),
          ),
          GestureDetector(
            onTap: () => _changeCurrent(armored),
            child: CustomImage(
              isSelected: current == armored ? true : false,
              imagePath: '$assetsPath$jellyArmored',
            ),
          ),
          GestureDetector(
            onTap: () => _changeCurrent(sad),
            child: CustomImage(
              isSelected: current == sad ? true : false,
              imagePath: '$assetsPath$jellySad',
            ),
          ),
        ],
      ),
    );
  }

  void _changeCurrent(String imagePath) {
    widget.callback(imagePath);
    setState(() {
      current = imagePath;
    });
  }
}
