import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'college_details_page.dart';

class FindCollegePage extends StatefulWidget {
  const FindCollegePage({super.key});

  @override
  State<FindCollegePage> createState() => _FindCollegePageState();
}

class _FindCollegePageState extends State<FindCollegePage> {
  String searchQuery = '';
  String selectedType = 'All';

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
          'Find Colleges',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: 'Search Colleges',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DropdownButtonFormField<String>(
              value: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: 'Filter by Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.filter_list, color: Colors.blue),
              ),
              items: ['All', 'B.E/B.TECH', 'M.E/M.TECH']
                  .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 10),

          // College List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('findCollege')
                  .orderBy('no')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error.toString()}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No colleges found.'));
                }

                final colleges = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>?;

                  final name =
                      data?['name']?.toString().toLowerCase() ?? '';
                  final type =
                      data?['type']?.toString().toLowerCase().trim() ?? '';

                  final searchMatches = name.contains(searchQuery);
                  final filterMatches = selectedType == 'All' ||
                      type.replaceAll(' ', '').contains(
                          selectedType.toLowerCase().replaceAll(' ', ''));

                  return searchMatches && filterMatches;
                }).toList();

                if (colleges.isEmpty) {
                  return const Center(child: Text('No results found.'));
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: colleges.length,
                  itemBuilder: (context, index) {
                    final doc = colleges[index];
                    final data = doc.data() as Map<String, dynamic>?;

                    if (data == null) return const SizedBox();

                    final String name = data['name'] ?? 'No Name';
                    final String type = data['type'] ?? 'N/A';
                    final String location = data['location'] ?? 'N/A';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CollegeDetailsPage(
                                collegeName: name, // Pass only the name
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.school, color: Colors.blue),
                                  const SizedBox(width: 5),
                                  Text('Type: $type'),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.red),
                                  const SizedBox(width: 5),
                                  Text('Location: $location'),
                                ],
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
