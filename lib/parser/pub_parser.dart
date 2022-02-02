
import 'package:html/parser.dart';
import 'package:pub_dev_crawler/model/package_detail.dart';
import 'package:pub_dev_crawler/model/package_model.dart';
import 'package:html/dom.dart';
import 'package:pub_dev_crawler/model/package_page.dart';
import 'package:pub_dev_crawler/utils/date_utils.dart';
import 'package:pub_dev_crawler/utils/image_filter.dart';

class PubParser {

  PackageDetail parsePackageDetail(String html) {
    var detail = PackageDetail();
    Document parsed = parse(html);
    var detailContent = parsed.getElementsByClassName("detail-tabs-content");
    if (detailContent.length != 1) {
      throw Exception('Failed to parse detail');
    }
    var images = detailContent[0].getElementsByTagName("img");
    detail.images = [];
    for (var image in images) {
      var imageUrl = image.attributes["src"];
      var width = image.attributes["width"];
      var height = image.attributes["height"];
      if (imageUrl != null && !ImageFilter.shouldIgnoreImage(imageUrl)) {
        if (imageUrl.trim().contains(' ')) {
          imageUrl = Uri.decodeFull(imageUrl);
        }
        detail.images!.add(PackageImage(url: imageUrl, width: validSize(double.tryParse(width ?? '0')), height: validSize(double.tryParse(height ?? '0'))));
      }
    }
    return detail;
  }

  double? validSize(double? width) {
    if (width == null || width <= 0.0) return null;
    return width;
  }

  PackagePage parseListPackage(String html) {
    var page = PackagePage();
    List<PackageModel> _packages = page.packages;
    Document parsed = parse(html);
    var packages = parsed.getElementsByClassName("packages");
    if (packages.length != 1) {
      throw Exception('Failed to parse packages');
    }
    for (var package in packages[0].children) {
      var p = parsePackage(package);
      _packages.add(p);
    }
    var count = parsed.getElementsByClassName("listing-info-count")[0];
    var _count = count.getElementsByClassName("count")[0].text;
    page.total = int.parse(_count);
    return page;
  }

  PackageModel parsePackage(Element document) {
    PackageModel ret = PackageModel();
    var titles = document.getElementsByClassName("packages-title");
    if (titles.length != 1) {
      throw Exception("Cannot parse package title");
    }
    var title = titles[0];
    var packageName = title.children[0];
    String _packageName = packageName.attributes["href"]!;
    if (_packageName.startsWith('http')) {
      _packageName = packageName.text;
    } else {
      _packageName = _packageName.replaceAll("/packages/", "");
    }
    ret.name = _packageName;
    // scores
    bool isCore = false;

    var _packagesScores = document.getElementsByClassName("packages-scores");
    if (_packagesScores.length == 1) {
      var packagesScores = _packagesScores[0];
      var scoreLike = packagesScores.getElementsByClassName(
          "packages-score packages-score-like")[0];
      String like = scoreLike.getElementsByClassName(
          "packages-score-value-number")[0].text;
      ret.like = int.tryParse(like);
      var scorePoint = packagesScores.getElementsByClassName(
          "packages-score packages-score-health")[0];
      String point = scorePoint.getElementsByClassName(
          "packages-score-value-number")[0].text;
      ret.point = int.tryParse(point);
      var scorePopularity = packagesScores.getElementsByClassName(
          "packages-score packages-score-popularity")[0];
      String popularity = scorePopularity.getElementsByClassName(
          "packages-score-value-number")[0].text;
      ret.popularity = int.tryParse(popularity);
    } else {
      isCore = true;
    }
    // desc
    ret.desc = document.getElementsByClassName("packages-description")[0].text;
    // last update
    var _meta = document.getElementsByClassName("packages-metadata");
    if (_meta.length == 1) {
      var meta = _meta[0];
      var ago = meta.getElementsByClassName("-x-ago");
      if (ago.isNotEmpty) {
        String date = ago.last
            .attributes["title"]!;
        ret.lastUpdate = date;
        ret.lastUpdateTs = DateUtils.parseDate(date)?.millisecondsSinceEpoch;
      } else {
        isCore = true;
      }
      var version = '';
      var _version = meta.getElementsByTagName('a');
      if (_version.isNotEmpty) {
        version = _version.last.text;
      }
      ret.version = version;
    }
    ret.isCore = isCore;
    return ret;
  }
}