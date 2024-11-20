import 'package:flutter/material.dart';
import 'package:usicat/audio/data/service/service.dart';

class CustomNetImage extends StatelessWidget {
  const CustomNetImage({super.key, required this.url, this.width, this.height});
  final String url;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    var imgURL = AudioApiService.baseUrl;
    imgURL = imgURL.replaceAll('api/v2', '');
    return Image.network(
      '$imgURL/$url',
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
