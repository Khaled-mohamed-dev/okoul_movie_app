import 'package:flutter/material.dart';
import 'package:okuol_movie_app/core/constants/colors.dart';
import 'package:okuol_movie_app/core/constants/endpoints.dart';
import 'package:shimmer/shimmer.dart';

class ImageCard extends StatefulWidget {
  const ImageCard({
    super.key,
    required this.imageUrl,
    this.gender,
    this.height,
  });
  final double? height;
  final String? imageUrl;
  final int? gender;
  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: widget.imageUrl != null
          ? Image.network(
              "$imageBaseUrl${widget.imageUrl}",
              errorBuilder: (context, exception, stackTrace) {
                return Image.asset(
                  "assets/no-image.jpg",
                  fit: BoxFit.cover,
                  height: widget.height,
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Shimmer.fromColors(
                    baseColor: kcPrimaryColor,
                    highlightColor: kcAccentColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        "assets/no-image.jpg",
                        height: widget.height,
                      ),
                    ),
                  );
                }
              },
              height: widget.height,
              fit: BoxFit.cover,
            )
          : widget.gender == null
              ? Image.asset(
                  "assets/no-image.jpg",
                  fit: BoxFit.cover,
                  height: widget.height,
                )
              : widget.gender == 1
                  ? Image.asset(
                      "assets/woman.jpg",
                      fit: BoxFit.cover,
                      height: widget.height,
                    )
                  : Image.asset(
                      "assets/man.jpg",
                      fit: BoxFit.cover,
                      height: widget.height,
                    ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
