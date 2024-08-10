import 'dart:convert';
import 'dart:math';

import 'package:supermarket/configs/config.dart';
import 'package:supermarket/widgets/app_user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../configs/application.dart';
import '../../models/model_home_section.dart';
import '../../models/model_user.dart';
import '../../repository/user_repository.dart';
import '../../utils/icon.dart';

class FeaturedSellers extends StatefulWidget {
  final HomeSectionModel section;

  const FeaturedSellers({Key? key, required this.section}) : super(key: key);

  @override
  _FeaturedSellersState createState() => _FeaturedSellersState();
}

class _FeaturedSellersState extends State<FeaturedSellers>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<String> featuredSellers = [];
  List<dynamic>? _cachedData;

  @override
  Widget build(BuildContext context) {
    final listString = widget.section.extendedAttributes!
            .any((element) => element.key == 'list')
        ? widget.section.extendedAttributes!
            .firstWhere((element) => element.key == 'list')
            .json
        : null;
    final list = listString != null ? jsonDecode(listString) : [];
    featuredSellers = [];
    if (list != null) {
      for (var item in list) {
        featuredSellers.add(item['UserId']);
      }
    } else {
      return Container();
    }

    Random random = Random();
    return FutureBuilder<List<dynamic>?>(
        key: Key(random.nextInt(999999999).toString()),
        initialData: [_cachedData],
        future: _cachedData == null
            ? UserRepository.loadProfiles(
                pageNumber: 1, pageSize: list.length, list: featuredSellers)
            : Future.value([_cachedData]),

        /// Adding data by updateDataSource method
        builder: (BuildContext futureContext,
            AsyncSnapshot<List<dynamic>?> snapShot) {
          if (snapShot.connectionState != ConnectionState.done &&
              (_cachedData == null || _cachedData!.isEmpty)) {
            return const AppUserInfo(type: UserViewType.basic);
          }
          List<UserModel> data = [];
          list?.sort((a, b) {
            int priorityA = int.tryParse(a['Priority'].toString()) ?? 0;
            int priorityB = int.tryParse(b['Priority'].toString()) ?? 0;
            return priorityA.compareTo(priorityB);
          });
          if (snapShot.data == null && _cachedData == null) return Container();
          if (_cachedData == null && snapShot.data?[0] != null) {
            _cachedData = snapShot.data![0];
          }
          for (var item in list) {
            data.add((snapShot.data![0] as List<UserModel>)
                .firstWhere((e) => e.userId == item['UserId']));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(widget.section.title,
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          UtilIcon.faIconNameMapping[widget.section.icon!],
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: featuredSellers.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.profile,
                              arguments: data[index].userId);
                        },
                        child: SellerCard(seller: data[index]),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}

class SellerCard extends StatelessWidget {
  final UserModel seller;

  const SellerCard({required this.seller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: 270,
      padding: const EdgeInsets.all(16),
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
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (seller.profilePictureDataUrl.isNotEmpty)
            CircleAvatar(
              backgroundImage: NetworkImage(
                  '${Application.domain}${seller.profilePictureDataUrl.replaceAll('\\', '/').replaceAll('TYPE', 'thumb')}'),
              radius: 40,
            ),
          if (seller.profilePictureDataUrl.isEmpty)
            const CircleAvatar(
              backgroundImage: AssetImage(Images.user),
              radius: 40,
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  seller.firstName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2, // تحديد الحد الأقصى لعدد الخطوط
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                RatingBarIndicator(
                  rating: seller.ratingAvg,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 15.0,
                  direction: Axis.horizontal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// class SellerCard extends StatelessWidget {
//   final UserModel seller;

//   const SellerCard({required this.seller});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       height: 100,
//       width: 270,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             spreadRadius: 2,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         color: Colors.white,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           if (seller.profilePictureDataUrl.isNotEmpty)
//             CircleAvatar(
//               backgroundImage: NetworkImage(
//                   '${Application.domain}${seller.profilePictureDataUrl.replaceAll('\\', '/').replaceAll('TYPE', 'thumb')}'),
//               radius: 40,
//             ),
//           if (seller.profilePictureDataUrl.isEmpty)
//             const CircleAvatar(
//               backgroundImage: AssetImage(Images.user),
//               radius: 40,
//             ),
//           const SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 seller.firstName,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               RatingBarIndicator(
//                 rating: seller.ratingAvg,
//                 itemBuilder: (context, index) => const Icon(
//                   Icons.star,
//                   color: Colors.amber,
//                 ),
//                 itemCount: 5,
//                 itemSize: 15.0,
//                 direction: Axis.horizontal,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
