// import 'dart:convert';
// import 'dart:math';

// import 'package:supermarket/widgets/app_placeholder.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import '../../configs/application.dart';
// import '../../configs/routes.dart';
// import '../../models/model_category.dart';
// import '../../models/model_home_section.dart';
// import '../../repository/category_repository.dart';
// import '../../utils/icon.dart';
// import '../../utils/translate.dart';

// class Categories extends StatefulWidget {
//   final HomeSectionModel section;

//   const Categories({Key? key, required this.section}) : super(key: key);

//   @override
//   _CategoriesState createState() => _CategoriesState();
// }

// class _CategoriesState extends State<Categories>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//   List<int> categories = [];
//   List<dynamic>? _cachedData;

//   @override
//   Widget build(BuildContext context) {
//     final listString = widget.section.extendedAttributes!
//             .any((element) => element.key == 'list')
//         ? widget.section.extendedAttributes!
//             .firstWhere((element) => element.key == 'list')
//             .json
//         : null;
//     final list = listString != null ? jsonDecode(listString) : [];
//     categories = [];
//     if (list != null) {
//       for (var item in list) {
//         categories.add(item['CategoryId']);
//       }
//     } else {
//       return Container();
//     }
//     list?.sort((a, b) {
//       int priorityA = int.tryParse(a['Priority'].toString()) ?? 0;
//       int priorityB = int.tryParse(b['Priority'].toString()) ?? 0;
//       return priorityA.compareTo(priorityB);
//     });

//     Random random = Random();
//     return FutureBuilder<List<dynamic>?>(
//         key: Key(random.nextInt(999999999).toString()),
//         initialData: [_cachedData],
//         future: _cachedData == null
//             ? CategoryRepository.loadList(
//                 pageNumber: 1, pageSize: list.length, list: categories)
//             : Future.value([_cachedData]),

//         /// Adding data by updateDataSource method
//         builder: (BuildContext futureContext,
//             AsyncSnapshot<List<dynamic>?> snapShot) {
//           if (snapShot.connectionState != ConnectionState.done &&
//               (_cachedData == null || _cachedData!.isEmpty)) {
//             return AppPlaceholder(
//                 child: Container(
//               height: 250,
//               width: double.infinity,
//             ));
//           }
//           if (snapShot.data![0] == null && _cachedData == null) {
//             return Container();
//           }
//           if (_cachedData == null && snapShot.data?[0] != null) {
//             _cachedData = snapShot.data![0];
//           }
//           List<CategoryModel> data = [];
//           for (var item in list) {
//             if ((snapShot.data![0] as List<CategoryModel>)
//                 .any((e) => e.id == item['CategoryId'])) {
//               data.add((snapShot.data![0] as List<CategoryModel>)
//                   .firstWhere((e) => e.id == item['CategoryId']));
//             }
//           }
//           return Container(
//             // width: MediaQuery.of(context).size.width,
//             color:
//                 Color(int.parse('0x${widget.section.color}')).withOpacity(0.7),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: double.infinity,
//                   height: 240,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 16, right: 8, left: 8),
//                     child: GridView.builder(
//                       scrollDirection: Axis.horizontal,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       // shrinkWrap: true,
//                       itemCount: list.length,
//                       gridDelegate:
//                           const SliverGridDelegateWithMaxCrossAxisExtent(
//                               maxCrossAxisExtent: 200,
//                               childAspectRatio: 1.5,
//                               crossAxisSpacing: 10,
//                               mainAxisSpacing: 10),
//                       itemBuilder: (context, index) {
//                         return InkWell(
//                           onTap: () {
//                             Navigator.of(context).pushNamed(Routes.listProduct,
//                                 arguments: {'categoryId': data[index].id});
//                           },
//                           child: Column(
//                             children: [
//                               Container(
//                                   width: 60,
//                                   height: 60,
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Color(
//                                         int.parse('0x${widget.section.color}')),
//                                   ),
//                                   child: CachedNetworkImage(
//                                     imageUrl: list[index]['Image'] != null
//                                         ? '${Application.domain}${list[index]['Image'].replaceAll('\\', '/').replaceAll('TYPE', 'full')}'
//                                         : '${Application.domain}${data[index].image?.replaceAll('\\', '/').replaceAll('TYPE', 'full')}',
//                                     imageBuilder: (context, imageProvider) {
//                                       return Image(
//                                         image: imageProvider,
//                                         fit: BoxFit.cover,
//                                       );
//                                     },
//                                     colorBlendMode: BlendMode.color,
//                                     filterQuality: FilterQuality.high,
//                                     width: 50,
//                                     height: 50,
//                                   )),
//                               const SizedBox(height: 4),
//                               Text(
//                                 data[index].name,
//                                 textAlign: TextAlign.center,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(fontSize: 15),
//                               )
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }
