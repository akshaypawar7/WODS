import 'package:flutter/material.dart';
// number format
import 'package:intl/intl.dart' as intl;

class QuateListTile extends StatelessWidget {
  final List<dynamic> quate;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  QuateListTile(this.quate, {this.onLongPress, this.onTap});
  var _numFormat = intl.NumberFormat.compact();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(quate.first),
      trailing: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: '${quate[1]}\n', style: TextStyle(fontSize: 17)),
            TextSpan(text: "V: ${_numFormat.format(quate[2])},  D: ${quate[4] == -1 ? '-' : quate[4]} %", style: Theme.of(context).textTheme.caption),
            TextSpan(text: '  ${quate[3]} %', style: TextStyle(color: quate[3] > 0 ? Colors.green : Colors.red)),
          ],
          style: Theme.of(context).textTheme.subtitle1,
        ),
        textAlign: TextAlign.end,
      ),
      subtitle: const Text('NSE'),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
