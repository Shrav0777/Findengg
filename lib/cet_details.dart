import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class CETDetailsPage extends StatelessWidget {
  const CETDetailsPage({super.key});

  static final Uri _url = Uri.parse('https://cetcell.mahacet.org/');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MHT CET'),
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
                  'Maharashtra Common Entrance Test (MHT CET)',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'MHT CET is a state-level entrance exam for admission to engineering and pharmacy courses in Maharashtra.',
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
                const Text('- Subjects: Physics, Chemistry, Mathematics/Biology', style: TextStyle(color: Colors.black87)),
                const Text('- Eligibility: 12th pass with PCM/PCB', style: TextStyle(color: Colors.black87)),
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
                    'Visit Official MHT CET Website',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Top Engineering Colleges in Maharashtra accepting MHT CET:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 8),
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
                    'Veermata Jijabai Technological Institute (VJTI): Mumbai, Maharashtra',
                    style: TextStyle(color: Colors.black87),
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Colors.cyan),
                  onTap: () => launchUrl(Uri.parse('https://www.vjti.ac.in/')),
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