
class PackageDetail {
  List<PackageImage>? images; // <img alt="Barcode" src="https://raw.githubusercontent.com/DavBfr/dart_barcode/master/img/test.png">

  PackageDetail();

  PackageDetail.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = <PackageImage>[];
      json['images'].forEach((v) { images!.add(PackageImage.fromJson(Map<String, dynamic>.from(v))); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PackageImage {
  String url = '';
  double? width;
  double? height;

  PackageImage({required this.url, required this.width, required this.height});

  PackageImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}