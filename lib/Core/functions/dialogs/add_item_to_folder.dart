import 'package:flutter/material.dart';
import 'package:moatmat_admin/Core/resources/colors_r.dart';
import 'package:moatmat_admin/Core/resources/fonts_r.dart';
import 'package:moatmat_admin/Core/resources/sizes_resources.dart';
import 'package:moatmat_admin/Core/resources/spacing_resources.dart';
import 'package:moatmat_admin/Core/services/folders_s.dart';
import 'package:moatmat_admin/Core/widgets/fields/elevated_button_widget.dart';

addItemToFolder({
  required BuildContext context,
  required String key,
  required int id,
  required Function(Folder folder) saveOnFolder,
  required Function(SubFolders subFolder) saveOnSubFolder,
}) {
  showDialog(
    context: context,
    builder: (context) => AddItemToFolderDialog(
      id: id,
      foldersKey: key,
      saveOnFolder: saveOnFolder,
      saveOnSubFolder: saveOnSubFolder,
    ),
  );
}

class AddItemToFolderDialog extends StatefulWidget {
  const AddItemToFolderDialog({
    super.key,
    required this.id,
    required this.foldersKey,
    required this.saveOnFolder,
    required this.saveOnSubFolder,
  });
  final int id;
  final String foldersKey;
  final Function(Folder folder) saveOnFolder;
  final Function(SubFolders subFolder) saveOnSubFolder;
  @override
  State<AddItemToFolderDialog> createState() => _AddItemToFolderDialogState();
}

class _AddItemToFolderDialogState extends State<AddItemToFolderDialog> {
  //
  int? selectedFolder;
  //
  int? selectedSubFolder;
  //
  List<Folder> folders = [];
  //
  @override
  void initState() {
    initFolders();
    super.initState();
  }

  //
  initFolders() async {
    //
    folders = await FoldersService.getFolders(widget.foldersKey);
    //
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SizesResources.s5,
          vertical: SizesResources.s5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            //
            const SizedBox(height: SizesResources.s2),
            //
            if (selectedFolder == null)
              PickFolderWidget(
                folders: folders,
                onTap: (index) {
                  setState(() {
                    selectedFolder = index;
                  });
                },
              ),
            //
            if (selectedFolder != null)
              PickSubFolderWidget(
                folder: folders[selectedFolder!],
                selected: selectedSubFolder,
                onPop: () {
                  selectedFolder = null;
                  setState(() {});
                },
                onTap: (index) {
                  if (index == selectedSubFolder) {
                    selectedSubFolder = null;
                  } else {
                    selectedSubFolder = index;
                  }
                  setState(() {});
                },
                onSave: () {
                  //
                  final folder = folders[selectedFolder!];
                  //
                  if (selectedSubFolder == null) {
                    //
                    widget.saveOnFolder(folder);
                    //
                  } else {
                    //
                    var subFolders = folder.subFolders[selectedSubFolder!];
                    //
                    subFolders = subFolders.copyWith(
                      parent: folder.name,
                    );
                    //
                    widget.saveOnSubFolder(
                      subFolders,
                    );
                    //
                  }
                  Navigator.of(context).pop();
                },
              ),
            //
          ],
        ),
      ),
    );
  }
}

class PickFolderWidget extends StatelessWidget {
  const PickFolderWidget({
    super.key,
    required this.folders,
    required this.onTap,
  });
  final List<Folder> folders;
  final Function(int index) onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Row(
            children: [
              Text("اضافة الى مجلد"),
            ],
          ),
          //
          const SizedBox(height: SizesResources.s2),
          Expanded(
            child: folders.isEmpty
                ? const Center(
                    child: Text(
                      "لا يوجد مجلدات \n قم بانشاء مجلدات لاضافة العناصر اليها",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                      return FolderSelectableTileWidget(
                        title: folders[index].name,
                        onTap: () {
                          onTap(index);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PickSubFolderWidget extends StatelessWidget {
  const PickSubFolderWidget({
    super.key,
    required this.folder,
    required this.onTap,
    required this.onPop,
    required this.selected,
    required this.onSave,
  });
  final int? selected;
  final Folder folder;
  final Function(int? index) onTap;
  final VoidCallback onPop;
  final VoidCallback onSave;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Text(folder.name),
              //
              const Spacer(),
              //
              IconButton(
                onPressed: onPop,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              ),
            ],
          ),
          //
          const SizedBox(height: SizesResources.s2),
          Expanded(
            child: ListView.builder(
              itemCount: folder.subFolders.length,
              itemBuilder: (context, index) {
                return FolderSelectableTileWidget(
                  title: folder.subFolders[index].name,
                  selected: selected == index,
                  onTap: () {
                    onTap(index);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: SizesResources.s2),
          ElevatedButtonWidget(
            text: selected != null
                ? "حفظ في ${folder.subFolders[selected!].name}"
                : "حفظ هنا",
            onPressed: onSave,
            width: SpacingResources.mainHalfWidth(context),
          ),
          const SizedBox(height: SizesResources.s2),
        ],
      ),
    );
  }
}

class FolderSelectableTileWidget extends StatelessWidget {
  const FolderSelectableTileWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.selected = false,
  });
  final String title;
  final VoidCallback onTap;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SpacingResources.mainHalfWidth(context),
      height: 50,
      margin: const EdgeInsets.symmetric(
        vertical: SizesResources.s1,
      ),
      decoration: BoxDecoration(
        color: ColorsResources.onPrimary,
        borderRadius: BorderRadius.circular(10),
        border:
            selected ? Border.all(color: ColorsResources.darkPrimary) : null,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SizesResources.s2,
              vertical: SizesResources.s2,
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: FontsResources.styleBold(size: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
