import 'package:flutter/material.dart';
import '../../../Presentation/students/views/my_students_v.dart';

class StudentsSearchIconWidget extends StatelessWidget {
  const StudentsSearchIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const MyStudentsView(),
        ));
      },
      icon: const Stack(
        children: [
          Icon(
            Icons.person_search,
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
