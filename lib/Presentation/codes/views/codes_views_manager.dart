import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Presentation/codes/state/cubit/codes_cubit.dart';
import 'package:moatmat_admin/Presentation/codes/views/code_v.dart';
import 'package:moatmat_admin/Presentation/codes/views/generate_code_v.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Core/resources/colors_r.dart';

class CodesViewManager extends StatefulWidget {
  const CodesViewManager({super.key});

  @override
  State<CodesViewManager> createState() => _CodesViewManagerState();
}

class _CodesViewManagerState extends State<CodesViewManager> {
  late final PageController _pageController;
  List<ScreenshotController> controllers = [];
  int current = 1, last = 1;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<CodesCubit>().init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controllers.isEmpty) {
      controllers = List.generate(
        context.read<CodesCubit>().codes.length,
        (index) => ScreenshotController(),
      );
    }
  }

  saveScreenShots() async {
    setState(() {
      loading = true;
    });

    List<XFile> files = [];
    Rect rect = getRect();
    int numberOfPages = controllers.length;

    for (int i = 0; i < numberOfPages; i++) {
      //
      Completer<void> completer = Completer<void>();
      //
      try {
        //
        _pageController.jumpToPage(i);
        //
        var value = await controllers[i].capture();
        //
        if (value == null) {
          debugPrint("Screenshot capture failed for page $i.");
          completer.complete();
          continue;
        }
        //
        final filePath = await getFilePath();
        //
        await XFile.fromData(value).saveTo(filePath);
        //
        files.add(XFile(filePath));
        //
        debugPrint("Screenshot saved for page $i.");
      } catch (e) {
        debugPrint("Error capturing screenshot for page $i: $e");
      } finally {
        completer.complete();
      }

      await completer.future;
    }
    setState(() {
      loading = false;
    });
    if (files.isNotEmpty) {
      try {
        await Share.shareXFiles(files, sharePositionOrigin: rect);
      } catch (e) {
        debugPrint("Error sharing files: $e");
      }
    }
  }

  Rect getRect() {
    return Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      ),
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
    );
  }

  Future<String> getFilePath() async {
    //
    Directory? externalDir;
    //
    if (Platform.isIOS) {
      externalDir = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      externalDir = await getExternalStorageDirectory();
    } else {
      externalDir = await getApplicationSupportDirectory();
    }
    //
    final ts = DateTime.now().toIso8601String();
    //
    final filePath = "${externalDir!.path}/$ts.png";
    //
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsResources.primary,
      body: BlocBuilder<CodesCubit, CodesState>(
        builder: (context, state) {
          if (state is CodesInitial) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: ColorsResources.primary,
                foregroundColor: ColorsResources.whiteText2,
              ),
              body: const GenerateCodeView(),
            );
          } else if (state is CodesGenerateCodes) {
            last = state.codes.length;
            return Scaffold(
              backgroundColor: ColorsResources.primary,
              appBar: AppBar(
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: loading ? () {} : saveScreenShots,
                    icon: loading
                        ? const CupertinoActivityIndicator(
                            color: ColorsResources.whiteText1,
                          )
                        : const Icon(Icons.save_alt),
                  ),
                ],
                title: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "$current/$last",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                backgroundColor: ColorsResources.primary,
                foregroundColor: ColorsResources.whiteText2,
              ),
              body: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    current = value + 1;
                  });
                },
                itemCount: state.codes.length,
                itemBuilder: (context, index) {
                  if (controllers.length != state.codes.length) {
                    controllers.add(ScreenshotController());
                  }
                  return CodeView(
                    codeData: state.codes[index],
                    controller: controllers[index],
                  );
                },
              ),
            );
          } else if (state is CodesError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: ColorsResources.primary,
                foregroundColor: ColorsResources.whiteText2,
              ),
              body: Center(
                child: Text(state.error),
              ),
            );
          }
          return Center(
            child: Scaffold(
              backgroundColor: ColorsResources.primary,
              appBar: AppBar(
                backgroundColor: ColorsResources.primary,
                foregroundColor: ColorsResources.whiteText2,
              ),
              body: const Center(
                child: CupertinoActivityIndicator(
                  color: ColorsResources.whiteText1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
