import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EntranceExamPage extends StatelessWidget {
  const EntranceExamPage({super.key});

  // URLs for official websites of engineering exams in Maharashtra
  static Uri cetUrl = Uri.parse('https://cetcell.mahacet.org/');
  static Uri jeeMainsUrl = Uri.parse('https://jeemain.nta.nic.in/');
  static Uri jeeAdvancedUrl = Uri.parse('https://jeeadv.ac.in/');

  // Method to launch a URL
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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
        title: const Text(
          'Entrance Exams',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Explore Engineering Entrance Exams in Maharashtra',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildExamTile(
                    context,
                    'CET',
                    'Common Entrance Test for state-level engineering admissions.',
                    Icons.business,
                    cetUrl,
                  ),
                  _buildExamTile(
                    context,
                    'JEE Mains',
                    'National level engineering entrance exam for NITs, IIITs, and qualifiers for JEE Advanced.',
                    Icons.engineering,
                    jeeMainsUrl,
                  ),
                  _buildExamTile(
                    context,
                    'JEE Advanced',
                    'Entrance exam for admissions to IITs.',
                    Icons.science,
                    jeeAdvancedUrl,
                  ),
                  _buildExamTile(
                    context,
                    'BITSAT',
                    'Birla Institute of Technology and Science Admission Test for BITS Pilani and other campuses.',
                    Icons.school,
                    Uri.parse('https://www.bitsadmission.com/'),
                  ),
                  _buildExamTile(
                    context,
                    'VITEEE',
                    'VIT Engineering Entrance Exam for VIT University.',
                    Icons.computer,
                    Uri.parse('https://vit.ac.in/'),
                  ),
                  _buildExamTile(
                    context,
                    'SRMJEEE',
                    'SRM Joint Engineering Entrance Examination for SRM University.',
                    Icons.engineering_outlined,
                    Uri.parse('https://www.srmist.edu.in/'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamTile(
      BuildContext context, String title, String subtitle, IconData icon, Uri url) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: Colors.cyan.withOpacity(0.3),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.cyan.shade50,
          child: Icon(icon, color: Colors.cyan.shade700, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        trailing: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan.shade700,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          ),
          onPressed: () => _launchUrl(url),
          icon: const Icon(Icons.open_in_new, size: 16, color: Colors.white),
          label: const Text(
            "Visit",
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
