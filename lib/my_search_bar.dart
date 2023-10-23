import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final void Function(String keyword)? _onKeywordChanged;
  final TextEditingController? _controller;
  const MySearchBar({
    super.key,
    TextEditingController? controller,
    void Function(String keyword)? onKeywordChanged,
  })  : _controller = controller,
        _onKeywordChanged = onKeywordChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: _onKeywordChanged,
      ),
    );
  }
}
