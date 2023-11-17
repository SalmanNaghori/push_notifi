// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavigateScreen extends StatefulWidget {
  final String title;
  NavigateScreen({
    required this.title,
  });

  @override
  State<NavigateScreen> createState() => _NavigateScreenState();
}

class _NavigateScreenState extends State<NavigateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/women/11.jpg")),
      ),
    );
  }
}
