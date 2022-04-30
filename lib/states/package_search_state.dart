


import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:pub_dev_crawler/model/package_model.dart';
import 'package:pub_dev_crawler/model/package_page.dart';
import 'package:pub_dev_crawler/parser/pub_parser.dart';
import 'package:pub_dev_crawler/services/remote/app_remote_service.dart';
import 'package:pub_dev_crawler/utils/constant.dart';

class StatePackageSearch extends ChangeNotifier {
  final Ref ref;
  var logger = Logger();

  List<PackageModel> _allPackages = [];
  List<PackageModel> _sortedPackages = [];
  int _totalPackages = 0;
  int _currPage = 1;
  int get currPage => _currPage;
  int _sig = DateTime.now().millisecondsSinceEpoch;
  bool _scaning = true;
  bool paused = false;
  var delay = const Duration(milliseconds: 1000);

  int totalLoading = 0;
  int loadingCount = 0;
  bool loadFailed = false;
  int lastLoadedCount = 0;

  String _packageType = "packages";
  String _keywords = "";
  PackageSort _serverSort = Constant.SORT_NEWEST_PACKAGE;

  StatePackageSearch(this.ref);

  PackageSort get serverSort => _serverSort;
  String get keyword => _keywords;
  int get totalPackages => _totalPackages;
  List<PackageModel> get allPackages => _allPackages;
  List<PackageModel> get sortedPackages => _sortedPackages;

  List<ClientSort> allClientSort = [ClientSort('Update date', 'updated'), ClientSort('Likes', 'likes'), ClientSort('Points', 'points'), ClientSort('Popularity', 'popularity'), ClientSort('Images', 'images'),];

  List<ClientSort> selectedClientSort = [];

  void setSortType(PackageSort sort){
    _serverSort = sort;
    submitSearch(_keywords);
  }


  set currPage(int value) {
    _currPage = value;
    notifyListeners();
  }

  loadPackagesFromDatabase() {
    final box = Hive.box('packages');
    final meta = Hive.box('meta');
    _currPage = meta.get('currPage', defaultValue: 1);
    _allPackages.clear();
    _sortedPackages.clear();
    final List<Map<String, dynamic>> map = box.values.map((e) {
      return Map<String, dynamic>.from(e);
    }).toList();
    for (var value in map) {
      _allPackages.add(PackageModel.fromJson(value));
    }
    runSort();
    // _allPackages;
  }

  void setClientSort(ClientSort sort){
    bool exists = selectedClientSort.any((element) => element.code == sort.code);
    if (exists) return;
    selectedClientSort.add(sort);
    runSort();
    notifyListeners();
  }

  void notifySort() {
    runSort();
    notifyListeners();
  }

  void clearClientSort(){
    selectedClientSort.clear();
    runSort();
    notifyListeners();
  }

  Future<void> submitSearch(String keyword,) async {
    _keywords = keyword;
    _scaning = true;
    _currPage = 1;
    paused = false;
    _totalPackages = 0;
    _allPackages = [];
    _sortedPackages = [];
    totalLoading = 0;
    loadingCount = 0;
    notifyListeners();
    await _runCrawlerLoop();
  }

  Future runSearch() async {
      _scaning = true;
      paused = false;
      _sortedPackages = [];
      totalLoading = 0;
      loadingCount = 0;
      notifyListeners();
      await _runCrawlerLoop();
  }

  Future<void> _runCrawlerLoop() async {
    _sig = DateTime.now().millisecondsSinceEpoch;
    int sig = _sig;
    final box = Hive.box('meta');
    await Future.doWhile(() async {
      try {
        if (paused) {
          await Future.delayed(const Duration(seconds: 1));
          return true;
        }
        if (sig != _sig) {
          return false;
        }
        logger.w("Get packages sig: $sig page: $_currPage, keyword: $_keywords sort: $_serverSort");
        String html = await Services.pubClient.getPackagesPage(
          type: _packageType, keywords: _keywords, sort: _serverSort.code, page: _currPage);
        await Future.delayed(delay);
        // handle result
        var page = PubParser().parseListPackage(html);
        if (sig != _sig) {
          return false;
        }
        await handlePagePackages(page);
        if (sig != _sig) {
          return false;
        }
        lastLoadedCount += page.packages.length;
        if (lastLoadedCount > 2000) {
          paused = true;
        }
        _currPage += 1;
        notifyListeners();
        // should keep going or not
        if (_scaning && sig == _sig && !paused) {
          return true;
        }
        box.put('currPage', currPage);
      } catch (e, st) {
        logger.e('${e.toString()}: $st');
        paused = true;
        notifyListeners();
      }
      if (paused) {
        await Future.delayed(const Duration(seconds: 1));
        return true;
      }
      return false;
    });
  }

  static final _provider = ChangeNotifierProvider<StatePackageSearch>((ref) => StatePackageSearch(ref));

  static StatePackageSearch read(WidgetRef ref) {
    return ref.read(_provider);
  }

  static StatePackageSearch watch(WidgetRef ref) {
    return ref.watch(_provider);
  }

  Future<void> handlePagePackages(PackagePage page) async {
    int sig = _sig;
    totalLoading = page.packages.length;
    loadingCount = 0;
    notifyListeners();
    getEachPackageDetail(page);
    if (sig != _sig) {
      return;
    }
    await addPackageToList(page);
    _totalPackages = page.total;
    runSort();
    notifyListeners();
  }

  Future addPackageToList(PackagePage page) async {
    final box = Hive.box('packages');
    await Future.forEach<PackageModel>(page.packages, (package) async {
      await box.put(package.name ?? '', package.toJson());
      _allPackages.removeWhere((element) => element.name == package.name);
      _allPackages.add(package);
    });
  }

  void runSort() {
    _sortedPackages = _allPackages.where(filterPackage).toList();
    if (selectedClientSort.isNotEmpty) {
      _sortedPackages.sort((o1,o2) {
        int ret = 0;
        for (var sort in selectedClientSort) {
          if (ret != 0) break;
          int _ret = 0;
          switch(sort.code) {
            case 'updated':
              _ret = (o1.lastUpdateTs ?? 0) - (o2.lastUpdateTs ?? 0);
              break;
            case 'likes':
              _ret = (o1.like ?? 0) - (o2.like ?? 0);
              break;
            case 'points':
              _ret = (o1.point ?? 0) - (o2.point ?? 0);
              break;
            case 'popularity':
              _ret = (o1.popularity ?? 0) - (o2.popularity ?? 0);
              break;
            case 'images':
              _ret = (o1.detail?.images?.length ?? 0) - (o2.detail?.images?.length ?? 0);
              break;
          }
          if (sort.isDesc) {
            _ret = -_ret;
          }
          if (ret == 0) {
            ret = _ret;
          }
        }
        return ret;
      });
    }
  }

  bool filterPackage(PackageModel package) {
    return true;
  }

  Future getEachPackageDetail(PackagePage page) async {
    final box = Hive.box('packages');
    int sig = _sig;
    var parser = PubParser();
    for (var package in page.packages) {
      if (!package.isCore) {
        var detail = await Services.pubClient.getPackagesDetail(package.name!);
        package.detail = parser.parsePackageDetail(detail);
        await box.put(package.name ?? '', package.toJson());
        await Future.delayed(const Duration(milliseconds: 1000));
      }
      if (sig != _sig) {
        return;
      }
      loadingCount++;
    }
    notifyListeners();
  }
}