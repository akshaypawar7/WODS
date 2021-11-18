import 'package:flutter/material.dart';
// common_widget
import 'package:wods/common_widgets/IntervalSelector.dart';
import 'package:wods/common_widgets/QuateListTile.dart';
// State
import 'package:provider/provider.dart';
import 'package:wods/state/DataHouse.dart';
// Charts
import 'package:syncfusion_flutter_charts/charts.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  String _selectedIndice = 'NIFTY 50';
  String _selectedInterval = '1D';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> _wlData = context.watch<DataHouse>().get_watchlist(listName: _selectedIndice, listType: 'Indices');
    final List<dynamic> _watchlist = _wlData['list'];

    if (_watchlist.first == false) return Center(child: CircularProgressIndicator());

    final List<dynamic> mostActive = _watchlist.sublist(0, 5);
    _watchlist.sort((a, b) => b[3].compareTo(a[3]));
    final List<dynamic> gainers = _watchlist.sublist(0, 5).where((i) => i[3] > 0).toList();
    final List<dynamic> losers = _watchlist.reversed.toList().sublist(0, 5).where((i) => i[3] < 0).toList();
    _watchlist.sort((a, b) => b[4].compareTo(a[4]));
    final List<dynamic> highDeliveryPercent = _watchlist.sublist(0, 5);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text(_selectedIndice),
        backgroundColor: Color.fromRGBO(240, 154, 105, 1),
        onPressed: () => _showIndices(context, context.read<DataHouse>().getIndicesList),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: IndicesDistibution(_watchlist.map((i) => i[3]).toList()),
          ),
          SliverAppBar(
            title: IntervalSelector(
              _selectedInterval,
              [
                '1D',
                '1W',
                '1M',
                '52W',
              ],
              (b) {
                if (b != _selectedInterval)
                  setState(() {
                    _selectedInterval = b;
                  });
              },
            ),
            elevation: 0,
            titleSpacing: 0,
            pinned: true,
          ),
          if (gainers.isEmpty) _TopStocksIsEmpty() else ..._buildTopStock('Top Gainers', gainers),
          if (losers.isEmpty) _TopStocksIsEmpty() else ..._buildTopStock('Top Losers', losers),
          ..._buildTopStock('Most Active', mostActive),
          ..._buildTopStock('High Delivery Percentage', highDeliveryPercent),
          SliverToBoxAdapter(child: SizedBox(height: 70)),
        ],
      ),
    );
  }

  Widget _TopStocksIsEmpty() {
    return SliverToBoxAdapter(
      child: Container(
        child: Text('No Symbols'),
        height: 200,
        alignment: Alignment.center,
      ),
    );
  }

  List<Widget> _buildTopStock(String name, List<dynamic> list) {
    return [
      SliverAppBar(primary: false, title: Text(name, style: TextStyle(color: Color.fromRGBO(240, 154, 105, 1)))),
      SliverList(
        delegate: SliverChildListDelegate(
          list.map((i) => QuateListTile(i)).toList(),
        ),
      ),
    ];
  }

  Future<void> _showIndices(BuildContext context, List<dynamic> indices) async {
    var r = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.75,
        expand: false,
        builder: (context, controller) => Column(
          children: [
            Container(
              child: Text(
                'Add Indices',
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
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final String i = indices[index];
                  return ListTile(
                    title: Text(i),
                    onTap: () => setState(() {
                      _selectedIndice = i;
                      Navigator.pop(context);
                    }),
                  );
                },
                controller: controller,
                itemCount: indices.length,
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) => Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onExtraMenuTap(int tabIndex) {}
}

class Cdata {
  const Cdata(this.x, this.y, this.color);
  final String x;
  final int y;
  final Color color;
}

class IndicesDistibution extends StatelessWidget {
  IndicesDistibution(this.chng);
  final List<dynamic> chng;

  List<Cdata> _addcData = [];
  List<int> _addCount = [];

  _setAddcData() {
    final List<String> addCat = [
      '>15%',
      '15%\n10%',
      '10%\n5%',
      '5%\n2%',
      '2%\n0%',
      '0%',
      '-0%\n-2%',
      '-2%\n-5%',
      '-5%\n-10%',
      '-10%\n-15%',
      '-15%>',
    ];
    List<int> add = List.generate(addCat.length, (i) => 0);

    _addCount = [
      0,
      0,
      0,
      chng.length,
    ];
    for (var i in chng) {
      if (i == 0) {
        _addCount[1] = _addCount[1] + 1;
        add[5] = add[5] + 1;
      } else if (i > 0) {
        _addCount[0] = _addCount[0] + 1;

        if (i <= 2 && i > 0) {
          add[4] = add[4] + 1;
        } else if (i <= 5 && i > 2) {
          add[3] = add[3] + 1;
        } else if (i <= 10 && i > 5) {
          add[2] = add[2] + 1;
        } else if (i <= 15 && i > 10) {
          add[1] = add[1] + 1;
        } else if (i > 15) {
          add[0] = add[0] + 1;
        }
      } else {
        _addCount[2] = _addCount[2] + 1;
        if (i < 0 && i >= -2) {
          add[6] = add[6] + 1;
        } else if (i < -2 && i >= -5) {
          add[7] = add[7] + 1;
        } else if (i < -5 && i >= -10) {
          add[8] = add[8] + 1;
        } else if (i < -10 && i >= -15) {
          add[9] = add[9] + 1;
        } else if (i < -15) {
          add[10] = add[10] + 1;
        }
      }
    }

    _addcData = [];
    for (int i = 0; i < add.length; i++) {
      _addcData.add(Cdata(
          addCat[i],
          add[i],
          i < 5
              ? Colors.green
              : i == 5
                  ? Colors.grey
                  : Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    _setAddcData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Text('   Advances & Declines Distribution',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Color.fromRGBO(240, 154, 105, 1),
            )),
        Text(
          '     Total: ${_addCount[3]}',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        SizedBox(
          height: 180,
          child: SfCartesianChart(
            series: <ChartSeries>[
              ColumnSeries<Cdata, String>(
                dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: _addcData,
                xValueMapper: (Cdata sales, _) => sales.x,
                yValueMapper: (Cdata sales, _) => sales.y,
                pointColorMapper: (Cdata sales, _) => sales.color,
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ],
            primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(fontSize: 7),
              majorGridLines: MajorGridLines(width: 0),
              majorTickLines: MajorTickLines(size: 0, width: 0),
              axisLine: AxisLine(width: 0),
            ),
            primaryYAxis: NumericAxis(
              isVisible: false,
            ),
            plotAreaBorderWidth: 0,
            margin: EdgeInsets.symmetric(horizontal: 14),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              0,
              1,
              2
            ]
                .map((i) => Flexible(
                      flex: _addCount[i],
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: i == 0
                              ? Colors.green
                              : i == 1
                                  ? Colors.grey
                                  : Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('   Advances: ${_addCount[0]}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(
              'Declines: ${_addCount[2]}   ',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
