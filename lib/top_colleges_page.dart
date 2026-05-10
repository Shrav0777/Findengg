import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TopCollegesPage extends StatelessWidget {
  const TopCollegesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        title: const Text(
          'Discover Top 10 Colleges',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Click on any college to view detailed information',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildCollegeCard(
                    'IIT Bombay',
                    'Mumbai, Maharashtra',
                    'Government Institute',
                    'IIT Bombay is one of India\'s premier engineering institutes, established in 1958...',
                    'https://www.iitb.ac.in/',
                  ),
                  _buildCollegeCard(
                    'COEP',
                    'Pune, Maharashtra',
                    'Autonomous Institute',
                    'The College of Engineering Pune (COEP) is one of the oldest engineering colleges...',
                    'https://www.coep.org.in/',
                  ),
                  _buildCollegeCard(
                    'VJTI',
                    'Mumbai, Maharashtra',
                    'Government Institute',
                    'Veermata Jijabai Technological Institute (VJTI) was established in 1887...',
                    'http://www.vjti.ac.in/',
                  ),
                  _buildCollegeCard(
                    'ICT Mumbai',
                    'Mumbai, Maharashtra',
                    'Autonomous Institute',
                    'The Institute of Chemical Technology (ICT Mumbai) is a premier institute...',
                    'https://www.ictmumbai.edu.in/',
                  ),
                  _buildCollegeCard(
                    'MIT Pune',
                    'Pune, Maharashtra',
                    'Private Institute',
                    'MIT World Peace University (MIT Pune) is a prominent private institution...',
                    'https://mitwpu.edu.in/',
                  ),
                  _buildCollegeCard(
                    'VNIT',
                    'Nagpur, Maharashtra',
                    'Government Institute',
                    'Visvesvaraya National Institute of Technology (VNIT) is an Institute of National Importance...',
                    'https://vnit.ac.in/',
                  ),
                  _buildCollegeCard(
                    'SPCE',
                    'Mumbai, Maharashtra',
                    'Government Institute',
                    'Sardar Patel College of Engineering (SPCE) was established in 1962...',
                    'https://www.spce.ac.in/',
                  ),
                  _buildCollegeCard(
                    'Walchand COE',
                    'Sangli, Maharashtra',
                    'Autonomous Institute',
                    'Walchand College of Engineering, established in 1947...',
                    'http://www.walchandsangli.ac.in/',
                  ),
                  _buildCollegeCard(
                    'SGGSIE&T',
                    'Nanded, Maharashtra',
                    'Government Institute',
                    'SGGS Institute of Engineering and Technology, Nanded, is a government institute...',
                    'http://www.sggs.ac.in/',
                  ),
                  _buildCollegeCard(
                    'PICT',
                    'Pune, Maharashtra',
                    'Private Institute',
                    'Pune Institute of Computer Technology (PICT) is a top private engineering college...',
                    'http://www.pict.edu/',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollegeCard(
      String collegeName,
      String location,
      String instituteType,
      String detailedInfo,
      String websiteUrl) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: Colors.cyan.withOpacity(0.3),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.cyan.shade100,
          child: Icon(Icons.school, color: Colors.cyan.shade800),
        ),
        title: Text(
          collegeName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '$location | $instituteType',
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.cyan.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detailedInfo,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    onPressed: () => _launchURL(websiteUrl),
                    icon: const Icon(Icons.open_in_new, size: 16, color: Colors.white),
                    label: const Text(
                      "Visit Website",
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
