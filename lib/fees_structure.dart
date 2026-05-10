import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class FeesStructurePage extends StatelessWidget {
  final String feesUrl;

  const FeesStructurePage({super.key, required this.feesUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fees Structure")),
      body: PDF().cachedFromUrl(
        feesUrl,
        placeholder: (progress) => Center(child: Text("Loading: $progress%")),
        errorWidget: (error) => Center(child: Text("Error loading PDF:\n$error")),
      ),
    );
  }
}
