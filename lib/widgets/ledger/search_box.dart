import 'package:flutter/material.dart';

import '../../constants.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChange;

  const SearchBox({
    Key? key,
    required this.controller,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: kHighLightColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChange,
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: 'Search or Add',
          border: InputBorder.none,
        ),
      ),
    );
  }
}



