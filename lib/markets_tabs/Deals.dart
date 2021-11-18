import 'package:flutter/material.dart';
// State
import 'package:provider/provider.dart';
import 'package:wods/state/DataHouse.dart';
// common_widget
import 'package:wods/common_widgets/IntervalSelector.dart';

class Deals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        IntervalSelector(
            'Bulk',
            [
              'Bulk',
              'Block',
              'Insides'
            ],
            () {}),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
