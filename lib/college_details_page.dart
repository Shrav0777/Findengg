import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'brochure_preview_page.dart';
import 'fees_structure.dart';
import 'CampusGalleryPage.dart';

class CollegeDetailsPage extends StatefulWidget {
  final String collegeName;

  const CollegeDetailsPage({super.key, required this.collegeName});

  @override
  _CollegeDetailsPageState createState() => _CollegeDetailsPageState();
}

class _CollegeDetailsPageState extends State<CollegeDetailsPage> with SingleTickerProviderStateMixin {
  String? _collegeTitle;
  String? _description;
  String? _fees;
  String? _placement;
  String? _alumni;
  String? _brochureLink;
  String? _contactDetails;
  String? _feesStructureLink;
  bool _isLoading = true;
  String? _error;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _fetchCollegeData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchCollegeData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      var snapshot = await FirebaseFirestore.instance
          .collection('findCollege')
          .where('name', isEqualTo: widget.collegeName)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data();
        String? rawBrochure = data['brochure'];
        String? rawFeesStructure = data['fees'];

        setState(() {
          _collegeTitle = data['name'];
          _description = data['description'];
          _contactDetails = data['contact'];
        });

        if (rawBrochure != null && rawBrochure.isNotEmpty) {
          if (rawBrochure.contains('drive.google.com')) {
            if (rawBrochure.contains('/d/')) {
              final match = RegExp(r'/d/([a-zA-Z0-9_-]+)').firstMatch(rawBrochure);
              if (match != null) {
                String fileId = match.group(1)!;
                _brochureLink = 'https://drive.google.com/uc?export=download&id=$fileId';
              }
            } else {
              _brochureLink = rawBrochure;
            }
          } else {
            _brochureLink = rawBrochure;
          }
        }

        if (rawFeesStructure != null && rawFeesStructure.isNotEmpty) {
          if (rawFeesStructure.contains('drive.google.com')) {
            if (rawFeesStructure.contains('/d/')) {
              final match = RegExp(r'/d/([a-zA-Z0-9_-]+)').firstMatch(rawFeesStructure);
              if (match != null) {
                String fileId = match.group(1)!;
                _feesStructureLink = 'https://drive.google.com/uc?export=download&id=$fileId';
              }
            } else {
              _feesStructureLink = rawFeesStructure;
            }
          } else {
            _feesStructureLink = rawFeesStructure;
          }
        }
      }
    } catch (e) {
      setState(() {
        _error = "Error fetching college data: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _launchGoogleMaps() async {
    final String destination = Uri.encodeComponent(widget.collegeName);
    final String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&destination=$destination&travelmode=driving';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      setState(() {
        _error = 'Could not launch Google Maps';
      });
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch phone call")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'College Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF4A90E2)))
          : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCollegeHeader(),
              const SizedBox(height: 20),
              _buildQuickActions(),
              const SizedBox(height: 20),
              _buildKeyHighlights(),
              const SizedBox(height: 20),
              _buildMapsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollegeHeader() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF7F9FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF4A90E2).withOpacity(0.1),
                child: const Icon(
                  Icons.school,
                  size: 50,
                  color: Color(0xFF4A90E2),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                _collegeTitle ?? 'Loading...',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3C6D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              const Text(
                'Mumbai, Maharashtra',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (_contactDetails != null && _contactDetails!.isNotEmpty) {
                    _makePhoneCall(_contactDetails!);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 16,
                      color: Color(0xFF4A90E2),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _contactDetails ?? 'Contact details not available',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A90E2),
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF7F9FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3C6D),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: _buildActionButton("Campus Gallery", Icons.photo_album, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CampusGalleryPage(collegeName: widget.collegeName),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: InkWell(
                        onTap: () {
                          if (_brochureLink != null && _brochureLink!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BrochureViewerPage(
                                  brochureUrl: _brochureLink!,
                                ),
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.picture_as_pdf, color: Colors.white, size: 28),
                              const SizedBox(height: 4),
                              const Text(
                                "Brochure",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (_brochureLink != null && await canLaunch(_brochureLink!)) {
                                    await launch(_brochureLink!);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Download link not available")),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.download, size: 12, color: Colors.white),
                                label: const Text("Download", style: TextStyle(fontSize: 10, color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  elevation: 0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 0.89,
                      child: InkWell(
                        onTap: () {
                          if (_feesStructureLink != null && _feesStructureLink!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeesStructurePage(
                                  feesUrl: _feesStructureLink!,
                                ),
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.picture_as_pdf, color: Colors.white, size: 28),
                              const SizedBox(height: 4),
                              const Text(
                                "Fees Structure",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (_feesStructureLink != null && await canLaunch(_feesStructureLink!)) {
                                    await launch(_feesStructureLink!);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Download link not available")),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.download, size: 12, color: Colors.white),
                                label: const Text("Download", style: TextStyle(fontSize: 10, color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  elevation: 0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 0.89,
                      child: _buildActionButton("Reviews", Icons.star, () {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 0.89,
                      child: _buildActionButton("Alumni", Icons.people, () {}),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyHighlights() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF7F9FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Key Highlights",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3C6D),
                ),
              ),
              const SizedBox(height: 15),
              _buildHighlightRow(Icons.grade, "NAAC Grade", "A++"),
              const SizedBox(height: 10),
              _buildHighlightRow(Icons.trending_up, "Placement", "98%"),
              const SizedBox(height: 10),
              _buildHighlightRow(Icons.description, "Research Papers", "15,000+"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4A90E2), size: 20),
        const SizedBox(width: 10),
        Text(
          "$title: ",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3C6D),
          ),
        ),
      ],
    );
  }

  Widget _buildMapsButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _launchGoogleMaps,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: const Text(
            "View College on Maps",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}