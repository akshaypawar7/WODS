import 'package:flutter/material.dart';
// State
import 'package:provider/provider.dart';
import 'package:wods/state/DataHouse.dart';

class EditWatchlist extends StatefulWidget {
  final List<dynamic> consti;
  EditWatchlist(this.consti);
  @override
  _EditWatchlistState createState() => _EditWatchlistState();
}

class _EditWatchlistState extends State<EditWatchlist> {
  late List<dynamic> _consti;

  void initState() {
    super.initState();
    _consti = [
      ...widget.consti
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          AppBar(
            actions: <Widget>[
              TextButton(
                child: Text('SAVE'),
                onPressed: () {
                  Navigator.pop(context);
                  context.read<DataHouse>().wlConstiChange(_consti);
                },
              ),
            ],
            title: Text('Edit List'),
            centerTitle: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                final String sym = _consti[index];
                return ListTile(
                  title: Text(sym),
                  onTap: () => setState(() => _consti.remove(sym)),
                  trailing: Padding(
                    child: const Icon(Icons.remove_circle_outline_outlined, color: Colors.red),
                    padding: EdgeInsets.only(right: 15.0),
                  ),
                  subtitle: const Text('NSE'),
                );
              },
              itemCount: _consti.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
