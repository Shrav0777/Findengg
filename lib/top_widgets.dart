import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cet_details.dart';
import '../jee_advance_details.dart';
import '../jee_mains_details.dart';
class TopExamsWidget extends StatelessWidget {
  const TopExamsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Top Exams',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildExamTile(context, 'JEE Advanced', 'IIT Entrance Examination', Icons.science, const JEEAdvancedDetailsPage()),
                _buildExamTile(context, 'JEE Mains', 'Engineering Entrance Test', Icons.engineering, const JEEMainsDetailsPage()),
                _buildExamTile(context, 'CET', 'Common Eligibility Test', Icons.business, const CETDetailsPage()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExamTile(BuildContext context, String title, String subtitle, IconData icon, Widget? page) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.cyan[50],
        child: Icon(icon, color: Colors.cyan),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title details are not available yet.')),
          );
        }
      },
    );
  }
}