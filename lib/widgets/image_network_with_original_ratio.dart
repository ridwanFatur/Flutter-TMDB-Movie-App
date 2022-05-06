import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/asset_constants.dart';

class ImageNetworkWithOriginalRatio extends StatefulWidget {
  final String url;
  final Object tagHero;
  const ImageNetworkWithOriginalRatio(
      {Key? key, required this.url, required this.tagHero})
      : super(key: key);

  @override
  State<ImageNetworkWithOriginalRatio> createState() =>
      _ImageNetworkWithOriginalRationStat();
}

class _ImageNetworkWithOriginalRationStat
    extends State<ImageNetworkWithOriginalRatio> {
  double? aspectRatio;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  void loadImage() {
    Image image = Image.network(widget.url);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (
          ImageInfo info,
          bool _,
        ) {
          try {
            aspectRatio = info.image.width / info.image.height;
            setState(() {});
          } catch (e) {
            aspectRatio = null;
            setState(() {});
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (aspectRatio == null) {
      return loadingImage();
    } else {
      return loadedImageNetwork();
    }
  }

  Widget loadedImageNetwork() {
    return AspectRatio(
      aspectRatio: aspectRatio!,
      child: Hero(
        tag: widget.tagHero,
        child: Image.network(
          widget.url,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, exception, stackTrace) {
            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                AssetConstant.kDefaultImage,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget loadingImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: Hero(
        tag: widget.tagHero,
        child: SizedBox(
          width: double.infinity,
          child: Image.asset(
            AssetConstant.kDefaultImage,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
