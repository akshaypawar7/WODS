import 'package:flutter/material.dart';

class IntervalSelector extends StatelessWidget {
  final String selOption;
  final List<dynamic> options;
  final Function onSelect;
  IntervalSelector(this.selOption, this.options, this.onSelect);
  @override
  Widget build(BuildContext context) {
    final bool _isDarkMode = Theme.of(context).brightness == Brightness.dark ? true : false;
    return Container(
      child: ListView(
        children: options
            .map((i) => TextButton(
                  onPressed: () => onSelect(i),
                  child: Text(i, style: i != selOption ? TextStyle(color: Colors.grey) : TextStyle(fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold)),
                ))
            .toList(),
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
      ),
      height: 40,
    );
  }
}
