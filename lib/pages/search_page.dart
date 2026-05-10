import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login_screen.dart';
import '../ranking_page.dart';
import '../entrance_exam_page.dart';
import '../find_college_page.dart';
import '../top_colleges_page.dart';
import '../cet_details.dart';
import '../jee_advance_details.dart';
import '../jee_mains_details.dart';
import '../college_details_page.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' show parse;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];
  bool _isSearching = false;

  Future<void> _searchColleges(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // Fetch the first N documents (adjust the limit as needed)
      var snapshot = await FirebaseFirestore.instance
          .collection('findCollege')
          .limit(715) // Fetch more if needed
          .get();

      String lowerQuery = query.toLowerCase();

      List<DocumentSnapshot> filteredResults = snapshot.docs.where((doc) {
        final name = doc['name'].toString().toLowerCase();
        return name.contains(lowerQuery);
      }).toList();

      setState(() {
        _searchResults = filteredResults;
      });
    } catch (e) {
      debugPrint("Search error: $e");
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF39A7FF)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutAppPage()),
            );
          },
        ),
        title: TextField(
          controller: _searchController,
          onChanged: _searchColleges,
          decoration: InputDecoration(
            hintText: 'Search colleges...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
                _searchColleges('');
              },
            )
                : null,
          ),
        ),
      ),
      body: _searchController.text.isNotEmpty
          ? _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
          ? const Center(child: Text("No colleges found"))
          : ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final college = _searchResults[index];
          final name = college['name'];
          return ListTile(
            title: Text(name),
            leading: const Icon(Icons.school, color: Color(0xFF39A7FF)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CollegeDetailsPage(collegeName: name),
                ),
              );
            },
          );
        },
      )
          : _buildDefaultBody(),
    );
  }

  Widget _buildDefaultBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Top Entrance Exams",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF39A7FF)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _examCard('JEE Advanced', 'IIT Entrance Examination', Icons.school, 220, const JEEAdvancedDetailsPage())),
              const SizedBox(width: 8),
              Expanded(child: _examCard('JEE Mains', 'Engineering Entrance Test', Icons.engineering, 220, const JEEMainsDetailsPage())),
              const SizedBox(width: 8),
              Expanded(child: _examCard('CET', 'Common Eligibility Test', Icons.book, 220, const CETDetailsPage())),
            ],
          ),
          const SizedBox(height: 30),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildCard('Rankings', Icons.bar_chart, const RankingPage()),
              _buildCard('Find College', Icons.school, const FindCollegePage()),
              _buildCard('Entrance Exam', Icons.assignment, const EntranceExamPage()),
              _buildCard('Top 10 Colleges', Icons.star, const TopCollegesPage()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _examCard(String title, String subtitle, IconData icon, double height, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFF39A7FF), size: 40),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9BE8D8), Color(0xFF39A7FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: Icon(icon, color: Color(0xFF39A7FF), size: 30),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AboutAppPage extends StatefulWidget {
  const AboutAppPage({Key? key}) : super(key: key);

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  List<NewsArticle> _newsArticles = [];
  bool _isLoadingNews = false;
  String? _newsError;

  @override
  void initState() {
    super.initState();
    _fetchEngineeringNews();
  }

  Future<void> _fetchEngineeringNews() async {
    setState(() {
      _isLoadingNews = true;
      _newsError = null;
      _newsArticles = [];
    });

    const String url = 'https://indianexpress.com/about/engineering-colleges/';

    try {
      final response = await http.get(Uri.parse(url));
      print('Response Status: ${response.statusCode}');
      //print('Raw HTML snippet: ${response.body.substring(0, 500)}');

      if (response.statusCode == 200) {
        final document = parse(response.body);
        final articleElements = document.querySelectorAll('#section .container .row .leftpanel .search-result .details');

        print('Found article elements: ${articleElements.length}');

        if (articleElements.isNotEmpty) {
          final List<NewsArticle> scrapedArticles = articleElements.map((element) {
            final titleElement = element.querySelector('h3 a');
            final title = titleElement?.text.trim() ?? 'No Title';
            final articleUrl = titleElement?.attributes['href'] ?? '';
            final descriptionElement = element.querySelector('p.summary');
            final description = descriptionElement?.text.trim();

            // Updated image scraping logic for lazy-loaded images
            final imageElement = element.querySelector('div.about-thumb img.lazyloading');
            // Check for data-src or src attribute (lazy-loaded images often use data-src)
            final imageUrl = imageElement?.attributes['data-src'] ?? imageElement?.attributes['src'];

            print('Scraped - Title: $title, URL: $articleUrl, Desc: $description, Img: $imageUrl');

            return NewsArticle(
              title: title.isNotEmpty ? title : 'No Title',
              url: articleUrl.isNotEmpty ? articleUrl : null,
              description: description,
              urlToImage: imageUrl,
              publishedAt: null,
              content: null,
            );
          }).toList();

          setState(() {
            _newsArticles = scrapedArticles;
          });
        } else {
          setState(() {
            _newsError = 'No articles found with the specified selector.';
          });
        }
      } else {
        setState(() {
          _newsError = 'Failed to load page: HTTP ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _newsError = 'Failed to scrape news: $e';
      });
    } finally {
      setState(() {
        _isLoadingNews = false;
      });
    }
  }

  void _navigateToNewsDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailPage(
          newsArticles: _newsArticles,
          error: _newsError,
          isLoading: _isLoadingNews,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text(
          'About App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF03DAC6), Color(0xFF6200EA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? 'USERNAME',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Hello, Future Engineer...',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      Icons.settings,
                      'Settings',
                      Colors.blue,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      },
                    ),
                    _buildMenuItem(
                      Icons.dashboard,
                      'Dashboard',
                      Colors.green,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      Icons.newspaper,
                      'Latest News',
                      Colors.purple,
                      _navigateToNewsDetail,
                    ),
                    _buildMenuItem(
                      Icons.location_city,
                      'View Colleges on Maps',
                      Colors.red,
                          () async {
                        final Uri uri = Uri.parse('https://www.google.com/maps/search/engineering+colleges');

                        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                          debugPrint('Could not launch $uri');
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => _showLogoutDialog(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        'Log Out',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      IconData icon,
      String text,
      Color iconColor,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
              },
              child: const Text(
                "Log Out",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NewsArticle {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;

  NewsArticle({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      content: json['content'] as String?,
    );
  }

  factory NewsArticle.fromGNewsJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['image'] as String?,
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      content: json['content'] as String?,
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final List<NewsArticle> newsArticles;
  final String? error;
  final bool isLoading;

  const NewsDetailPage({
    Key? key,
    required this.newsArticles,
    this.error,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Latest News',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(
          builder: (context) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (error != null) {
              return Center(
                child: Text(
                  'Error loading news: $error',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (newsArticles.isEmpty) {
              return const Center(
                child: Text(
                  'No news available.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else {
              return ListView.separated(
                itemCount: newsArticles.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final article = newsArticles[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (article.url != null) {
                          final uri = Uri.parse(article.url!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            print('Could not launch ${article.url}');
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            article.urlToImage != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                article.urlToImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              ),
                            )
                                : Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            // Text Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.title ?? 'No Title',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (article.description != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      article.description!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Read More',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 16,
                                        color: Colors.blue[700],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
// NEW Settings Page

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final User? _user = FirebaseAuth.instance.currentUser;

  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _currentPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _emailNotifications = false;

  // Toggles for password visibility
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = _user?.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // Example email if user email is null
    final String userEmail = _user?.email ?? 'bushrasayed2226@gmail.com';

    return Scaffold(
      // Use an AppBar for the back arrow
      appBar: AppBar(
        backgroundColor: const Color(0xFFA4DEDE),
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // back arrow action
        ),
      ),
      backgroundColor: const Color(0xFFE5F4F4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity, // match width of other boxes
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Circle avatar placeholder
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE0F7F7), // slightly lighter teal
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Name
                  Text(
                    _user?.displayName ?? 'Bushra Sayed',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),

            // Box for "Change Username"
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Heading with icon
                  Row(
                    children: const [
                      Icon(Icons.person, color: Color(0xFF444444)),
                      SizedBox(width: 8),
                      Text(
                        'Change Username',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF444444),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLabelWithTextField(
                    label: 'Enter new username',
                    hint: 'Enter new username',
                    controller: _usernameController,
                    obscureText: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Box for "Change Password"
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Heading with icon
                  Row(
                    children: const [
                      Icon(Icons.lock, color: Color(0xFF444444)),
                      SizedBox(width: 8),
                      Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF444444),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLabelWithTextField(
                    label: 'Enter current password',
                    hint: 'Enter current password',
                    controller: _currentPasswordController,
                    obscureText: !_showCurrentPassword,
                    isPassword: true,
                    toggleVisibility: () {
                      setState(() {
                        _showCurrentPassword = !_showCurrentPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLabelWithTextField(
                    label: 'Enter new password',
                    hint: 'Enter new password',
                    controller: _newPasswordController,
                    obscureText: !_showNewPassword,
                    isPassword: true,
                    toggleVisibility: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildLabelWithTextField(
                    label: 'Confirm new password',
                    hint: 'Confirm new password',
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    isPassword: true,
                    toggleVisibility: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Preferences Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF444444),
                  ),
                ),
                value: _emailNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
                secondary: const Icon(
                  Icons.email,
                  color: Color(0xFF888888),
                ),
                activeColor: const Color(0xFFA4DEDE),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Save Changes Button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6FD0D0), // teal-ish button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // A helper widget to build the label and text field with an optional visibility toggle
  Widget _buildLabelWithTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
    bool isPassword = false,
    VoidCallback? toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // Text Field
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
            fillColor: const Color(0xFFE5F4F4),
            filled: true,
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF999999),
              ),
              onPressed: toggleVisibility,
            )
                : null,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  // The method called when user taps "Save Changes"
  void _saveChanges() async {
    // 1. Check password fields if user tries to update them
    if (_newPasswordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New passwords do not match')),
        );
        return;
      }
    }

    // 2. Update Username if needed
    try {
      if (_usernameController.text.isNotEmpty &&
          _usernameController.text != _user?.displayName) {
        await _user?.updateDisplayName(_usernameController.text);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating username: $e')),
      );
    }

    // 3. Update Password if needed (requires reauth)
    if (_currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty) {
      try {
        if (_user?.email != null) {
          final AuthCredential credential = EmailAuthProvider.credential(
            email: _user!.email!,
            password: _currentPasswordController.text,
          );
          await _user!.reauthenticateWithCredential(credential);
          await _user!.updatePassword(_newPasswordController.text);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating password: $e')),
        );
        return;
      }
    }

    // 4. Email Notifications preference -> store if needed

    // 5. Show success message and pop
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings updated successfully')),
    );
    Navigator.pop(context);
  }
}
