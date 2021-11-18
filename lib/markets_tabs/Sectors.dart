import 'package:flutter/material.dart';
// State
import 'package:provider/provider.dart';
import 'package:wods/state/DataHouse.dart';
// common_widget
import 'package:wods/common_widgets/IntervalSelector.dart';
// routes
import 'package:wods/tabs/Watchlists.dart';

class Sectors extends StatefulWidget {
  Sectors(this.secOrInd);
  final String secOrInd;
  @override
  _SectorsState createState() => _SectorsState();
}

class _SectorsState extends State<Sectors> {
  int _sortState = 0;
  late DataHouse _dataHouse;
  @override
  Widget build(BuildContext context) {
    _dataHouse = context.read<DataHouse>();
    final List<dynamic> secInd = _dataHouse.sectorIndustries(widget.secOrInd.toLowerCase(), _sortState);
    return Column(
      children: <Widget>[
        SizedBox(height: 7),
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
            Container(
              child: IconButton(
                icon: Icon(_sortState == 0
                    ? Icons.unfold_more_outlined
                    : _sortState == 1
                        ? Icons.expand_more_outlined
                        : Icons.expand_less_outlined),
                onPressed: () => setState(() {
                  _sortState = _sortState == 0
                      ? 1
                      : _sortState == 1
                          ? 2
                          : 0;
                }),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey.withOpacity(0.25),
              ),
              height: 40,
              margin: EdgeInsets.only(right: 7),
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            itemCount: secInd.length,
            itemBuilder: (BuildContext context, int index) {
              final List<dynamic> item = secInd[index];
              return ListTile(
                trailing: Text(
                  '${item.last.toStringAsFixed(2)} %',
                  style: TextStyle(
                    fontSize: 20,
                    color: item.last > 0 ? Colors.green : Colors.red,
                  ),
                ),
                onTap: () => _onTap(context, item.first),
                title: Text(secInd[index].first),
                subtitle: Text('Total ${item[1]}'),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
            physics: BouncingScrollPhysics(),
          ),
        ),
      ],
    );
  }

  void _onTap(BuildContext context, String selIndName) {
    List<dynamic> wlList = _dataHouse.getWlList(widget.secOrInd);
    bool isListBookmark = wlList.contains(selIndName);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Watchlists(
            listName: selIndName,
            listType: widget.secOrInd,
            appBar: AppBar(
              actions: <Widget>[
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return IconButton(
                      color: isListBookmark ? Color.fromRGBO(240, 154, 105, 1) : null,
                      icon: Icon(isListBookmark ? Icons.star : Icons.star_border),
                      onPressed: () {
                        if (isListBookmark)
                          wlList.remove(selIndName);
                        else
                          wlList.add(selIndName);
                        setState(() {
                          isListBookmark = !isListBookmark;
                        });
                        _dataHouse.setWlList(widget.secOrInd, wlList);
                      },
                    );
                  },
                ),
              ],
              title: Text(selIndName),
              centerTitle: true,
              titleSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}
