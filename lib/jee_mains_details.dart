import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class JEEMainsDetailsPage extends StatelessWidget {
  const JEEMainsDetailsPage({super.key});

  static final Uri _url = Uri.parse('https://jeemain.nta.nic.in/');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JEE Mains'),
        centerTitle: true,
        backgroundColor: Color(0xFF99CCFF),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Joint Entrance Examination (JEE Mains)',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'JEE Mains is a national-level entrance exam for admission to various undergraduate engineering programs in NITs, IIITs, and other centrally funded technical institutions.',
                  style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Key Details:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('- Duration: 3 hours', style: TextStyle(color: Colors.black87)),
                const Text('- Subjects: Physics, Chemistry, Mathematics', style: TextStyle(color: Colors.black87)),
                const Text('- Eligibility: 12th pass with PCM', style: TextStyle(color: Colors.black87)),
                const Text('- Exam Mode: Online', style: TextStyle(color: Colors.black87)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _launchUrl,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF99CCFF),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Visit Official JEE Mains Website',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Top Engineering Colleges in Maharashtra accepting JEE Mains:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: const Text(
                    'Visvesvaraya National Institute of Technology (VNIT): Nagpur, Maharashtra',
                    style: TextStyle(color: Colors.black87),
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Colors.cyan),
                  onTap: () => launchUrl(Uri.parse('https://vnit.ac.in/')),
                ),
                ListTile(
                  title: const Text(
                    'College of Engineering Pune (COEP): Pune, Maharashtra',
                    style: TextStyle(color: Colors.black87),
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Colors.cyan),
                  onTap: () => launchUrl(Uri.parse('https://www.coep.org.in/')),
                ),
                ListTile(
                  title: const Text(
                    'Sardar Patel College of Engineering (SPCE): Mumbai, Maharashtra',
                    style: TextStyle(color: Colors.black87),
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Colors.cyan),
                  onTap: () => launchUrl(Uri.parse('https://www.spce.ac.in/')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}