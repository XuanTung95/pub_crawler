


import 'package:pub_dev_crawler/model/package_detail.dart';

class PackageModel {
  bool isCore = false;
  String? name; // <a href="/packages/flutter_native_player">flutter_native_player</a>
  String? desc; // <p class="packages-description">A Flutter plugin for Android, iOS for playing back video on a Widget surface.</p>
  /*
  <a class="packages-scores" href="/packages/flutter_native_player/score"><div class="packages-score packages-score-like"><div class="packages-score-value -has-value"><span class="packages-score-value-number">1</span><span class="packages-score-value-sign"></span></div><div class="packages-score-label">likes</div></div><div class="packages-score packages-score-health"><div class="packages-score-value -has-value"><span class="packages-score-value-number">120</span><span class="packages-score-value-sign"></span></div><div class="packages-score-label">pub points</div></div><div class="packages-score packages-score-popularity"><div class="packages-score-value -has-value"><span class="packages-score-value-number">22</span><span class="packages-score-value-sign">%</span></div><div class="packages-score-label">popularity</div></div></a>
  */
  int? like;
  int? point;
  int? popularity;
  String? lastUpdate; // <span class="-x-ago" title="Jun 24, 2021">7 months ago</span>
  int? lastUpdateTs;
  PackageDetail? detail;
  String? version;


  PackageModel({this.isCore = false, this.name, this.desc, this.like, this.point, this.popularity, this.lastUpdate, this.lastUpdateTs, this.detail, this.version});

  PackageModel.fromJson(Map<String, dynamic> json) {
    isCore = json['isCore'];
    name = json['name'];
    desc = json['desc'];
    like = json['like'];
    point = json['point'];
    popularity = json['popularity'];
    lastUpdate = json['lastUpdate'];
    lastUpdateTs = json['lastUpdateTs'];
    detail = json['detail'] != null ? PackageDetail.fromJson(Map<String, dynamic>.from(json['detail'])) : null;
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isCore'] = this.isCore;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['like'] = this.like;
    data['point'] = this.point;
    data['popularity'] = this.popularity;
    data['lastUpdate'] = this.lastUpdate;
    data['lastUpdateTs'] = this.lastUpdateTs;
    if (this.detail != null) {
      data['detail'] = this.detail!.toJson();
    }
    data['version'] = this.version;
    return data;
  }

}