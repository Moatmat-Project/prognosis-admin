import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/widgets/view/search_v.dart';
import 'package:moatmat_admin/Presentation/students/views/my_students_v.dart';

class SearchIconWidget extends StatelessWidget {
  const SearchIconWidget({super.key, required this.onSearch});
  final Function(String) onSearch;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchView(onSearch: onSearch),
          ),
        );
      },
      icon: const Stack(
        children: [
          Icon(
            Icons.search,
          ),
          Align(
            alignment: Alignment.topRight,
            child: CircleAvatar(
              radius: 3,
              backgroundColor: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}
