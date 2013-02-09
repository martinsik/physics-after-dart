
part of droidtowers;

class ClickedFixture extends QueryCallback {
  
  Vector clickedPos;
  
  bool reportFixture(Fixture fixture) {
    //print((fixture.userData as GameObject).tag);
//    print('clicked');
    
    DynamicBox box = fixture.userData;
    Matrix22 matr = new Matrix22.fromAngle(box.body.angle);
    Transform trans = new Transform();
    trans.setFromPositionAndRotation(box.body.position, matr);
    
//    print("${box.tag}: ${box.shape.testPoint(trans, this.clickedPos)}");
    
    if (box.shape.testPoint(trans, this.clickedPos)) {
      box.highlightEdges = true;
    }
    
    return true;

//    if (fixture.userData is DynamicBox) {
//      double maxHoriz = Game.canvasCenter.x / Game.VIEWPORT_SCALE;
//      double maxVert = Game.canvasCenter.y / Game.VIEWPORT_SCALE;
//      
//      DynamicBox box = fixture.userData;
//      List<Vector> verticies = box.getRotatedVerticies();
//      
//      for (int j=0; j < 4; j++) {
//        int crosses = 0;
//        Vector v;
//        if (j == 0) {
//          v = new Vector(this.clickedPos.x, maxVert);
//        } else if (j == 1) {
//          v = new Vector(this.clickedPos.x, -maxVert);
//        } else if (j == 2) {
//          v = new Vector(maxHoriz, this.clickedPos.y);
//        } else if (j == 3) {
//          v = new Vector(-maxHoriz, this.clickedPos.y);
//        }
//
//        for (int i=0; i < verticies.length; i++) {
//          if (this._isIntersecting(verticies[i], verticies[i+1 == verticies.length ? 0 : i+1], this.clickedPos, v)) {
//            crosses++;
//          }
//          
////          if (crosses > 1) {
////            break;
////          }
//        }
//        print("${box.tag}, $j: $crosses");
//        
//        if (crosses > 1) {
////          print("${box.tag}: $crosses");
//          break;
//        }
//      }
//      
////      print(crosses);
//    }
//
//    return true;
  }
  
  //bool _isIntersecting(Point a, Point b, Point c, Point d)
//  bool _isIntersecting(Vector p1, Vector p2, Vector p3, Vector p4)
//  {
//    double denominator = ((p2.x - p1.x) * (p4.y - p3.y)) - ((p2.y - p1.y) * (p4.x - p3.x));
//    double numerator1 = ((p1.y - p3.y) * (p4.x - p3.x)) - ((p1.x - p3.x) * (p4.y - p3.y));
//    double numerator2 = ((p1.y - p3.y) * (p2.x - p1.x)) - ((p1.x - p3.x) * (p2.y - p1.y));
//
//    // Detect coincident lines (has a problem, read below)
//    if (denominator == 0) {
//      return (numerator1 == 0.0 && numerator2 == 0.0);
////      return (numerator1 == 0 and numerator2 == 0.0);
//    }
//
//    double r = numerator1 / denominator;
//    double s = numerator2 / denominator;
//
//    return (r >= 0 && r <= 1) && (s >= 0 && s <= 1);
//}
  
}

