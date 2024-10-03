import 'package:moatmat_admin/Features/groups/data/models/group_item_m.dart';
import 'package:moatmat_admin/Features/groups/domain/entities/group.dart';

import '../../domain/entities/group_item.dart';

class GroupModel extends Group {
  GroupModel({
    required super.id,
    required super.name,
    required super.items,
  });

  factory GroupModel.fromJson(Map json) {
    List itemsJson = json["items"];
    return GroupModel(
      id: json["id"],
      name: json["name"],
      items: List.generate(itemsJson.length, (index) {
        return GroupItemModel.fromJson(itemsJson[index]);
      }),
    );
  }
  factory GroupModel.fromClass(Group group) {
    return GroupModel(
      id: group.id,
      name: group.name,
      items: group.items,
    );
  }

  Map<String, dynamic> toJson() {
    final list = filterDuplicatedItems(items);
    return {
      "id": id,
      "name": name,
      "items": List.generate(list.length, (index) {
        return GroupItemModel.fromClass(list[index].copyWith(id: index))
            .toJson();
      }),
    };
  }

  List<GroupItem> filterDuplicatedItems(List<GroupItem> items) {
    //
    Set<String> uuids = {};
    //
    List<GroupItem> list = [];
    //
    for (var item in items) {
      if (!uuids.contains(item.userData.uuid)) {
        list.add(item);
        uuids.add(item.userData.uuid);
      }
    }
    //
    return list;
  }
}
