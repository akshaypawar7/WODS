import 'package:flutter/material.dart';
// Hive Local Database
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
// firebase
import 'package:firebase_database/firebase_database.dart';

class DataHouse with ChangeNotifier {
  final Box<dynamic> _appBox = Hive.box('app_state');
  Map<dynamic, dynamic> _bhavcopy = {};
  Map<dynamic, dynamic> _meta = {};

  void putWlSortBy(String sortBy) {
    _appBox.put('wlSortBy', sortBy);
    notifyListeners();
  }

  // Watchlists Menu section
  List<dynamic> get getIndicesList => [
        'All Equity',
        'F&O stock',
        ..._meta['broad_indices'],
        ..._meta['sect_indices'],
      ];

  void wlChange() => notifyListeners();

  void wlConstiChange(List<dynamic> consti) {
    Map<dynamic, dynamic> listMap = _appBox.get("My Watchlists");
    listMap[_appBox.get('selList')] = consti;
    _appBox.put("My Watchlists", listMap);
    notifyListeners();
  }

  List<dynamic> get allSymbol => _bhavcopy.keys.toList()..sort();

  Map<String, dynamic> get_watchlist({
    String? listName,
    String? listType,
  }) {
    if (_bhavcopy.isEmpty) {
      initData();
      return {
        'selList': '',
        'list': [
          false
        ],
      };
    }

    final String selList = listName ?? _appBox.get('selList');
    final String sortBy = listType == 'Indices' ? 'Most Active2' : _appBox.get('wlSortBy', defaultValue: 'none0');
    final int sortState = int.parse(sortBy.substring(sortBy.length - 1));
    final String sortCat = sortBy.substring(0, sortBy.length - 1);

    late final List<dynamic> consti;
    switch (listType ?? _appBox.get('selListType')) {
      case "My Watchlists":
        consti = _appBox.get("My Watchlists")[selList];
        break;
      case 'Indices':
        consti = selList == 'All Equity' ? _bhavcopy.keys.toList() : _meta['indices_consti'][selList];
        break;
      case 'Sectors':
        final int secIndex = _meta['sectors'].indexOf(selList);
        consti = _meta['sectors_consti'].entries.where((e) => e.value == secIndex).map((e) => e.key).toList();
        break;
      case 'Industries':
        final int secIndex = _meta['industries'].indexOf(selList);
        consti = _meta['industries_consti'].entries.where((e) => e.value == secIndex).map((e) => e.key).toList();
        break;
      default:
        consti = [];
        break;
    }
    List<dynamic> watchlist = consti
        .where((s) => _bhavcopy.containsKey(s))
        .map((s) => [
              s,
              ..._bhavcopy[s],
            ])
        .toList();

    late int sortIndex;

    switch (sortCat) {
      case 'Symbol':
        sortIndex = 0;
        break;
      case 'Price':
        sortIndex = 1;
        break;
      case 'Change %':
        sortIndex = 3;
        break;
      case 'Volume':
        sortIndex = 2;
        break;
      case 'Delivery %':
        sortIndex = 4;
        break;
      case 'Most Active':
        sortIndex = -1;
        watchlist = watchlist
            .map((i) => [
                  ...i,
                  i[1] * i[2]
                ])
            .toList();
        watchlist.sort((a, b) => b.last.compareTo(a.last));
        break;
      default:
        sortIndex = -1;
        break;
    }

    if (sortIndex > -1) {
      if (sortState == 0)
        watchlist.sort((a, b) => b[sortIndex].compareTo(a[sortIndex]));
      else
        watchlist.sort((a, b) => a[sortIndex].compareTo(b[sortIndex]));
    }
    final Map<String, dynamic> returnData = {
      'selList': selList,
      'selListType': _appBox.get('selListType'),
      'list': watchlist,
      'sortCat': sortCat,
      'sortState': sortState,
    };
    return returnData;
  }

  // Sectors Industries performance tab
  List<dynamic> sectorIndustries(String metaKey, int sortState) {
    List<dynamic> sector = _meta[metaKey];
    var secCount = List.generate(sector.length, (i) => []);
    _meta['${metaKey}_consti'].forEach((k, v) {
      try {
        secCount[v].add(_bhavcopy[k][2]);
      } catch (e) {
        //print(k);
      }
    });
    List<dynamic> result = [
      for (int i = 0; i < sector.length; i++)
        [
          sector[i],
          secCount[i].length,
          secCount[i].reduce((p, e) => p + e) / secCount[i].length
        ]
    ];
    if (sortState == 1)
      result.sort((a, b) => b.last.compareTo(a.last));
    else if (sortState == 2) result.sort((a, b) => a.last.compareTo(b.last));
    return result;
  }

  List<dynamic> getWlList(String listType) {
    return _appBox.get(listType);
  }

  void setWlList(String listType, List<dynamic> list) {
    _appBox.put(listType, list);
  }

  // Symbols Detail
  Map<dynamic, dynamic> quate(String symbol) {
    return {
      'q': _bhavcopy[symbol],
      'logo': _meta['logo_url'][symbol],
    };
  }

  initData() async {
    if (_appBox.get("selList") == null) {
      _appBox.putAll({
        "selView": 0,
        "selList": "NIFTY 50",
        "selListType": "Indices",
        "My Watchlists": {
          "Watchlist": [],
        },
        "Indices": [
          "NIFTY 50"
        ],
        "Sectors": [],
        "Industries": [],
      });
    }

    final FirebaseDatabase database = FirebaseDatabase.instance;
    Box<dynamic> _dataBox = await Hive.openBox('dataHouse');
    _bhavcopy = _dataBox.get('bhavcopy', defaultValue: {});
    if (_bhavcopy.isEmpty) {
      final DataSnapshot? snapshot = await database.reference().child('bhavcopy').get();
      _bhavcopy = snapshot!.value;
      print(_bhavcopy['ACC']);
      _dataBox.put('bhavcopy', _bhavcopy);
    }
    _meta = _dataBox.get('meta', defaultValue: {});
    if (_meta.isEmpty) {
      final DataSnapshot? snapshot = await database.reference().child('meta').get();
      _meta = snapshot!.value;
      _dataBox.put('meta', _meta);
    }
    print('initData...');
    if (_meta.isNotEmpty && _bhavcopy.isNotEmpty) {
      notifyListeners();
    }
  }
}
