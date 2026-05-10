import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JEEAdvancedDetailsPage extends StatelessWidget {
  const JEEAdvancedDetailsPage({super.key});

  // URL for JEE Advanced official website
  static final Uri _url = Uri.parse('https://jeeadv.ac.in/');

  // Method to launch the URL
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JEE Advanced'),
        centerTitle: true,
        backgroundColor: Color(0xFF99CCFF), // Ice Blue
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Joint Entrance Examination (JEE Advanced)',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "JEE Advanced College Predictor 2024 is a tool that helps you predict your admission chances at IITs based on your JEE Advanced ranks. It uses the previous year's JoSAA opening and closing ranks and an advanced algorithm to provide a comprehensive list of IITs accepting your scores.",
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
                const Text('- Eligibility: Top 2,50,000 JEE rank holders', style: TextStyle(color: Colors.black87)),
                const Text('- Exam Mode: Online', style: TextStyle(color: Colors.black87)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _launchUrl,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF99CCFF), // Ice Blue
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Visit Official JEE Advanced Website',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Top Engineering Colleges in Maharashtra accepting JEE Advanced:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: const Text(
                    'IIT Bombay: Mumbai, Maharashtra',
                    style: TextStyle(color: Colors.black87),
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Color(0xFF99CCFF)),
                  onTap: () => launchUrl(Uri.parse('https://www.iitb.ac.in/')),
                ),
                ListTile(
                  title: const Text(
                    'College of Engineering Pune (COEP): Pune, Maharashtra',
                    style: TextStyle(color: Colors.black87),
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Color(0xFF99CCFF)),
                  onTap: () => launchUrl(Uri.parse('https://www.coep.org.in/')),
                ),
                ListTile(
                  title: const Text(
                    'Veermata Jijabai Technological Institute (VJTI): Mumbai, Maharashtra',
                    style: TextStyle(color: Colors.black87),
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Color(0xFF99CCFF)),
                  onTap: () => launchUrl(Uri.parse('https://www.vjti.ac.in/')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}