import 'package:flutter/material.dart';
// hive
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// State
import 'package:provider/provider.dart';
import 'package:wods/state/DataHouse.dart';

class Watchlists_Menu extends StatefulWidget {
  @override
  _Watchlists_MenuState createState() => _Watchlists_MenuState();
}

class _Watchlists_MenuState extends State<Watchlists_Menu> {
  final Box<dynamic> _box = Hive.box('app_state');

  late Map<String, List> _lists;

  late final String _selList;

  bool _edit = false;
  bool _showSaveButtom = false;

  Map<String, List> _getOrgnlLists() {
    return {
      for (String name in [
        "My Watchlists",
        "Indices",
        "Sectors",
        "Industries",
      ])
        if (name == "My Watchlists") name: _box.get(name).keys.toList() else name: List<String>.from(_box.get(name))
    };
  }

  @override
  void initState() {
    super.initState();
    _selList = _box.get('selList');
    _lists = _getOrgnlLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: _edit
                ? TextButton(
                    child: Text('CANCEL'),
                    onPressed: () => setState(() {
                      _lists = _getOrgnlLists();
                      _edit = false;
                      _showSaveButtom = false;
                    }),
                  )
                : null,
            actions: [
              if (_edit)
                TextButton(
                  child: Text('SAVE'),
                  onPressed: _showSaveButtom
                      ? () {
                          for (String listName in _lists.keys) {
                            var origMap = _box.get(listName);
                            if (listName != "My Watchlists" && origMap.map((i) => _lists[listName]!.contains(i)).contains(false)) {
                              _box.put(listName, origMap..removeWhere((key) => !_lists[listName]!.contains(key)));
                            } else if (listName == "My Watchlists" && origMap.keys.map((i) => _lists[listName]!.contains(i)).contains(false)) {
                              _box.put(listName, origMap..removeWhere((key, value) => !_lists[listName]!.contains(key)));
                            }
                          }

                          if (![
                            ..._lists["My Watchlists"]!,
                            ..._lists["Indices"]!,
                            ..._lists["Sectors"]!,
                            ..._lists["Industries"]!,
                          ].contains(_selList)) {
                            _box..put('selList', _lists["My Watchlists"]![0])..put('selListType', "My Watchlists");
                            context.read<DataHouse>().wlChange();
                          }

                          setState(() {
                            _showSaveButtom = false;
                            _edit = false;
                          });
                        }
                      : null,
                )
              else
                TextButton(
                  child: Text('Edit'),
                  onPressed: () => setState(() {
                    _edit = true;
                  }),
                )
            ],
            pinned: true,
            leadingWidth: 70,
            automaticallyImplyLeading: false,
          ),
          for (String catName in [
            "My Watchlists",
            "Indices",
            if (_lists["Sectors"]!.length > 0) "Sectors",
            if (_lists["Industries"]!.length > 0) "Industries",
          ]) ...[
            SliverAppBar(
              title: Text(catName, style: const TextStyle(color: Color.fromRGBO(240, 154, 105, 1))),
              actions: <Widget>[
                if (!_edit && catName == "My Watchlists")
                  AddDialog(
                    _lists[catName]!,
                    catName.split(' ').last,
                    (addListName) {
                      Map<dynamic, dynamic> list = _box.get(catName);
                      _box
                        ..put(
                          catName,
                          list..[addListName] = [],
                        )
                        ..put(
                          'selList',
                          addListName,
                        );
                      if (_box.get('selListType') != catName) {
                        _box.put('selListType', catName);
                      }
                      Navigator.pop(context);
                      context.read<DataHouse>().wlChange();
                    },
                  ),
                if (!_edit && catName == "Indices")
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _addIndices(context, context.read<DataHouse>().getIndicesList),
                  )
              ],
              primary: false,
              automaticallyImplyLeading: false,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  for (String name in _lists[catName]!)
                    ListTile(
                      title: Text(name),
                      onTap: _edit
                          ? null
                          : () {
                              _box..put('selList', name)..put('selListType', catName);
                              context.read<DataHouse>().wlChange();
                              Navigator.pop(context);
                            },
                      trailing: _edit
                          ? catName == "My Watchlists" && _lists[catName]!.length == 1
                              ? null
                              : IconButton(
                                  icon: Icon(Icons.delete_outlined, color: Colors.red),
                                  onPressed: () => setState(() {
                                    _showSaveButtom = true;
                                    _lists[catName]!.remove(name);
                                  }),
                                )
                          : null,
                    )
                ],
              ),
            ),
          ],
        ],
        physics: BouncingScrollPhysics(),
      ),
    );
  }

  Future<void> _addIndices(BuildContext context, List<dynamic> indices) async {
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
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return CheckboxListTile(
                        checkColor: Theme.of(context).primaryColor,
                        title: Text(i),
                        activeColor: Color.fromRGBO(240, 154, 105, 1),
                        value: _lists["Indices"]!.contains(i),
                        onChanged: (v) => setState(() {
                          if (v ?? false) {
                            _lists["Indices"]!.add(i);
                          } else {
                            _lists["Indices"]!.remove(i);
                          }
                        }),
                      );
                    },
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

    if (r ?? true)
      setState(() {
        _lists["Indices"] = indices.where((i) => _lists["Indices"]!.contains(i)).toList();
        _box.put('Indices', _lists["Indices"]);
      });
  }
}

class AddDialog extends StatefulWidget {
  final List<dynamic> list;
  final String listType;
  Function onSubmitted;
  AddDialog(
    this.list,
    this.listType,
    this.onSubmitted,
  );
  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        final TextEditingController _controller = TextEditingController();
        _controller.addListener(() => setState(() {
              _text = _controller.text;
            }));
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
            title: Text("Create ${widget.listType.substring(0, widget.listType.length - 1)}"),
            content: TextFormField(
              autofocus: true,
              controller: _controller,
              maxLength: 24,
              autovalidate: true,
              validator: (String? value) {
                return (value != null && widget.list.contains(value)) ? 'This name is used by an existing list' : null;
              },
              onFieldSubmitted: (String? value) {
                if (_text.isNotEmpty && !widget.list.contains(_text)) {
                  widget.onSubmitted(_text);
                  _controller.dispose();
                  Navigator.of(context).pop();
                }
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                style: TextButton.styleFrom(primary: Color.fromRGBO(240, 154, 105, 1)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('SAVE'),
                style: TextButton.styleFrom(primary: Color.fromRGBO(240, 154, 105, 1)),
                onPressed: () {
                  if (_text.isNotEmpty && !widget.list.contains(_text)) {
                    widget.onSubmitted(_text);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
