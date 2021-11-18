import 'package:flutter/material.dart';
import 'package:wods/MyApp.dart';
// pages
import 'package:wods/pages/SearchSymbol.dart';
import 'package:wods/pages/EditWatchlist.dart';
import 'package:wods/pages/SymbolDetail.dart';
// post
import 'package:wods/post/CreatePost.dart';
// Auth
import 'package:wods/authentication/UserId.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyApp());
      case '/SearchSymbol':
        return MaterialPageRoute(builder: (_) => SearchSymbol(selListConsti: settings.arguments as List<dynamic>?));
      case '/EditWatchlist':
        return MaterialPageRoute(builder: (_) => EditWatchlist(settings.arguments as List<dynamic>));
      case '/SymbolDetail':
        return MaterialPageRoute(builder: (_) => SymbolDetail(settings.arguments as String));
      case '/CreatePost':
        return MaterialPageRoute(builder: (_) => CreatePost(symbol: settings.arguments as String?));
      case '/UserId':
        return MaterialPageRoute(builder: (_) => UserId());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
              body: Center(
            child: Text('404', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
          )),
        );
    }
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akshay Pawar Patil'),
      ),
      body: Center(
        child: Text(
          'Text',
        ),
      ),
    );
  }
}
