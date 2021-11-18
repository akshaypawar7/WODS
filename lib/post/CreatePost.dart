import 'package:flutter/material.dart';
// State
import 'package:provider/provider.dart';
import 'package:wods/state/DataHouse.dart';
import 'package:wods/state/PostState.dart';

class CreatePost extends StatefulWidget {
  final String? symbol;
  CreatePost({this.symbol});
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late final List<dynamic> _allSymbols;
  late final TextEditingController _textController;
  String? _hashTicker;
  List<dynamic> _hashTickers = [];

  List<dynamic> _mentions = [];
  Map<String, dynamic> _postMap = {};
  @override
  void initState() {
    super.initState();
    _allSymbols = context.read<DataHouse>().allSymbol;
    _textController = HighlightTextEditingController((String text, TextStyle style) {
      List<InlineSpan> children = [];
      text.splitMapJoin(
        RegExp(_mentions.map((e) => e).join('|')),
        onMatch: (Match match) {
          children.add(TextSpan(
            text: match[0],
            style: const TextStyle(
              color: Colors.blue,
              height: 1.5,
              letterSpacing: 1.0,
            ),
          ));
          return '';
        },
        onNonMatch: (String text) {
          children.add(TextSpan(
            text: text,
            style: style,
          ));
          return '';
        },
      );
      return TextSpan(children: children);
    });
    if (widget.symbol != null) {
      _mentions.add('#${widget.symbol}');
      _textController.text = '#${widget.symbol} ';
    }
    _textController.addListener(() {
      final String tickerString = _textController.text.split("\n").last.split(' ').last;
      if (tickerString.startsWith('#')) {
        setState(() {
          _hashTicker = tickerString.substring(1).toUpperCase();
          _hashTickers = _allSymbols.where((i) => i.startsWith(_hashTicker)).toList();
        });
      } else if (_hashTicker != null) {
        setState(() {
          _hashTicker = null;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            child: ElevatedButton(
              child: const Text('Post'),
              onPressed: () {
                context.read<PostState>().addPost(_postMap
                  ..addAll({
                    'mentions': _mentions,
                    'text': _textController.text
                  }));
                Navigator.pop(context);
              },
            ),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 12),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (_postMap['trend'] != null)
            Container(
              margin: EdgeInsets.only(left: 60),
              child: _postMap['trend'] ? Text('Bullish', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)) : Text('Bearish', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
              alignment: Alignment.bottomLeft,
            ),
          Expanded(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12, top: 4),
                  child: const CircleAvatar(radius: 20, child: Icon(Icons.person_rounded)),
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      height: 1.5,
                      letterSpacing: 1.0,
                    ),
                    decoration: InputDecoration(
                      hintText: "What's Happening...!",
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                    controller: _textController,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    autocorrect: false,
                    autofocus: true,
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
          if (_hashTicker != null)
            Expanded(
              flex: 3,
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) => ListTile(
                  subtitle: Text('NSE'),
                  title: Text(_hashTickers[index], style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    final String selTicker = _hashTickers[index];
                    _mentions.add('#$selTicker');
                    String text = _textController.text;
                    text = '${text.substring(0, text.length - _hashTicker!.length)}${selTicker} ';

                    _textController.value = TextEditingValue(
                      text: text,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: text.length),
                      ),
                    );
                  },
                ),
                separatorBuilder: (BuildContext context, int index) => Divider(),
                itemCount: _hashTickers.length,
              ),
            ),
          if (_hashTicker == null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                      child: Text('Bullish'),
                      onPressed: () => setState(() {
                            _postMap['trend'] = true;
                          }),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green))),
                ),
                ElevatedButton(
                    child: Text('Bearish'),
                    onPressed: () => setState(() {
                          _postMap['trend'] = false;
                        }),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red))),
              ],
            ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

class HighlightTextEditingController extends TextEditingController {
  HighlightTextEditingController(this.buildSpan);
  Function buildSpan;

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    return buildSpan(text, style);

    //return super.buildTextSpan(context: context, style: TextStyle(), withComposing: withComposing);
  }
}
