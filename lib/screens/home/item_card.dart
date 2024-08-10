import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

String _getImage(String imageID) {
  return 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/2012_Toyota_Camry_%28ASV50R%29_Altise_sedan_%282014-09-06%29.jpg/260px-2012_Toyota_Camry_%28ASV50R%29_Altise_sedan_%282014-09-06%29.jpg';
}

Stack getItemCard(var img, var name, var price) {
  return Stack(
    children: [
      Align(
        alignment: Alignment.topRight,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _getImage(img).isNotEmpty
                ? Image.network(_getImage(img), height: 120)
                : SizedBox(
                    width: 120.0,
                    height: 120.0,
                    child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: 500.0,
                          height: 500.0,
                          color: Colors.white,
                        )),
                  ),
            Text(name,
                style: const TextStyle(
                    fontFamily: 'Beheshti',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black)),
          ],
        ),
      ),
      const Align(
          alignment: Alignment.bottomRight,
          child: Icon(
            CupertinoIcons.cart_badge_plus,
            size: 22,
            color: Color(0xFF207D4C),
          )),
      Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            height: 20,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                Text(price is double ? price.toString() : price,
                    style: const TextStyle(
                        fontFamily: 'Beheshti',
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black)),
                const Text(r"$",
                    style: TextStyle(
                        fontFamily: 'Beheshti',
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.black)),
              ],
            ),
          ))
    ],
  );
}
