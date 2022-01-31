class Constant {
  static PackageSort SORT_LISTING_RELEVANCE = PackageSort('SEARCH RELEVANCE', '');
  static PackageSort SORT_OVERALL_SCORE = PackageSort('OVERALL SCORE', 'top');
  static PackageSort SORT_RECENTLY_UPDATED = PackageSort(
      'RECENTLY UPDATED', 'updated');
  static PackageSort SORT_NEWEST_PACKAGE = PackageSort(
      'NEWEST PACKAGE', 'created');
  static PackageSort SORT_MOST_LIKES = PackageSort('MOST LIKES', 'like');
  static PackageSort SORT_MOST_PUB_POINTS = PackageSort(
      'MOST PUB POINTS', 'points');
  static PackageSort SORT_POPULARITY = PackageSort('POPULARITY', 'popularity');

  static List<PackageSort> allSorts = [ SORT_LISTING_RELEVANCE,
    SORT_OVERALL_SCORE,
    SORT_RECENTLY_UPDATED,
    SORT_NEWEST_PACKAGE,
    SORT_MOST_LIKES,
    SORT_MOST_PUB_POINTS,
    SORT_POPULARITY];
}

class PackageSort {
  final String name;
  final String code;

  PackageSort(this.name, this.code);
}

class ClientSort {
  final String name;
  final String code;
  bool isDesc = true;

  ClientSort(this.name, this.code);
}