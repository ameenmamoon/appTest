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

// class Categories2 extends StatefulWidget {
//   final HomeSectionModel section;

//   const Categories2({Key? key, required this.section}) : super(key: key);

//   @override
//   _Categories2State createState() => _Categories2State();
// }

// class _Categories2State extends State<Categories2>
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
//     return Padding(
//       key: Key(random.nextInt(999999999).toString()),
//       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: Stack(
//               children: [
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Text(widget.section.title,
//                       style: Theme.of(context).textTheme.titleMedium),
//                 ),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Icon(
//                     UtilIcon.faIconNameMapping[widget.section.icon!],
//                     size: 30,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           FutureBuilder<List<dynamic>?>(
//               initialData: [_cachedData],
//               future: _cachedData == null
//                   ? CategoryRepository.loadList(
//                       pageNumber: 1, pageSize: list.length, list: categories)
//                   : Future.value([_cachedData]),

//               /// Adding data by updateDataSource method
//               builder: (BuildContext futureContext,
//                   AsyncSnapshot<List<dynamic>?> snapShot) {
//                 return GridView.builder(
//                   itemCount: categories.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 8,
//                     mainAxisSpacing: 8,
//                     childAspectRatio: 1,
//                   ),
//                   itemBuilder: (context, index) {
//                     if (snapShot.connectionState != ConnectionState.done &&
//                         (_cachedData == null || _cachedData!.isEmpty)) {
//                       return AppPlaceholder(
//                           child: Container(
//                         height: 150,
//                         width: double.infinity,
//                       ));
//                     }
//                     if (snapShot.data == null && _cachedData == null) {
//                       return Container();
//                     }
//                     if (_cachedData == null && snapShot.data?[0] != null) {
//                       _cachedData = snapShot.data![0];
//                     }
//                     List<CategoryModel> data = [];
//                     for (var item in list) {
//                       if ((snapShot.data![0] as List<CategoryModel>)
//                           .any((e) => e.id == item['CategoryId'])) {
//                         data.add((snapShot.data![0] as List<CategoryModel>)
//                             .firstWhere((e) => e.id == item['CategoryId']));
//                       }
//                     }
//                     final category = data[index];
//                     return CategoryCard(category: category, data: list[index]);
//                   },
//                   padding: const EdgeInsets.all(8),
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                 );
//               }),
//         ],
//       ),
//     );
//   }
// }

// class CategoryCard extends StatelessWidget {
//   final CategoryModel category;
//   final Map<String, dynamic> data;

//   const CategoryCard({required this.category, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             spreadRadius: 2,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context).pushNamed(Routes.listProduct,
//               arguments: {'categoryId': category.id});
//         },
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               CachedNetworkImage(
//                 imageUrl: data['Image'] != null
//                     ? '${Application.domain}${data['Image'].replaceAll('\\', '/').replaceAll('TYPE', 'full')}'
//                     : '${Application.domain}${category.image?.replaceAll('\\', '/').replaceAll('TYPE', 'full')}',
//                 imageBuilder: (context, imageProvider) {
//                   return Image(
//                     image: imageProvider,
//                     fit: BoxFit.cover,
//                   );
//                 },
//                 placeholder: (context, url) {
//                   return AppPlaceholder(
//                     child: Container(
//                       width: double.infinity,
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.rectangle,
//                       ),
//                     ),
//                   );
//                 },
//                 errorWidget: (context, url, error) {
//                   return AppPlaceholder(
//                     child: Container(
//                       width: double.infinity,
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.rectangle,
//                       ),
//                       child: const Icon(Icons.error),
//                     ),
//                   );
//                 },
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.black.withOpacity(0.4),
//                       Colors.black.withOpacity(0.1),
//                     ],
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Padding(
//                   padding: EdgeInsets.all(8),
//                   child: Text(
//                     category.name,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ),
//               ),
//               if (data['HasDiscount'])
//                 Positioned(
//                   top: 8,
//                   left: 8,
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       '${data['Discount']} % ${Translate.of(context).translate('discount')}',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
