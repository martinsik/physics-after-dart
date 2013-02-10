
//import 'package:box2d/box2d.dart';
//import 'GameObject.dart';
//import 'dart:math' as Math;

part of droidtowers;

class DynamicBox extends BasicBoxObject {
  
  PolygonShape shape;
  
  FixtureDef activeFixtureDef;
  
  bool highlight = false;
  
  DynamicBox(Vector size, Vector position, double restitution, double density, [double angle = 0.0, double friction = 1.0]): super() {
    
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
    if (this.highlight || this.hovered) {
      this._drawStroke(ctx, '#fff', 2);
    } else {
      ctx.globalAlpha = 0.5;
      this._drawStroke(ctx, '#000', 1);
      ctx.globalAlpha = 1;
    }
    
//    print(this.body.get(this.body.position));
    
//    ctx.beginPath();
//    ctx.strokeStyle = '#00f';
//    ctx.lineWidth = 5;
//    ctx.moveTo(pos1x-1, pos1y);
//    ctx.lineTo(pos1x+1, pos1y);
//    ctx.closePath();
//    ctx.stroke();

  }
  
  void _drawStroke(CanvasRenderingContext2D ctx, String color, [int lineWidth]) {
    if (!?lineWidth) {
      lineWidth = 1;
    }
    List<Vector> boundary = this.getRotatedVerticies();
    ctx.beginPath();
    ctx.strokeStyle = color;
    ctx.lineWidth = lineWidth;
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
  
  
}
