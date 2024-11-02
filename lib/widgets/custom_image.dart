import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_media_server_app/apis/base_api.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height, 
    this.disableAdaptiveImage = false,
  });

  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final bool disableAdaptiveImage;

  @override
  Widget build(BuildContext context) {
    String addon = "";

    if (width?.isFinite ?? false) {
      addon = "?width=${width?.floor()}";
    }

    return CachedNetworkImage(
      imageUrl: "$imageUrl$addon",
      fit: fit,
      width: width,
      height: height,
      httpHeaders: BaseApi.getHeaders(),
    );
  }
}
