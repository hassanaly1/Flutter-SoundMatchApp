import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    super.key,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white24,
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: const InputDecoration(
            prefixIcon: Icon(
              CupertinoIcons.search,
              color: Colors.white70,
            ),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w200,
              fontFamily: 'Poppins',
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
