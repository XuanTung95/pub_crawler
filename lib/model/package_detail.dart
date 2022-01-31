
class PackageDetail {
  List<PackageImage>? images; // <img alt="Barcode" src="https://raw.githubusercontent.com/DavBfr/dart_barcode/master/img/test.png">
}

class PackageImage {
  final String url;
  final double? width;
  final double? height;

  PackageImage({required this.url, required this.width, required this.height});
}