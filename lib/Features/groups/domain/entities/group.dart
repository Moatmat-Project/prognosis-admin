import 'package:moatmat_admin/Features/groups/domain/entities/group_item.dart';

class Group {
  final int id;
  final String name;
  final List<GroupItem> items;

  Group({
    required this.id,
    required this.name,
    required this.items,
  });

  Group copyWith({
    int? id,
    String? name,
    List<GroupItem>? items,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
    );
  }
}
