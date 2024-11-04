final Map<int, String> sgrMap = {
    1: "bold",
    2: "dim",
    3: "italic",
    4: "underline",
    5: "slow_blink",
    6: "rapid_blink",
    7: "swap",
    8: "hide",
    9: "strikethrough",

    22: "normal",
    23: "no_italic",
    24: "no_underlined",
    25: "no_blinking",
    27: "no_swap",
    28: "show",
    29: "no_strikethrough",

    30: "fg_black",
    31: "fg_red",
    32: "fg_green",
    33: "fg_yellow",
    34: "fg_blue",
    35: "fg_magenta",
    36: "fg_cyan",
    37: "fg_white",

    40: "bg_black",
    41: "bg_red",
    42: "bg_green",
    43: "bg_yellow",
    44: "bg_blue",
    45: "bg_magenta",
    46: "bg_cyan",
    47: "bg_white",

    90: "fg_brigh_black",
    91: "fg_brigh_red",
    92: "fg_brigh_green",
    93: "fg_brigh_yellow",
    94: "fg_brigh_blue",
    95: "fg_brigh_magenta",
    96: "fg_brigh_cyan",
    97: "fg_brigh_white",

    100: "bg_brigh_black",
    101: "bg_brigh_red",
    102: "bg_brigh_green",
    103: "bg_brigh_yellow",
    104: "bg_brigh_blue",
    105: "bg_brigh_magenta",
    106: "bg_brigh_cyan",
    107: "bg_brigh_white"

};


void safeReplaceRange<T>(List<T> list, int start, int end, Iterable<T> replacement) {
  // Ensure start is non-negative
  if (start < 0) {
    throw RangeError('Start index cannot be negative.');
  }

  // if (null is! T) {
  //   throw ArgumentError("only accept nullable type");
  // }

  // Expand the list if the end index is out of range
  if (end > list.length) {
    // list.length = end; // This will fill the list with null if end is out of bounds
    // 0 1 2 3 , 4
    var need = end - list.length;
    var replace_list = replacement.toList().sublist(0, need);
    var extend_list  = replacement.toList().sublist(need );

    list.replaceRange(start, list.length,replace_list );

    for (var element in extend_list) {
      list.add(element);
    }
  } else{
    // Replace the range safely
    list.replaceRange(start, end, replacement);
  }

  
  
}














extension ExtendList<T> on List<T> {
  void extend(int newLength, T defaultValue) {
    assert(newLength >= 0);

    final lengthDifference = newLength - this.length;
    if (lengthDifference <= 0) {
      return;
    }

    this.addAll(List.filled(lengthDifference, defaultValue));
  }
}




List<String> splitWithDelimiters(String input, RegExp regex) {
  // Use the provided regex pattern to create a RegExp object
  

  // Use splitMapJoin to split and include delimiters
  List<String> result = [];

  input.splitMapJoin(
    regex,
    onMatch: (match) {
      result.add(match[0]!); // Add the delimiter (match)
      return match[0]!;
    },
    onNonMatch: (nonMatch) {
      result.add(nonMatch); // Add the non-matched part (text between delimiters)
      return nonMatch;
    },
  );

  return result;
}
