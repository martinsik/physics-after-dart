
//import 'package:box2d/box2d.dart';
//import 'GameObject.dart';

part of droidtowers;

class StaticBox extends BasicBoxObject {
  
  PolygonShape shape;
  
  StaticBox(Vector size, Vector position, [double angle]): super() {
    if (!?angle) {
      angle = 0.0;
    }
    
    this.shape = new PolygonShape();
    this.shape.setAsBoxWithCenterAndAngle(size.x, size.y, new Vector(0, 0), angle * Game.DEGRE_TO_RADIAN);
    
//    this.activeFixtureDef = new FixtureDef();
//    this.activeFixtureDef.shape = this.shape;

    this.bodyDef = new BodyDef();
    this.bodyDef.type = BodyType.STATIC;
    this.bodyDef.position = position;

    this.width = 2 * size.x * Game.VIEWPORT_SCALE;
    this.height = 2 * size.y * Game.VIEWPORT_SCALE;
    this.origAngle = angle * Game.DEGRE_TO_RADIAN;

  }
  
  void addObjectToWorld(World world) {
    this.body = world.createBody(this.bodyDef);
    this.body.createFixtureFromShape(this.shape);
  }

  void draw(CanvasRenderingContext2D ctx) {
    
//    ctx.save();
//    int lineWidth = this.height.toInt();
    ctx.fillStyle = '#000';
    ctx.beginPath();
//    ctx.lineWidth = lineWidth;
//    
//    double pos1x = (this.body.position.x + this.shape.vertices[2].x) * Game.VIEWPORT_SCALE + Game.canvasCenter.x;
//    double pos1y = -(this.body.position.y + this.shape.vertices[2].y) * Game.VIEWPORT_SCALE + Game.canvasCenter.y + lineWidth/2;
//    double pos2x = (this.body.position.x + this.shape.vertices[3].x) * Game.VIEWPORT_SCALE + Game.canvasCenter.x;
//    double pos2y = -(this.body.position.y + this.shape.vertices[3].y) * Game.VIEWPORT_SCALE + Game.canvasCenter.y + lineWidth/2;
//
////    print(this.shape.vertices);
////    print("$pos1x, $pos1y, $pos2x, $pos2y");
//    
//    
//    
//    ctx.translate(pos1x, pos1y);
//    ctx.rotate(this.getCurrentAngle());
//    ctx.moveTo(pos1x, pos1y);
//    ctx.lineTo(pos2x, pos2y);
//    ctx.closePath();
//    ctx.stroke();
//    
//    ctx.restore();

    List<Vector> verticies = this.getRotatedVerticies();
    Game.convertWorldToCanvas(verticies[0]);
    Game.convertWorldToCanvas(verticies[1]);
    Game.convertWorldToCanvas(verticies[2]);
    Game.convertWorldToCanvas(verticies[3]);
    
    ctx.moveTo(verticies[0].x, verticies[0].y);
    ctx.lineTo(verticies[1].x, verticies[1].y);
    ctx.lineTo(verticies[2].x, verticies[2].y);
    ctx.lineTo(verticies[3].x, verticies[3].y);

//    this.shape.vertices.
    
//    for (int i=0; i < this.shape.vertexCount; i++) {
//      if (i == 0) {
//        ctx.moveTo(this.body.position.x - );
//      } else {
//        
//      }
//      this.shape.vertices[i];
//    }
//    print(this.shape.vertices);
//    print(this.shape.vertexCount);
//    ctx.moveTo((this.body.position.x - this.shape.) * Game.VIEWPORT_SCALE, this.body.position.y * Game.VIEWPORT_SCALE);
//    ctx.lineTo(0, 0);
//    ctx.lineTo(50, 100);
//    ctx.lineTo(0, 90);
    ctx.closePath();
    ctx.fill();
  }
  

  
}
