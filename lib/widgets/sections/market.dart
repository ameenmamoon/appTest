import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/model_home_section.dart';

class MarketSection {
  final int id;
  final String title;
  final String imageUrl;

  MarketSection(
      {required this.id, required this.title, required this.imageUrl});
}

class MarketSectionsWidget extends StatelessWidget {
  final List<MarketSection> marketSections = [
    MarketSection(
      id: 1,
      title: 'الأزياء',
      imageUrl: 'https://via.placeholder.com/100x100',
    ),
    MarketSection(
      id: 2,
      title: 'الإلكترونيات',
      imageUrl: 'https://via.placeholder.com/100x100',
    ),
    MarketSection(
      id: 3,
      title: 'الكتب',
      imageUrl: 'https://via.placeholder.com/100x100',
    ),
    // إضافة المزيد من الأقسام هنا
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: marketSections.length,
      itemBuilder: (context, index) {
        return MarketSectionCard(marketSection: marketSections[index]);
      },
    );
  }
}

class MarketSectionCard extends StatelessWidget {
  final MarketSection marketSection;

  const MarketSectionCard({Key? key, required this.marketSection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            marketSection.imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8),
        Text(
          marketSection.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
