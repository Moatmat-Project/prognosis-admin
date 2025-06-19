import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';

class TopicSelector extends StatefulWidget {
  final void Function(List<String>) onChanged;
  const TopicSelector({required this.onChanged, super.key});

  @override
  State<TopicSelector> createState() => _TopicSelectorState();
}

class _TopicSelectorState extends State<TopicSelector> {
  final List<String> _selectedTopics = [];

  final List<String> topics = ["الادمن", 'الاساتذة', 'الطلاب', 'الرفع'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: topics.map((topic) {
        final isSelected = _selectedTopics.contains(topic);

        return FilterChip(
          label: Text(topic),
          selected: isSelected,
          selectedColor: ColorsResources.primaryLight,
          side: BorderSide(
            color: isSelected ? ColorsResources.primary : ColorsResources.borders,
            width: isSelected ? 2 : 1,
          ),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedTopics.add(topic);
              } else {
                _selectedTopics.remove(topic);
              }
              widget.onChanged(_selectedTopics);
            });
          },
        );
      }).toList(),
    );
  }
}
