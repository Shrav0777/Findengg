import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

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
        elevation: 5,
        title: const Text(
          '🏆 College Rankings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('college')
              .orderBy('Rank', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No rankings available.'));
            }

            final colleges = snapshot.data!.docs;

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: colleges.length,
              itemBuilder: (context, index) {
                final collegeData = colleges[index].data() as Map<String, dynamic>?;

                if (collegeData == null) {
                  return const SizedBox();
                }

                final int rank = collegeData['Rank'] ?? index + 1;
                final String name = collegeData['Name'] ?? 'Unknown College';
                final String ranking = collegeData['Ranking'] ?? 'N/A';
                final String type = collegeData['Type'] ?? 'N/A';

                return _buildRankTile(rank, name, ranking, type);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRankTile(int rank, String name, String ranking, String type) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      shadowColor: Colors.cyan.withOpacity(0.3),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.cyan.shade700,
          child: Text(
            rank.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        title: Text(
          name,
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          type,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.amber.shade700, size: 20),
            const SizedBox(height: 4),
            Text(
              ranking,
              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
