import 'package:flutter/material.dart';
// State
import 'package:provider/provider.dart';
import 'package:wods/state/DataHouse.dart';

class SearchSymbol extends StatefulWidget {
  final List<dynamic>? selListConsti;
  const SearchSymbol({this.selListConsti});
  @override
  _SearchSymbolState createState() => _SearchSymbolState();
}

class _SearchSymbolState extends State<SearchSymbol> {
  late final DataHouse _dataHouse;
  late final List<dynamic> _sym;
  late List<dynamic> _selListConsti;
  bool _isWlChange = false;

  final TextEditingController _controller = TextEditingController();
  String _query = '';
  late List<dynamic> results;

  @override
  void initState() {
    super.initState();
    _dataHouse = context.read<DataHouse>();
    _sym = _dataHouse.allSymbol;
    _selListConsti = widget.selListConsti ?? [];

    _controller.addListener(
      () => setState(() {
        _query = _controller.text.toUpperCase();
        results = _sym.where((e) => e.startsWith(_query)).toList();
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (_isWlChange) _dataHouse.wlConstiChange(_selListConsti);
          return true;
        },
        child: Column(
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.arrow_back_outlined, color: Colors.grey),
                      onPressed: () {
                        if (_isWlChange) _dataHouse.wlConstiChange(_selListConsti);
                        Navigator.pop(context);
                      },
                    ),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () => _controller.clear(),
                          ),
                  ),
                  autofocus: true,
                  controller: _controller,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            if (_query.isEmpty)
              Center(child: Text('Search Symbol'))
            else if (results.isEmpty)
              Center(child: Text('No symbols match your criteria'))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: results.length,
                  itemBuilder: (BuildContext context, i) {
                    String result = results[i];
                    return ListTile(
                      subtitle: const Text('NSE'),
                      title: Text(result),
                      onTap: () => onTap(result),
                      trailing: widget.selListConsti != null
                          ? Checkbox(
                              checkColor: Theme.of(context).primaryColor,
                              activeColor: Color.fromRGBO(240, 154, 105, 1),
                              value: _selListConsti.contains(result),
                              onChanged: (bool? v) => setState(() {
                                _isWlChange = true;
                                if (v ?? false) {
                                  _selListConsti.add(result);
                                } else {
                                  _selListConsti.remove(result);
                                }
                              }),
                            )
                          : null,
                    );
                  },
                  physics: BouncingScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  separatorBuilder: (BuildContext context, s) => Divider(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  onTap(String symbol) => Navigator.pushNamed(
        context,
        '/SymbolDetail',
        arguments: symbol,
      );
}
