import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../configs/language.dart';
import '../../models/model_home_section.dart';
import '../../utils/other.dart';

class AdsSection extends StatefulWidget {
  final HomeSectionModel section;

  const AdsSection({Key? key, required this.section}) : super(key: key);

  @override
  _AdsSectionState createState() => _AdsSectionState();
}

class _AdsSectionState extends State<AdsSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final listString = widget.section.extendedAttributes!
            .any((element) => element.key == 'list')
        ? widget.section.extendedAttributes!
            .firstWhere((element) => element.key == 'list')
            .json
        : null;
    final list = listString != null ? jsonDecode(listString) : [];
    final item = list.first;

    Random random = Random();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        key: Key(random.nextInt(999999999).toString()),
        child: item['ViewType'] == 'H'
            ? AdsHCard(data: item)
            : AdsVCard(data: item),
      ),
    );
  }
}

class AdsHCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const AdsHCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          UtilOther.ShowProduct(
              context: context,
              productId: data['ProductId'],
              categoryId: data['CategoryId']);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Image.network(
                      data['Image'] != null
                          ? data['Image']!
                              .replaceAll("\\", "/")
                              .replaceAll("/temp", "")
                              .replaceAll("TYPE", "full")
                          : '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['Name'],
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Expanded(
                              child: Text(
                                data['Description'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 8,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (data['IsSponsored'])
                Positioned(
                  right: AppLanguage.isRTL() ? 2 : null,
                  left: AppLanguage.isRTL() ? null : 2,
                  top: 2,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'ممول',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class AdsVCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const AdsVCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          UtilOther.ShowProduct(
              context: context,
              productId: data['ProductId'],
              categoryId: data['CategoryId']);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                data['Image'] != null
                    ? data['Image']!
                        .replaceAll("\\", "/")
                        .replaceAll("/temp", "")
                        .replaceAll("TYPE", "full")
                    : '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ),
              if (data['IsSponsored'])
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'ممول',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        data['Name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['Description'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
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
}
