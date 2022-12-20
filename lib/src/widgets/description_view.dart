import 'package:flutter/material.dart';

class DescriptionView extends StatelessWidget {
  final String title;
  final List<String> description;
  final lorem = "Esse qui exercitation aute exercitation "
      "quis nulla mollit deserunt nostrud reprehenderit "
      "minim ad enim commodo. Labore aute ea veniam eu dolore sit "
      "labore occaecat. Velit consequat minim sit adipisicing. "
      "Veniam esse magna sint incididunt nostrud elit. Est tempor irure "
      "eu velit nisi ad ipsum laborum anim adipisicing laborum laborum commodo.";

  const DescriptionView(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description.first,
                textScaleFactor: 2,
              ),
              const SizedBox(height: 50),
              Text(
                '${description.last}. $lorem',
                textScaleFactor: 1.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
