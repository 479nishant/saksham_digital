import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saksham_digital/MCQ.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'Ceritificates/CertificateReq.dart';
import 'Courses/Courses.dart';
import 'InternshipPage/InternshipPage.dart';
import 'MODELS/TestimonialModel.dart';
import 'Tutorial/Tutorial.dart';
import 'User/UserInfo.dart';
import 'MODELS/BannerModal.dart';

const Color primaryRed = Color(0xFFE91E63);
const Color lightGrey = Color(0xFFF0F0F0);

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  int _selectedIndex = 0;

  // WhatsApp draggable position
  double whatsappLeft = 15;
  double whatsappBottom = 120;

  final List<Widget> _pages = [
    const TestContentPage(),
    const CoursePage(),
    const UpdateUserInfoPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  Future<void> launchWhatsApp({ required String phone, String message = "" }) async {
    // Encode message
    final String encodedMsg = Uri.encodeComponent(message);

    // Build URLs for Android & iOS
    final String androidUrl = "whatsapp://send?phone=$phone&text=$encodedMsg";
    final String iosUrl = "https://wa.me/$phone?text=$encodedMsg";
    final String webFallback = "https://api.whatsapp.com/send?phone=$phone&text=$encodedMsg";

    try {
      if (Platform.isAndroid) {
        final Uri uri = Uri.parse(androidUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // fallback to web
          await launchUrl(Uri.parse(webFallback), mode: LaunchMode.externalApplication);
        }
      } else if (Platform.isIOS) {
        final Uri uri = Uri.parse(iosUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // fallback to web
          await launchUrl(Uri.parse(webFallback), mode: LaunchMode.externalApplication);
        }
      } else {
        // other platforms fallback
        await launchUrl(Uri.parse(webFallback), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error launching WhatsApp: $e");
      // as a last fallback
      await launchUrl(Uri.parse(webFallback), mode: LaunchMode.externalApplication);
    }
  }

  // Future<void> _launchWhatsApp() async {
  //
  //     final Uri whatsappUrl = Uri.parse('https://api.whatsapp.com/send?phone=7223077806&text=Hello!');
  //
  //
  //     if (await canLaunchUrl(whatsappUrl)) {
  //       await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  //     } else {
  //
  //       debugPrint("Could not launch WhatsApp.");
  //     }
  //   }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Saksham',
              style: TextStyle(
                color: primaryRed,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    enableDrag: false,
                    showDragHandle: true,
                    context: context,
                    builder: (context) {
                      Future.delayed(const Duration(seconds: 6), () {
                        if (Navigator.of(context).canPop()) Navigator.pop(context);
                      });
                      return SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "NO NOTIFICATIONS 🛸",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 300,
                                child: Image.network(
                                  "https://img.freepik.com/premium-vector/nothing-here-flat-illustration_418302-77.jpg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.notifications, color: Colors.black54),
              ),
              const SizedBox(width: 5),
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.black54),
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // open the drawer
                  },
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: primaryRed),
                  child: Center(
                    child: Text(
                      "Settings",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Profile"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UpdateUserInfoPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text("Notifications"),
                  onTap: () {
                    Navigator.pop(context);
                    // Open notifications page or modal
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () {
                    Navigator.pop(context);
                    // Add logout logic here
                  },
                ),
              ],
            ),
          ),
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: primaryRed,
            unselectedItemColor: Colors.black54,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school_outlined),
                label: 'Courses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
        Positioned(
          bottom: whatsappBottom,
          left: whatsappLeft,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                whatsappLeft += details.delta.dx;
                whatsappBottom -= details.delta.dy;
                whatsappLeft = whatsappLeft.clamp(0.0, MediaQuery.of(context).size.width - 60);
                whatsappBottom = whatsappBottom.clamp(0.0, MediaQuery.of(context).size.height - 120);
              });
            },
            child: FloatingActionButton(
              heroTag: 'whatsapp',
              onPressed: (){
                launchWhatsApp(phone: "+917223077806", message: "Hello!");
              },
              backgroundColor: Colors.green,
              child: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}

// ------------------- Home Content -------------------

// Change this to your actual path

class TestContentPage extends StatefulWidget {
  const TestContentPage({super.key});

  @override
  State<TestContentPage> createState() => _TestContentPageState();
}

class _TestContentPageState extends State<TestContentPage> {
  List<String> bannerImages = [];
  bool _loadingBanners = true;

  // New: testimonials state
  List<Testimonial> testimonials = [];
  bool _loadingTestimonials = true;

  @override
  void initState() {
    super.initState();
    fetchBanners();
    fetchTestimonials();  // fetch testimonials along with banners
  }

