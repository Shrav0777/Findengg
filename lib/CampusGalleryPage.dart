import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class CampusGalleryPage extends StatefulWidget {
  final String collegeName;

  const CampusGalleryPage({super.key, required this.collegeName});

  @override
  _CampusGalleryPageState createState() => _CampusGalleryPageState();
}

class _CampusGalleryPageState extends State<CampusGalleryPage> {
  bool _isLoading = true;
  String? _error;
  List<String> _galleryImages = [];

  @override
  void initState() {
    super.initState();
    _fetchAndScrapeImages();
  }

  Future<void> _fetchAndScrapeImages() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final snapshot = await FirebaseFirestore.instance
          .collection('findCollege')
          .where('name', isEqualTo: widget.collegeName)
          .get();

      if (snapshot.docs.isEmpty) throw Exception("College not found in Firestore");

      final data = snapshot.docs.first.data();
      final officialUrl = data['officialWebsite'] ?? '';

      if (officialUrl.isNotEmpty) {
        List<String> images = await _scrapeImagesFromPage(officialUrl);
        if (images.isNotEmpty) {
          debugPrint('Found ${images.length} images from official site');
          setState(() => _galleryImages = images);
          return;
        }
      }

      // Fallback to Google Images
      List<String> googleImages = await _scrapeGoogleImages(widget.collegeName);
      if (googleImages.isNotEmpty) {
        debugPrint('Found ${googleImages.length} images from Google');
        setState(() => _galleryImages = googleImages);
        return;
      }

      throw Exception("No images found from any source");
    } catch (e) {
      debugPrint('Image Fetch Error: $e');
      setState(() => _error = 'Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<String>> _scrapeImagesFromPage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return [];

      final document = parse(response.body);
      final imageTags = document.querySelectorAll('img');

      return imageTags
          .map((e) => e.attributes['src'] ?? e.attributes['data-src'] ?? '')
          .where((url) =>
      url.isNotEmpty &&
          (url.endsWith('.jpg') || url.endsWith('.jpeg') || url.endsWith('.png')) &&
          !url.contains('logo') &&
          !url.contains('icon'))
          .map((url) {
        if (url.startsWith('//')) return 'https:$url';
        return url;
      })
          .take(25)
          .toList();
    } catch (e) {
      debugPrint('Scrape error from page: $e');
      return [];
    }
  }

  Future<List<String>> _scrapeGoogleImages(String query) async {
    try {
      final url =
          "https://www.google.com/search?tbm=isch&q=${Uri.encodeComponent(query + " campus images")}";
      final headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
      };

      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode != 200) return [];

      final document = parse(response.body);
      final imageElements = document.querySelectorAll('img');

      debugPrint('Google image tags found: ${imageElements.length}');

      List<String> imageUrls = imageElements
          .map((e) => e.attributes['data-src'] ?? e.attributes['src'] ?? '')
          .where((link) =>
      link.startsWith('http') &&
          !link.contains('logo') &&
          !link.contains('icon') &&
          (link.contains('.gstatic.com') || link.contains('googleusercontent.com')))
          .toList();

      return imageUrls.take(25).toList();
    } catch (e) {
      debugPrint('Google Image Scrape Error: $e');
      return [];
    }
  }

  Future<void> _shareImage(String imageUrl) async {
    try {
      final response = await Dio().get(imageUrl, options: Options(responseType: ResponseType.bytes));
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/shared_image.jpg');
      await file.writeAsBytes(response.data);
      await Share.shareXFiles([XFile(file.path)], text: 'Check out this college photo!');
    } catch (e) {
      debugPrint('Share error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share')),
      );
    }
  }

  void _showFullImage(BuildContext context, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        int currentIndex = index;
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 4.0,
                      child: CachedNetworkImage(
                        imageUrl: _galleryImages[currentIndex],
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 10),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () => _shareImage(_galleryImages[currentIndex]),
                        ),
                      ],
                    ),
                  ),
                  if (currentIndex > 0)
                    Positioned(
                      left: 10,
                      top: MediaQuery.of(context).size.height / 2 - 30,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.white),
                        onPressed: () => setState(() => currentIndex--),
                      ),
                    ),
                  if (currentIndex < _galleryImages.length - 1)
                    Positioned(
                      right: 10,
                      top: MediaQuery.of(context).size.height / 2 - 30,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 30, color: Colors.white),
                        onPressed: () => setState(() => currentIndex++),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _generateSlug(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.collegeName} Campus Gallery'),
        backgroundColor: const Color(0xFF4A90E2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF4A90E2)))
          : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : _galleryImages.isEmpty
          ? const Center(child: Text("No images available."))
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: _galleryImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showFullImage(context, index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: _galleryImages[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4A90E2)),
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }
}
