import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:async';
import 'dart:io';
// Hive Local Database
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

// Image Picker
import 'package:image_picker/image_picker.dart';
// firebase Storage
import 'package:firebase_storage/firebase_storage.dart';

class UserId extends StatefulWidget {
  @override
  _UserIdState createState() => _UserIdState();
}

class _UserIdState extends State<UserId> {
  final Box _box = Hive.box('app_state');
  XFile? image;
  String _userName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              _box.put('darkMode', !_box.get('darkMode', defaultValue: false));
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(_userName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: image != null
                  ? kIsWeb
                      ? NetworkImage(image!.path)
                      : Image.file(
                          File(image!.path),
                          fit: BoxFit.cover,
                        ).image
                  : null,
            ),
          ),
          TextButton(
            child: Text('Set Profile Image'),
            onPressed: () => _pickImage(),
          ),
          TextField(
            onSubmitted: (String text) => setState(() {
              _box.put('userId', text);
              _userName = text;
            }),
          )
        ],
      ),
    );
  }

  Future<Null> _pickImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {});
    }
    FirebaseStorage _storage = FirebaseStorage.instance;

    Reference reference = _storage.ref().child("profile").child(_userName);

    if (kIsWeb) {
      TaskSnapshot c = await reference.putData(
        await image!.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );
    } else {
      TaskSnapshot c = await reference.putFile(File(image!.path));
    }
  }
}
