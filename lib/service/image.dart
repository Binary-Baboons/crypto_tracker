import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageService {
  Widget? getImage(String? imageUrl, double size) {
    if (imageUrl == null) {
      return const Icon(Icons.error);
    }

    var url = imageUrl.split('?');
    int length = url[0].length;
    String lastThreeCharacters = url[0].substring(length - 3);

    if (lastThreeCharacters == "svg") {
      return SvgPicture.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.scaleDown,
        placeholderBuilder: (builder) => const Icon(Icons.downloading),
      );
    } else {
      return Image.network(
        imageUrl,
        width: size,
        cacheHeight: size.toInt() * 3,
        cacheWidth: size.toInt() * 3,
        height: size,
        fit: BoxFit.scaleDown,
      );
    }
  }
}