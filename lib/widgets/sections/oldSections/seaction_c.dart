import 'dart:convert';

import 'package:supermarket/configs/config.dart';
import 'package:supermarket/configs/routes.dart';
import 'package:supermarket/constants/constants.dart';
import 'package:supermarket/constants/responsive.dart';
import 'package:supermarket/models/model_home_section.dart';
import 'package:supermarket/widgets/app_placeholder.dart';
import 'package:flutter/material.dart';

class FeaturedOffers3 extends StatefulWidget {
  final HomeSectionModel section;

  const FeaturedOffers3({Key? key, required this.section}) : super(key: key);

  @override
  _FeaturedOffers3State createState() => _FeaturedOffers3State();
}

class _FeaturedOffers3State extends State<FeaturedOffers3>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<int> featureOffers = [];
  List<dynamic>? _cachedData;

  void navigateToCategory(BuildContext context, String category) {
    // Navigator.pushNamed(context, CategoryDealsScreen.routeName,
    //     arguments: category);
  }

  @override
  Widget build(BuildContext context) {
    final listString = widget.section.extendedAttributes!
            .any((element) => element.key == 'list')
        ? widget.section.extendedAttributes!
            .firstWhere((element) => element.key == 'list')
            .json
        : null;
    final list = listString != null ? jsonDecode(listString) : [];

    featureOffers = [];
    if (list != null) {
      for (var item in list) {
        featureOffers.add(item['ProductId']);
      }
    } else {
      return Container();
    }
    list?.sort((a, b) {
      int priorityA = int.tryParse(a['Priority'].toString()) ?? 0;
      int priorityB = int.tryParse(b['Priority'].toString()) ?? 0;
      return priorityA.compareTo(priorityB);
    });
    final color = widget.section.color!.isNotEmpty
        ? Color(int.parse(widget.section.color!))
        : Colors.white;

    final seeMore = widget.section.extendedAttributes!
            .any((element) => element.key == 'see-more')
        ? jsonDecode(widget.section.extendedAttributes!
            .singleWhere((element) => element.key == 'see-more')
            .json!)
        : null;

    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemCount: 3, //data!['list'].length,
        scrollDirection: Axis.horizontal,
        itemExtent: 75,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () =>
                // navigateToCategory(context, data!['list'][index]['name']!),
                navigateToCategory(context, 'name'),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.network(
                    'https://ool.ibest.lol/wp-content/uploads/2022/07/Kera-We-El-Gin.jpg', //data!['list'][index]['image']!,
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                  ),
                  /*ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      GlobalVariables.categoryImages[index]['image']!,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ),
                  ),*/
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'name', //data!['list'][index]['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
