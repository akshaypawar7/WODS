import 'package:flutter/material.dart';
// Hive Local Database
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
// State
import 'package:provider/provider.dart';
import 'package:wods/state/PostState.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Box<dynamic> _box = Hive.box('app_state');

  @override
  Widget build(BuildContext context) {
    final List<String> _tabs = <String>[
      'Posts',
      'Replay',
      'Likes',
    ];
    return DefaultTabController(
      length: _tabs.length,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: Text(_box.get('userId', defaultValue: '')),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(bottom: 60),
                  centerTitle: true,
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      context.read<PostState>().getAvatar(_box.get('userId', defaultValue: ''), 35),
                      SizedBox(height: 15),
                      Text('Akshay Pawar Patil', style: Theme.of(context).textTheme.headline6),
                      SizedBox(height: 15),
                      Row(
                        children: <Widget>[
                          for (String i in [
                            '42',
                            '172M',
                            '100K'
                          ])
                            Text(i, style: Theme.of(context).textTheme.button),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                      Row(
                        children: <Widget>[
                          for (String i in [
                            'Post',
                            'Followers',
                            'Following',
                          ])
                            Text(i, style: TextStyle(color: Colors.grey)),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                      SizedBox(height: 15),
                      Text('Price Action Trader | Position Trader | Coder'),
                      ElevatedButton(
                        child: Text('Edit Profile'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/UserId',
                    ),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(56),
                  child: Container(
                    child: TabBar(
                      tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                pinned: true,
                expandedHeight: 350.0,
              ),
            ),
          ];
        },
        body: TabBarView(
          children: _tabs.map((String name) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>(name),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return _post();
                          },
                          childCount: 30,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  _post() {
    return Padding(
      child: Row(
        children: <Widget>[
          Padding(
            child: CircleAvatar(radius: 25, child: FlutterLogo()),
            padding: EdgeInsets.only(top: 14, right: 10),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Flutter', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Text('@flutterDev .7 min', style: TextStyle(color: Colors.grey)),
                    Spacer(),
                    IconButton(
                      icon: const Icon(Icons.expand_more_outlined),
                      onPressed: () {},
                    )
                  ],
                ),
                const Text('Nse looks like,\nhaving a biggeat rally forword and be\nall year nifty is high loke rocket always bullish\nready to get your reward....'),
                Row(
                  children: <Widget>[
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        primary: Colors.grey,
                      ),
                      icon: Icon(Icons.thumb_up_outlined),
                      label: Text('7842'),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        primary: Colors.grey,
                      ),
                      icon: Icon(Icons.loop_outlined),
                      label: Text('478'),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        primary: Colors.grey,
                      ),
                      icon: Icon(Icons.chat_bubble_outline_outlined),
                      label: Text('742'),
                      onPressed: () {},
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
