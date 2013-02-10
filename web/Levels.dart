
part of droidtowers;

class Levels {

  static Map getLevel(int level) {
    List levels = _getLevels();
    return levels[level];
  }
  
  static List _getLevels() {
    return [
      {"boxes": [
          // x, y, w, h, angl, restitution, density, tex
          [-20.0, 10.0, 3.0, 3.0,  0.0, 0.1, 1.0, "crate2.jpg"],
          [-10.0, 10.0, 3.0, 3.0, 60.0, 0.1, 1.0, "crate2.jpg"],
          [  0.0, 10.0, 3.0, 3.0,  0.5, 0.1, 1.0, "crate2.jpg"],
          [ 10.0,-10.0, 3.0, 3.0, 30.0, 0.1, 1.0, "crate.png"],
          [ 20.0,-10.0, 5.0, 5.0,  0.0, 0.1, 1.0, "crate.png"],
          [  5.0, -5.0, 6.0, 3.0, 45.0, 0.1, 1.0, "box2.jpg"],
          [ -5.0,  0.0, 6.0, 3.0, 45.0, 0.1, 1.0, "box2.jpg"],
          [-15.0, -5.0, 6.0, 3.0, 45.0, 0.1, 1.0, "box2.jpg"]
//          [-20.0, -15.0, 2.0, 3.0, 20.0, 0.1, 1.0, "crate2.jpg"],
//          [-10.0, -15.0, 3.0, 3.0, 30.0, 0.1, 1.0, "crate2.jpg"],
//          [  0.0, -15.0, 2.0, 3.0,-10.0, 0.1, 1.0, "crate2.jpg"],
        ],
        "grounds": [
          // x, y, w, h, angl
          [ 0.0, -25.0,  3.0, 15.0, 0.0 ],
          [ 0.0, -10.0, 10.0,  3.0, 0.0 ]
        ],
        "background" : "level1.jpg",
        "end": [
          // points: x, y, z
          [ -16.0, -34.0 ], [ -3.1, -34.0 ], [ -3.1, -24.0 ]
        ],
        "critters": {
          "spawn_point": [ -30, 19 ],
          "count": 5,
          "seed": 123
        },
        "sun_x": -20.0
      }
    ];

  }
  
}
