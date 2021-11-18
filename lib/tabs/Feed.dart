import 'package:flutter/material.dart';
import 'package:wods/post/FeedList.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.post_add_outlined),
              onPressed: () => Navigator.pushNamed(
                context,
                '/CreatePost',
              ),
            ),
          ],
          title: const Text('Feed'),
          floating: true,
          snap: true,
        ),
        FeedList(),
      ],
    );
  }
}
