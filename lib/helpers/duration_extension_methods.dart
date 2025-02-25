extension DurationParser on String {
  // Statische Methode zur sicheren Umwandlung eines Strings in eine Duration
  Duration? tryParseDuration() {
    final regex = RegExp(r"^(\d{2}):(\d{2}):(\d{2})(\.(\d{7}))?$");
    final match = regex.firstMatch(this);
  
    if (match != null) {
      try {
        final hours = int.parse(match.group(1)!);
        final minutes = int.parse(match.group(2)!);
        final seconds = int.parse(match.group(3)!);
        final microseconds = int.parse(match.group(5) ?? "0");

        return Duration(
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          microseconds: microseconds,
        );
      } catch (e) {
        // Falls beim Parsen der Zahlen ein Fehler auftritt
        return null;
      }
    } else {
      // Rückgabe von null, wenn das Format nicht stimmt
      return null;
    }
  }
}

extension DurationToString on Duration{
  String toformattedString(){
    return "${inDays > 0 ? "${inDays}D" : ""}${(inHours - inDays * 24) > 0 ? "${(inHours - inDays * 24)}h" : ""}${(inMinutes - inHours * 60) > 0 ? "${(inMinutes - inHours * 60)}m" : ""}";
  }
}