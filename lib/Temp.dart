import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

import 'MODELS/BannerModal.dart'; // Import your model

class BannerCarouselPage extends StatefulWidget {
  const BannerCarouselPage({super.key});

  @override
  State<BannerCarouselPage> createState() => _BannerCarouselPageState();
}

class _BannerCarouselPageState extends State<BannerCarouselPage> {
  List<String> bannerImages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchBanners();
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
          _loading = false;
        });
      } else {
        throw Exception('Failed to fetch banners');
      }
    } catch (e) {
      setState(() => _loading = false);
      debugPrint('Error fetching banners: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.55; // smaller than full 16:9

    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : bannerImages.isEmpty
          ? const Center(child: Text('No banners found'))
          : CarouselSlider(
        options: CarouselOptions(
          height: bannerHeight,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.95, // almost full width
          autoPlayInterval: const Duration(seconds: 4),
        ),
        items: bannerImages.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  width: screenWidth,
                  height: bannerHeight,
                  color: Colors.grey[200], // fallback background
                  alignment: Alignment.center,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain, // fully visible, no cropping
                    width: screenWidth,
                    height: bannerHeight,
                    loadingBuilder: (context, child, progress) {
                      return progress == null
                          ? child
                          : const Center(
                          child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error,
                        color: Colors.red, size: 50),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
