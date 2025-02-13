import 'package:flutter/material.dart';
import 'package:open_media_server_app/helpers/file_info_box_creator.dart';
import 'package:open_media_server_app/helpers/global_key_extension_methods.dart';
import 'package:open_media_server_app/models/file_info/file_info.dart';
import 'package:open_media_server_app/widgets/file_info_box.dart';

class FileInfoRow extends StatefulWidget {
  const FileInfoRow({super.key, required this.fileInfo});
  final FileInfo fileInfo;

  @override
  State<StatefulWidget> createState() => FileInfoRowState();
}

class FileInfoRowState extends State<FileInfoRow> {
  bool expanded = false;
  bool showButton = false;
  List<FileInfoBox> infoBoxes = [];
  final double rightPaddingAsButtonSpacer = 40;

  @override
  void initState() {
    super.initState();
    infoBoxes = widget.fileInfo.createBoxes();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        // Das ist das "versteckte" Wrap, das sich ausklappen kann
        LayoutBuilder(builder: (context, constraints) {
          double availableWidth = constraints.maxWidth;
          double usedWidth = 0;
          bool needsMoreSpace = false;

          for (var box in infoBoxes) {
            final size = (box.key as GlobalKey).getWidgetSize();
            if (size != null) {
              if (usedWidth + size.width > availableWidth - rightPaddingAsButtonSpacer) {
                needsMoreSpace = true;
                break;
              }
              usedWidth += size.width; //maybe need to add spacing
            }
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (showButton != needsMoreSpace) {
              setState(() {
                showButton = needsMoreSpace;
              });
            }
          });

          return AnimatedContainer(
            padding: EdgeInsets.only(right: rightPaddingAsButtonSpacer),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            constraints: BoxConstraints(maxHeight: expanded ? 1000 : 40),
            // height: expanded ? 100 : 40, // Geschlossene Höhe
            width: double.maxFinite,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Wrap(
              // spacing: 8,
              // runSpacing: 8,
              children: infoBoxes,
            ),
          );
        }),
        if (showButton)
          // Der Button, der das Wrap ausklappt
          Positioned(
            right: 0,
            // top: 0,
            child: IconButton(
                onPressed: () => setState(() {
                      expanded = !expanded;
                    }),
                icon: Icon(
                    !expanded ? Icons.arrow_drop_down : Icons.arrow_drop_up)),
            // child: Container(
            //   padding: const EdgeInsets.all(4),
            //   decoration: BoxDecoration(
            //     color: const Color.fromARGB(108, 66, 66, 66),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: Icon(
            //     expanded ? Icons.expand_less : Icons.arrow_drop_down,
            //     color: Colors.white,
            //   ),
            // ),
          ),
      ],
    );
  }

  // Size? _getInfoBoxSize(GlobalKey key) {
  //   final context = key.currentContext;
  //   if (context == null) return null;
  //   final renderBox = context.findRenderObject() as RenderBox?;
  //   return renderBox?.size;
  // }
}
