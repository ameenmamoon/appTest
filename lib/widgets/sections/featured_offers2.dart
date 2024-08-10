import 'dart:convert';

import 'package:supermarket/configs/config.dart';
import 'package:supermarket/configs/routes.dart';
import 'package:supermarket/constants/constants.dart';
import 'package:supermarket/constants/responsive.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/widgets/app_placeholder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../models/model_home_section.dart';

class FeaturedOffers2 extends StatefulWidget {
  final String image;
  final Color color;
  final List<ProductModel> list;

  const FeaturedOffers2(
      {Key? key, required this.image, required this.color, required this.list})
      : super(key: key);

  @override
  _FeaturedOffers2State createState() => _FeaturedOffers2State();
}

class _FeaturedOffers2State extends State<FeaturedOffers2>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://ool.ibest.lol/wp-content/uploads/2022/07/Kera-We-El-Gin.jpg', //'${Application.domain}${widget.section.image?.replaceAll('\\', '/').replaceAll('TYPE', 'full')}',
                      imageBuilder: (context, imageProvider) {
                        return Image(
                          image: imageProvider,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          // height: 150,
                        );
                      },
                      placeholder: (context, url) {
                        return AppPlaceholder(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return AppPlaceholder(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                            ),
                            child: const Icon(Icons.error),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var item in widget.list) ...[
                        InkWell(
                          onTap: () {
                            // Navigator.of(context).pushNamed(item['url']!,
                            //     arguments: item['arguments']);
                          },
                          child: Column(
                            children: [
                              Image.network(
                                'https://ool.ibest.lol/wp-content/uploads/2022/07/Kera-We-El-Gin.jpg', //item['image'],
                                height: 280,
                                fit: BoxFit.fitHeight,
                                width: MediaQuery.of(context).size.width / 3.2,
                              ),
                              Text(
                                'name', //item['name'],
                                style: const TextStyle(fontSize: 16),
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(
                        //   width: 5,
                        // ),
                      ],
                    ],
                  ),
                ),
                // if (seeMore != null) ...[
                //   const Divider(),
                //   InkWell(
                //     onTap: () {
                //       // Navigator.of(context).pushNamed(seeMore['url']!,
                //       //     arguments: seeMore['arguments']);
                //     },
                //     child: Container(
                //       padding:
                //           const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                //       alignment: AppLanguage.isRTL()
                //           ? Alignment.topRight
                //           : Alignment.topLeft,
                //       child: Text(
                //         seeMore['title'] ?? '',
                //         style: TextStyle(
                //             color: seeMore['color'] != null
                //                 ? Color(int.parse(seeMore['color']))
                //                 : const Color(0xFF00838F)),
                //       ),
                //     ),
                //   ),
                // ]
              ],
            ),
          ),
          const Divider(
            height: 20,
            thickness: 5,
            color: Color.fromARGB(255, 214, 219, 220),
          ),
        ],
      ),
    );
  }
}
