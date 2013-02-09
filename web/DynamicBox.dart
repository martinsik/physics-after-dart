
//import 'package:box2d/box2d.dart';
//import 'GameObject.dart';
//import 'dart:math' as Math;

part of droidtowers;

class DynamicBox extends GameObject {
  
  PolygonShape shape;
  
  FixtureDef activeFixtureDef;
  
  double width;
  double height;
  double origAngle;
  
  DynamicBox(Vector size, Vector position, double restitution, double density, [double angle = 0.0, double friction = 1.0]) {
    
    this.shape = new PolygonShape();
    this.shape.setAsBoxWithCenterAndAngle(size.x, size.y, new Vector(0, 0), angle * Game.DEGRE_TO_RADIAN);
    
    this.activeFixtureDef = new FixtureDef();
    this.activeFixtureDef.restitution = restitution;
    this.activeFixtureDef.density = density;
    this.activeFixtureDef.friction = 1.0;
    this.activeFixtureDef.shape = this.shape;
    this.activeFixtureDef.userData = this;

    this.bodyDef = new BodyDef();
    this.bodyDef.type = BodyType.DYNAMIC;
    this.bodyDef.position = position;

    this.width = 2 * size.x * Game.VIEWPORT_SCALE;
    this.height = 2 * size.y * Game.VIEWPORT_SCALE;
    this.origAngle = angle * Game.DEGRE_TO_RADIAN;
    
    this.tag = GameObject.static_counter++;
  }
  
  double getCurrentAngle() {
    return -this.body.angle - this.origAngle; 
  }
  
  void addObjectToWorld(World world) {
    this.body = world.createBody(this.bodyDef);
    this.body.createFixture(this.activeFixtureDef);
  }

  void draw(CanvasRenderingContext2D ctx) {
    
    double pos1x = (this.body.position.x) * Game.VIEWPORT_SCALE + Game.canvasCenter.x;
    double pos1y = -(this.body.position.y) * Game.VIEWPORT_SCALE + Game.canvasCenter.y;
//    double pos1x = (this.body.position.x - this.shape.vertices[2].x) * Game.VIEWPORT_SCALE + Game.canvasCenter.x;
//    double pos1y = -(this.body.position.y + this.shape.vertices[2].y) * Game.VIEWPORT_SCALE + Game.canvasCenter.y;
        
    ctx.save();
    ctx.translate(pos1x, pos1y);
    ctx.rotate(this.getCurrentAngle());
    ctx.drawImage(this.texture, -width / 2, -height / 2, this.width, this.height);
    ctx.restore();

    // highlight edges of this box
    if (this.highlightEdges) {
      List<Vector> boundary = this.getRotatedVerticies();
      ctx.beginPath();
      ctx.strokeStyle = '#f00';
      ctx.lineWidth = 1;
      for (int i=0; i < boundary.length; i++) {
        if (i == 0) {
          ctx.moveTo(boundary[i].x * Game.VIEWPORT_SCALE + Game.canvasCenter.x, -boundary[i].y * Game.VIEWPORT_SCALE + Game.canvasCenter.y);
        } else {
          ctx.lineTo(boundary[i].x * Game.VIEWPORT_SCALE + Game.canvasCenter.x, -boundary[i].y * Game.VIEWPORT_SCALE + Game.canvasCenter.y);
        }
      }
      ctx.closePath();
      ctx.stroke();
    }
    
//    print(this.body.get(this.body.position));
    
    ctx.beginPath();
    ctx.strokeStyle = '#00f';
    ctx.lineWidth = 5;
    ctx.moveTo(pos1x-2, pos1y);
    ctx.lineTo(pos1x+2, pos1y);
    ctx.stroke();

  }
  
  List<Vector> getRotatedVerticies() {
//    for (int i=0; i < this.shape.vertexCount; i++) {
//      
//}
    
// hWidth, hHeight = half the rectangle's width & height
// _xpos, _ypos = center position of the rectangle

    List<Vector> verticies = new List<Vector>();
    
    double _xpos = this.body.position.x;
    double _ypos = -this.body.position.y;
    double rad = -this.body.angle - this.origAngle;
    
    Matrix22 rotMatrix = new Matrix22.fromAngle(rad); 
    
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