  Future<void> fetchBanners() async {
    const url = 'https://sakshamdigitaltechnology.com/api/banners';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final bannerResponse = BannerResponse.fromJson(jsonData);
        setState(() {
          bannerImages = bannerResponse.data.map((b) => b.image).toList();
          _loadingBanners = false;
        });
      } else {
        throw Exception('Failed to fetch banners: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _loadingBanners = false;
      });
      debugPrint('Error fetching banners: $e');
    }
  }

  Future<void> fetchTestimonials() async {
    const url = 'https://sakshamdigitaltechnology.com/api/student-testimonials';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Assuming your model has something like:
        // TestimonialsResponse.fromJson(jsonData)
        final resp = TestimonialsResponse.fromJson(jsonData);
        setState(() {
          testimonials = resp.data;
          _loadingTestimonials = false;
        });
      } else {
        throw Exception('Failed to load testimonials: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _loadingTestimonials = false;
      });
      debugPrint('Error fetching testimonials: $e');
    }
  }

  void _showCertificateVerifyOverlay() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        final TextEditingController certController = TextEditingController();
        final TextEditingController dobController = TextEditingController();

        bool loading = false;
        String? responseMessage;
        Map<String, dynamic>? responseData;

        Future<void> pickDob() async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2000, 1, 1),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            dobController.text =
            "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          }
        }

        Future<void> verifyCertificate() async {
          if (!_formKey.currentState!.validate()) return;

          final payload = {
            "certificate_number": certController.text.trim(),
            "dob": dobController.text.trim(),
          };

          loading = true;
          responseMessage = null;
          responseData = null;
          (context as Element).markNeedsBuild();

          try {
            final response = await http.post(
              Uri.parse("https://sakshamdigitaltechnology.com/api/certificate/verify"),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(payload),
            );

            loading = false;

            if (response.statusCode == 200) {
              final body = jsonDecode(response.body);
              responseData = body;
              responseMessage = "Verification Success ✅";
            } else {
              String msg = "Error ${response.statusCode}";
              try {
                final body = jsonDecode(response.body);
                if (body is Map && body["message"] != null) {
                  msg = body["message"].toString();
                }
              } catch (_) {}
              responseMessage = msg;
            }
          } catch (e) {
            loading = false;
            responseMessage = "Exception: $e";
          }

          (context as Element).markNeedsBuild();
        }

        Widget buildInfoRow(String label, String value) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Flexible(
                child: Text(value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ),
            ],
          );
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Certificate Verification",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: primaryRed),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: certController,
                        validator: (value) =>
                        value == null || value.isEmpty ? "Enter Certificate Number" : null,
                        decoration: const InputDecoration(
                          labelText: "Certificate Number",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: dobController,
                        readOnly: true,
                        onTap: pickDob,
                        validator: (value) =>
                        value == null || value.isEmpty ? "Select Date of Birth" : null,
                        decoration: const InputDecoration(
                          labelText: "Date of Birth",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: loading
                              ? null
                              : () async {
                            setState(() => loading = true);
                            await verifyCertificate();
                            setState(() => loading = false);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryRed,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 5,
                            shadowColor: primaryRed.withOpacity(0.4),
                          ),
                          child: loading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            "Verify",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      if (responseMessage != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: responseData != null ? Colors.green : Colors.red,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                responseMessage!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                  responseData != null ? Colors.green[800] : Colors.red[800],
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (responseData != null) ...[
                                buildInfoRow("Certificate No", responseData!["certificate_number"] ?? "-"),
                                const SizedBox(height: 8),
                                buildInfoRow("Name", responseData!["name"] ?? "-"),
                                const SizedBox(height: 8),
                                buildInfoRow("Date of Birth", responseData!["dob"] ?? "-"),
                                const SizedBox(height: 8),
                                buildInfoRow("Course", responseData!["course"] ?? "-"),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTestimonialsList() {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 280,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: testimonials.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final t = testimonials[index];
          final imageUrl =
              'https://sakshamdigitaltechnology.com/uploads/student-testimonial/${t.image}';

          return SizedBox(
            width: screenWidth * 0.85,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              color: Colors.white,
              shadowColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 60),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            t.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            t.designation,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                t.feedback,
                                style: const TextStyle(fontSize: 14, height: 1.4),
                                softWrap: true,
                              ),
                            ),
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
      ),
    );
  }






  Widget _buildCategoryGrid(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'title': 'Courses', 'icon': Icons.book_outlined, 'page': const CoursePage()},
      {'title': 'Tutorials', 'icon': Icons.play_circle_outline, 'page': const TutorialsPage()},
      {'title': 'Certificates', 'icon': Icons.workspace_premium_outlined, 'page': const Certificatereq()},
      {'title': 'Internships', 'icon': Icons.work_outline, 'page': const InternshipPage()},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      childAspectRatio: 1.5,
      children: categories
          .map((item) => _buildCategoryCard(
        context,
        item['title'] as String,
        item['icon'] as IconData,
        item['page'] as Widget,
      ))
          .toList(),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String title, IconData icon, Widget page) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryRed, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => page));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: primaryRed),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedContentGrid() {
    final List<Map<String, dynamic>> featuredItems = [
      {
        'title': 'Certificate\nVerify',
        'icon': Icons.workspace_premium_outlined,
      },
      {
        'title': 'Test:\nMaster Skills',
        'icon': Icons.newspaper,
      },
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      childAspectRatio: 1.0,
      children: featuredItems
          .map((item) => InkWell(
        onTap: () {
          if ((item['title'] as String).contains("Certificate")) {
            _showCertificateVerifyOverlay();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Mcq()),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(item['icon'] as IconData, size: 30, color: primaryRed),
              Text(
                item['title'] as String,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.55;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _loadingBanners
              ? const Center(child: CircularProgressIndicator())
              : bannerImages.isEmpty
              ? const SizedBox.shrink()
              : CarouselSlider(
            options: CarouselOptions(
              height: bannerHeight,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.95,
              autoPlayInterval: const Duration(seconds: 4),
            ),
            items: bannerImages.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return SizedBox(
                    width: screenWidth,
                    height: bannerHeight,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        width: screenWidth,
                        height: bannerHeight,
                        loadingBuilder: (context, child, progress) {
                          return progress == null
                              ? child
                              : const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, color: Colors.red, size: 50),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _buildCategoryGrid(context),
          const SizedBox(height: 24),
          Text(
            'Featured Content',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeaturedContentGrid(),
          const SizedBox(height: 24),
          Text(
            'Student Testimonials',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _loadingTestimonials
              ? const Center(child: CircularProgressIndicator())
              : testimonials.isEmpty
              ? const Text('No testimonials available')
              : _buildTestimonialsList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }



}

