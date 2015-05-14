
part of physics_after_dart;

abstract class BasicBoxObject extends GameObject {
  

  List<Vector2> getRotatedVerticies([Vector2 lightSource]) {
    
    List<Vector2> verticies = new List<Vector2>();
    
    double _xpos = this.body.position.x.toDouble();
    double _ypos = -this.body.position.y.toDouble();
    double rad = -this.body.getAngle() - this.origAngle;
    
//    Matrix22 rotMatrix = new Matrix22.fromAngle(rad); 
    
    double hWidth = this.width / 2 / Game.VIEWPORT_SCALE;
    double hHeight = this.height / 2 / Game.VIEWPORT_SCALE;
    double tX, tY;
    
    tX = -(hWidth * math.cos(rad) - hHeight * math.sin(rad) ) + _xpos;
    tY = -(hWidth * math.sin(rad) + hHeight * math.cos(rad) ) + _ypos;
    
    verticies.add(new Vector2(tX, -tY));
    
    tX = -(hWidth * math.cos(rad) + hHeight * math.sin(rad) ) + _xpos;
    tY = -(hWidth * math.sin(rad) - hHeight * math.cos(rad) ) + _ypos;
    
    verticies.add(new Vector2(tX, -tY));
    
    tX = (hWidth * math.cos(rad) - hHeight * math.sin(rad) ) + _xpos;
    tY = (hWidth * math.sin(rad) + hHeight * math.cos(rad) ) + _ypos;
    
    verticies.add(new Vector2(tX, -tY));
    
    tX = (hWidth * math.cos(rad) + hHeight * math.sin(rad) ) + _xpos;
    tY = (hWidth * math.sin(rad) - hHeight * math.cos(rad) ) + _ypos;
    
    verticies.add(new Vector2(tX, -tY));
    
    return verticies;
  }
  
}

