
part of physics_after_dart;

class Common {
  
  static List shuffle(List items) {
    var random = new Math.Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {

      // Pick a pseudorandom number.
      var n = random.nextInt(items.length);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }
  
}

