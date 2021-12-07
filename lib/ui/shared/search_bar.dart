import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 22,
              maxWidth: MediaQuery.of(context).size.width * 0.3,
            ),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                // labelText: 'Search',
                // hintText: '',
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
