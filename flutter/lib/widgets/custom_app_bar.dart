import 'package:flutter/material.dart';
import 'package:si_penggajian/widgets/search_bar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double toolbarHeight;
  final SearchBar? searchBar;
  final List<Widget> content;
  const CustomAppBar({super.key, required this.toolbarHeight, this.searchBar, required this.content});

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight + 35.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      backgroundColor: Colors.purple.shade200,
      elevation: 10.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        )
      ),
      title: searchBar,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(35.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0, left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: content,
          )
        )
      )
    );
  }
}