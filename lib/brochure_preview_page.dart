import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class BrochureViewerPage extends StatelessWidget {
  final String brochureUrl;

  const BrochureViewerPage({super.key, required this.brochureUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Brochure Viewer")),
      body: PDF().cachedFromUrl(
        brochureUrl,
        placeholder: (progress) => Center(child: Text("Loading: $progress%")),
        errorWidget: (error) => Center(child: Text("Error loading PDF:\n$error")),
      ),
    );
  }
}
