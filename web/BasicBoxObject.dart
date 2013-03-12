
part of physics_after_dart;

abstract class BasicBoxObject extends GameObject {
  

  List<vec2> getRotatedVerticies([vec2 lightSource]) {
    
    List<vec2> verticies = new List<vec2>();
    
    double _xpos = this.body.position.x.toDouble();
    double _ypos = -this.body.position.y.toDouble();
    double rad = -this.body.angle - this.origAngle;
    
//    Matrix22 rotMatrix = new Matrix22.fromAngle(rad); 
    
    double hWidth = this.width / 2 / Game.VIEWPORT_SCALE;
    double hHeight = this.height / 2 / Game.VIEWPORT_SCALE;
    double tX, tY;
    
    tX = -(hWidth * Math.cos(rad) - hHeight * Math.sin(rad) ) + _xpos;
    tY = -(hWidth * Math.sin(rad) + hHeight * Math.cos(rad) ) + _ypos;
    
    verticies.add(new vec2(tX, -tY));
    
    tX = -(hWidth * Math.cos(rad) + hHeight * Math.sin(rad) ) + _xpos;
    tY = -(hWidth * Math.sin(rad) - hHeight * Math.cos(rad) ) + _ypos;
    
    verticies.add(new vec2(tX, -tY));
    
    tX = (hWidth * Math.cos(rad) - hHeight * Math.sin(rad) ) + _xpos;
    tY = (hWidth * Math.sin(rad) + hHeight * Math.cos(rad) ) + _ypos;
    
    verticies.add(new vec2(tX, -tY));
    
    tX = (hWidth * Math.cos(rad) + hHeight * Math.sin(rad) ) + _xpos;
    tY = (hWidth * Math.sin(rad) - hHeight * Math.cos(rad) ) + _ypos;
    
    verticies.add(new vec2(tX, -tY));
    
    return verticies;
  }
  
}

