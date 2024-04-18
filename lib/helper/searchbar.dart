import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white24,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: onChanged,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: Colors.white70,
                  ),
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
