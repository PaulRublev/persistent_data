import 'dart:io';

import 'package:flutter/material.dart';

class Images extends StatelessWidget {
  final List<String> imageNamesList;

  const Images({super.key, required this.imageNamesList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: imageNamesList.isNotEmpty
          ? ListView.builder(
              itemCount: imageNamesList.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.blueAccent,
                  height: 200,
                  child: Image.file(
                    File(imageNamesList[index]),
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.image,
                    color: Colors.grey,
                  ),
                  Text(
                    'No saved images',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}
