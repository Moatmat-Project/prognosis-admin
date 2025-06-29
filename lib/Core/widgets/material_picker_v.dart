import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/widgets/appbar/search_icon_w.dart';
import 'package:moatmat_admin/Core/widgets/toucheable_tile_widget.dart';

import '../../../Core/resources/colors_r.dart';
import '../../../Core/resources/shadows_r.dart';
import '../../../Core/resources/sizes_resources.dart';
import '../../../Core/resources/spacing_resources.dart';
import '../../../Core/resources/texts_resources.dart';
import '../constant/materials.dart';

class MaterialPickerView extends StatefulWidget {
  const MaterialPickerView({
    super.key,
    required this.onPick,
     this.onSearch,
  });
  final Function(String) onPick;
  final Function(String)? onSearch;

  @override
  State<MaterialPickerView> createState() => _MaterialPickerViewState();
}

class _MaterialPickerViewState extends State<MaterialPickerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppBarTitles.materialPicker),
        actions: [
          if(widget.onSearch!=null)
          SearchIconWidget(
            onSearch: widget.onSearch!,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(
          top: SizesResources.s2,
          left: SpacingResources.sidePadding,
          right: SpacingResources.sidePadding,
          bottom: SizesResources.s10 * 2,
        ),
        itemCount: materialsLst.length,
        itemBuilder: (context, index) {
          return TouchableTileWidget(
            title: materialsLst[index]["name"]!,
            onTap: () {
              widget.onPick(materialsLst[index]["name"]!);
            },
          );
        },
      ),
    );
  }
}
