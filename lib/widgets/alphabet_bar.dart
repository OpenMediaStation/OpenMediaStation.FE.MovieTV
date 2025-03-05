import 'package:alphabet_scrollbar/alphabet_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_media_station_base/models/inventory/inventory_item.dart';

class AlphabetBar extends StatelessWidget {
  const AlphabetBar({
    super.key,
    required this.scrollController,
    required this.filteredItems,
    required this.descending,
    required this.gridLineHeight,
    required this.crossAxisCount,
  });

  final ScrollController scrollController;
  final List<InventoryItem> filteredItems;
  final bool descending;
  final double gridLineHeight;  
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      top: 0,
      child: AlphabetScrollbar(
        padding: const EdgeInsets.only(right: 8, left: 15),
        letterCollection: createAlphabetList(filteredItems),
        onLetterChange: (letter) {
          // await
          HapticFeedback.mediumImpact();
          scrollController.animateTo(
            gridLineHeight *
                (filteredItems.indexWhere((item) =>
                        item.title?.toUpperCase().startsWith(letter) ??
                        false) ~/
                    crossAxisCount),
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          );
        },
        factor: 50,
        style: const TextStyle(fontWeight: FontWeight.bold),
        selectedLetterAdditionalSpace: 25,
        selectedLetterColor: Colors.black,
        reverse: descending,
        selectedLetterContainerDecoration: const BoxDecoration(
            color: Color.fromARGB(255, 194, 194, 194),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 7)]),
        selectedLettercontainerPadding: const EdgeInsets.all(2),
        letterContainerDecoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(179, 41, 41, 41),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 7)
            ]),
        letterContainerPadding: const EdgeInsets.all(2),
      ),
    );
  }

  List<String> createAlphabetList(List<InventoryItem> filteredItems) {
    var letters = filteredItems
        .map((item) {
          var letter = (item.title?.toUpperCase().characters.first ?? "");
          if (['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']
              .contains(letter)) {
            letter = '#';
          }
          return letter;
        })
        .where((c) => c != "")
        .toSet()
        .toList();
    letters.sort((n, m) => n.compareTo(m));
    return letters;
  }
}
