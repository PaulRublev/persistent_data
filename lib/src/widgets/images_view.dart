import 'package:flutter/material.dart';
import 'package:persistent_data/src/data_interaction.dart';

import 'bottom_panel.dart';
import 'images.dart';

class ImagesView extends StatefulWidget {
  const ImagesView({super.key});

  @override
  State<ImagesView> createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  late DataInteraction data;

  @override
  void initState() {
    super.initState();
    data = DataInteraction(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        actions: [
          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => data.delete(),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Images(imageNamesList: data.imageNamesList),
          BottomPanel(setStateCallback: setState, save: data.save),
        ],
      ),
    );
  }
}
