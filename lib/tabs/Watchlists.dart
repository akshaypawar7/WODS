import 'package:flutter/material.dart';
// State
import 'package:provider/provider.dart';
import 'package:wods/state/DataHouse.dart';
// common_widget
import 'package:wods/common_widgets/IntervalSelector.dart';
import 'package:wods/common_widgets/QuateListTile.dart';
// pages
import 'package:wods/pages/SearchSymbol.dart';
import 'package:wods/pages/EditWatchlist.dart';

class Watchlists extends StatelessWidget {
  final Widget? appBar;
  final String? listName;
  final String? listType;
  Watchlists({this.appBar, this.listName, this.listType});

  final ScrollController _listScrollController = ScrollController();
  late Map<String, dynamic> _wlData;
  // items gesture callback
  late GestureLongPressCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    _wlData = context.watch<DataHouse>().get_watchlist(listName: listName, listType: listType);
    final List<dynamic> _watchlist = _wlData['list'];
    if (_watchlist.isNotEmpty && _watchlist.first == false) return Center(child: CircularProgressIndicator());
    //edit list call
    onLongPress = _wlData['selListType'] == "My Watchlists"
        ? () => Navigator.pushNamed(
              context,
              '/EditWatchlist',
              arguments: _watchlist.map((i) => i.first).toList(),
            )
        : null;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          appBar ??
              AppBar(
                title: Text(_wlData['selList']),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.search_outlined),
                    onPressed: () => _onSearchButton(
                      context,
                      _wlData['selListType'] == "My Watchlists" ? _watchlist.map((i) => i.first).toList() : null,
                    ),
                  ),
                ],
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                titleSpacing: 0,
                centerTitle: true,
              ),
          if (_watchlist.isEmpty) ...[
            Expanded(
              child: Container(
                child: Text('Nothing in this Watchlist yet...',
                    style: TextStyle(
                      color: Color.fromRGBO(240, 154, 105, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    )),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 40),
              ),
            ),
            Container(
              child: ElevatedButton(
                child: const Text('Add Symbols'),
                onPressed: () => _onSearchButton(
                  context,
                  _wlData['selListType'] == "My Watchlists" ? _watchlist.map((i) => i.first).toList() : null,
                ),
              ),
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 40, right: 40, bottom: 100),
            ),
          ] else ...[
            Row(
              children: <Widget>[
                Expanded(
                  child: IntervalSelector(
                      '1D',
                      [
                        '1D',
                        '1W',
                        '1M',
                        '52W',
                      ],
                      () {}),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert_outlined),
                  onPressed: () => _onSortButton(context),
                )
              ],
            ),
            Divider(),
            Expanded(
              child: ListView.separated(
                controller: _listScrollController,
                itemCount: _watchlist.length,
                itemBuilder: (BuildContext context, int index) => QuateListTile(_watchlist[index], onTap: () => onTap(context, _watchlist[index].first), onLongPress: onLongPress),
                separatorBuilder: (BuildContext context, int index) => Divider(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  onTap(BuildContext context, String symbol) => Navigator.pushNamed(
        context,
        '/SymbolDetail',
        arguments: symbol,
      );

  _onSearchButton(BuildContext context, List<dynamic>? listConsti) => Navigator.pushNamed(
        context,
        '/SearchSymbol',
        arguments: listConsti,
      );

  void _onSortButton(BuildContext context) {
    final DataHouse dataHouse = context.read<DataHouse>();
    final int _sortState = _wlData['sortState'];
    final String _sortCat = _wlData['sortCat'];
    showModalBottomSheet<void>(
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            Container(
              child: Text(
                'Sort by...',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color.fromRGBO(240, 154, 105, 1),
                ),
              ),
              margin: EdgeInsets.only(
                top: 25,
                left: 14,
                bottom: 5,
              ),
            ),
            for (String i in [
              'Symbol',
              'Price',
              'Change %',
            ]) ...[
              ListTile(
                title: Text(i),
                trailing: SizedBox(
                  width: 120,
                  child: Row(
                    children: [
                      0,
                      1,
                    ]
                        .map((b) => Container(
                              child: IconButton(
                                icon: Icon(
                                  b == 0 ? Icons.expand_more_outlined : Icons.expand_less_outlined,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _listScrollController.jumpTo(0);
                                  dataHouse.putWlSortBy('${i}${b}');
                                },
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                border: i == _sortCat && b == _sortState ? Border.all(color: Colors.blue) : null,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 4),
                            ))
                        .toList(),
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ),
              ),
              Divider(),
            ],
            for (String i in [
              'Most Active',
              'Volume',
              'Delivery %',
              'None'
            ]) ...[
              Divider(),
              ListTile(
                onTap: () {
                  dataHouse.putWlSortBy(i == 'Most Active' || i == 'None' ? '${i}2' : '${i}0');
                  Navigator.of(context).pop();
                },
                title: Text(i),
                selected: _sortCat == i,
              ),
            ],
            SizedBox(
              height: 10,
              width: double.infinity,
            )
          ],
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
    );
  }
}
