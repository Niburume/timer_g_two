import 'package:flutter/material.dart';


class SearchField extends StatefulWidget {
  final TextEditingController searchController;
  final Function searchHandle;

  const SearchField({super.key, required this.searchController, required this.searchHandle});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  // List<Project> _results = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        onChanged: (input) {
          widget.searchHandle(input);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.blueGrey.withOpacity(0.1),
          hintText: "Search for Items",
          hintStyle: const TextStyle(
            color: Color(0xffb2b2b2),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Colors.blueGrey,
        ),
      ),
    );
  }
}
