import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pub_dev_crawler/model/package_detail.dart';
import 'package:pub_dev_crawler/model/package_model.dart';
import 'package:pub_dev_crawler/theme/app_text_style.dart';
import 'package:pub_dev_crawler/utils/date_utils.dart' as d;
import 'package:url_launcher/url_launcher.dart';
import '../score_widget.dart';

class PackageListItem extends StatelessWidget {
  final PackageModel package;

  const PackageListItem({Key? key, required this.package,}) : super(key: key);

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
        Row(
          children: [
            Text('v', style: style.updateDate,),
            Text(' ${package.version ?? ''} ', style: style.version,),
            buildUpdateDate(context, style),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: PackageImageView(images: package.detail?.images ?? [],),
        ),
      ],
    );
  }

  Widget buildUpdateDate(BuildContext context, AppTextStyle style) {
    DateTime? date = d.DateUtils.parseDate(package.lastUpdate ?? '');
    if (date == null) return SizedBox();
    Duration xAgo = DateTime.now().difference(date);
    String text = '(${package.lastUpdate ?? ''})';
    if (xAgo.inDays < 30) {
      if (xAgo.inDays > 0) {
        text = '(${xAgo.inDays} days ago)';
      } else {
        text = '(${xAgo.inHours} hours ago)';
      }
    }
    return Text(text, style: style.updateDate,);
  }
}

class PackageImageView extends StatelessWidget {
  final List<PackageImage> images;

  const PackageImageView({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxHeight = 200;
    if (images.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          children: const [
            Icon(Icons.image_not_supported_outlined, color: Colors.grey),
            Text('No Images', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),),
          ],
        ),
      );
    }
    return SizedBox(
      height: maxHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
        var image = images[index];
        double height = maxHeight;
        double? width;
        if (image.width != null && image.height != null) {
          height = min(height, image.height!);
          width = height * image.width! / image.height!;
          print('wh: ${width} ${height}');
        }
        if (image.url.contains(".svg")) {
          return SvgPicture.network(image.url, width: width, height: height,
            placeholderBuilder: (context) {
              return const Center(child: CircularProgressIndicator(color: Colors.red,));
            },
          );
        } else {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ImageWidget(image: image, width: width, height: height,));
        }
      }, itemCount: images.length,),
    );

  }
}

class ImageWidget extends StatelessWidget {
  final PackageImage image;
  final double? width;
  final double? height;


  const ImageWidget({Key? key, required this.image, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await launch(Uri.encodeFull(image.url));
      },
      child: ExtendedImage.network(
        image.url,
        width: width,
        height: height,
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