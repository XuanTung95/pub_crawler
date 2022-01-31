import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pub_dev_crawler/model/package_detail.dart';
import 'package:pub_dev_crawler/model/package_model.dart';
import 'package:pub_dev_crawler/theme/app_text_style.dart';
import 'package:url_launcher/url_launcher.dart';
import '../score_widget.dart';

class PackageListItem extends StatelessWidget {
  final PackageModel package;

  const PackageListItem({Key? key, required this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = AppTextStyle(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () async {
                final url = "https://pub.dev/packages/${package.name}";
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              child: Text(
                package.name ?? '',
                style: style.packTitle,
              ),
            ),
            const Spacer(),
            ScoreWidget(top: '${package.like ?? 0}', bot: 'LIKES',),
            const ScoreDivider(),
            ScoreWidget(top: '${package.point ?? 0}', bot: 'PUB POINTS',),
            const ScoreDivider(),
            ScoreWidget(top: '${package.popularity ?? 0}', bot: 'POPULARITY', percent: true,),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          package.desc ?? '',
          style: style.packageNormalText,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(package.lastUpdate ?? ''),
        PackageImageView(images: package.detail?.images ?? [],),
      ],
    );
  }
}

class PackageImageView extends StatelessWidget {
  final List<PackageImage> images;

  const PackageImageView({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          children: [
            const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
            const Text('No Images', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),),
          ],
        ),
      );
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
        var image = images[index];
        if (image.url.contains(".svg")) {
          return SvgPicture.network(image.url, width: image.width, height: image.height,
          placeholderBuilder: (context) {
            return const Center(child: CircularProgressIndicator(color: Colors.red,));
          },);
        } else {
          return ImageWidget(image: image,);
        }
      }, itemCount: images.length,),
    );

  }
}

class ImageWidget extends StatelessWidget {
  final PackageImage image;

  const ImageWidget({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await launch(Uri.encodeFull(image.url));
      },
      child: ExtendedImage.network(
        image.url,
        width: image.width,
        height: image.height,
        cache: true,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return const Center(child: CircularProgressIndicator());
              break;
            case LoadState.completed:
              return null;
            case LoadState.failed:
              return Text(
                "load image failed: \n${image.url}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              );
          }
        },
        //cancelToken: cancellationToken,
      ),
    );
  }

}

class ScoreDivider extends StatelessWidget {
  const ScoreDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ColoredBox(color: Color(0x9FBDBDBD), child: SizedBox(height: 50, width: 1,),),
    );
  }
}