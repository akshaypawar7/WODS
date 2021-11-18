import 'package:flutter/material.dart';
// markets tabs
import 'package:wods/markets_tabs/Overview.dart';
import 'package:wods/markets_tabs/Sectors.dart';
import 'package:wods/markets_tabs/Deals.dart';

class Markets extends StatefulWidget {
  @override
  _MarketsState createState() => _MarketsState();
}

class _MarketsState extends State<Markets> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, vsync: this, length: 6);
    _tabController.addListener(() {
      print(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () => Navigator.pushNamed(
              context,
              '/SearchSymbol',
            ),
          ),
        ],
        bottom: TabBar(
          tabs: <Tab>[
            const Tab(text: 'Overview'),
            const Tab(text: 'Industries'),
            const Tab(text: 'Sectors'),
            const Tab(text: 'Deals'),
            const Tab(text: 'IPO Center'),
            const Tab(text: 'Earnings'),
          ],
          isScrollable: true,
          controller: _tabController,
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          indicatorPadding: EdgeInsets.symmetric(horizontal: 30),
        ),
        title: const Text('Markets'),
        shape: Border(bottom: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.5))),
      ),
      body: TabBarView(
        children: <Widget>[
          Overview(),
          Sectors('Industries'),
          Sectors('Sectors'),
          Deals(),
          Text('ak'),
          Text('ak'),
        ],
        controller: _tabController,
      ),
    );
  }
}
