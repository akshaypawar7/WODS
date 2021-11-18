import 'package:flutter/material.dart';
import 'dart:convert' as convert;
// http
import 'package:http/http.dart' as http;
// common_widget
import 'package:wods/common_widgets/IntervalSelector.dart';
// State
import 'package:provider/provider.dart';
import 'package:wods/state/DataHouse.dart';
// Post
import 'package:wods/post/FeedList.dart';

class SymbolDetail extends StatefulWidget {
  final String symbol;
  const SymbolDetail(this.symbol);
  @override
  _SymbolDetailState createState() => _SymbolDetailState();
}

class _SymbolDetailState extends State<SymbolDetail> {
  late final DataHouse _dataHouse;
  late Map<dynamic, dynamic> _quate;
  @override
  void initState() {
    super.initState();
    _dataHouse = context.read<DataHouse>();
    _quate = _dataHouse.quate(widget.symbol);
    print(_quate);
    var url = "https://query1.finance.yahoo.com/v8/finance/chart/ACC.NS?region=IN&lang=en-IN&includePrePost=false&interval=1d&range=1mo&corsDomain=in.finance.yahoo.com&.tsrc=finance"; //').json()['chart']['result'][0]['indicators']['quote'][0]";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.symbol),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.star_border_outlined),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Text('Telecom'),
                SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    Text(_quate['q'][0].toString(),
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('   ${_quate['q'][2]} %',
                        style: TextStyle(
                          color: _quate['q'][2] > 0 ? Colors.green : Colors.red,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('1D'),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
                IntervalSelector(
                    '1D',
                    [
                      '1D',
                      '1W',
                      '1M',
                      '1Y',
                      'Max',
                    ],
                    () {}),
                Container(
                  height: 300,
                  child: Text('Chart', style: Theme.of(context).textTheme.headline3),
                  alignment: Alignment.center,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          SliverAppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IntervalSelector(
                    'All Post',
                    [
                      'All Post',
                      'Following Post'
                    ],
                    () {}),
                IconButton(
                  icon: const Icon(Icons.post_add_outlined),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/CreatePost',
                    arguments: widget.symbol,
                  ),
                ),
              ],
            ),
            pinned: true,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
          ),
          FeedList(symbol: widget.symbol),
        ],
      ),
    );
  }
}
