import 'package:flutter/material.dart';

import 'package:wods/post/PostBody.dart';
// State
import 'package:provider/provider.dart';
import 'package:wods/state/PostState.dart';
// firestore
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedList extends StatelessWidget {
  final String? symbol;
  const FeedList({this.symbol});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: context.read<PostState>().getFeed(symbol: symbol),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return SliverList(
            delegate: SliverChildListDelegate(
              snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Column(
                  children: <Widget>[
                    PostBody(
                      data,
                      context.read<PostState>().getAvatar(data['userId']),
                    ),
                    Divider()
                  ],
                );
              }).toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Text('Something went wrong'),
          );
        }

        return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
