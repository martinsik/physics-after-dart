
part of droidtowers;

abstract class BasicBoxObject extends GameObject {
  

  List<Vector> getRotatedVerticies([Vector lightSource]) {
    
    List<Vector> verticies = new List<Vector>();
    
    double _xpos = this.body.position.x.toDouble();
    double _ypos = -this.body.position.y.toDouble();
    double rad = -this.body.angle - this.origAngle;
    
//    Matrix22 rotMatrix = new Matrix22.fromAngle(rad); 
    
    double hWidth = this.width / 2 / Game.VIEWPORT_SCALE;
    double hHeight = this.height / 2 / Game.VIEWPORT_SCALE;
    double tX, tY;
    
    tX = -(hWidth * Math.cos(rad) - hHeight * Math.sin(rad) ) + _xpos;
    tY = -(hWidth * Math.sin(rad) + hHeight * Math.cos(rad) ) + _ypos;
    
    verticies.add(new Vector(tX, -tY));
    
    tX = -(hWidth * Math.cos(rad) + hHeight * Math.sin(rad) ) + _xpos;
    tY = -(hWidth * Math.sin(rad) - hHeight * Math.cos(rad) ) + _ypos;
    
    verticies.add(new Vector(tX, -tY));
    
    tX = (hWidth * Math.cos(rad) - hHeight * Math.sin(rad) ) + _xpos;
    tY = (hWidth * Math.sin(rad) + hHeight * Math.cos(rad) ) + _ypos;
    
    verticies.add(new Vector(tX, -tY));
    
    tX = (hWidth * Math.cos(rad) + hHeight * Math.sin(rad) ) + _xpos;
    tY = (hWidth * Math.sin(rad) - hHeight * Math.cos(rad) ) + _ypos;
    
    verticies.add(new Vector(tX, -tY));
    
    return verticies;
  }
  
}

