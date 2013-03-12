
part of physics_after_dart;

class Circle extends GameObject {
  
  CircleShape shape;
  
  FixtureDef activeFixtureDef;

  Circle() : super();
  
  
  void addObjectToWorld(World world) {
    this.body = world.createBody(this.bodyDef);
    this.body.createFixture(this.activeFixtureDef);
  }
  
  void draw(CanvasRenderingContext2D ctx) { }
  
  List<vec2> getRotatedVerticies(vec2 lightSource) {
    
    vec2 tmp = new vec2.copy(lightSource);
    tmp.sub(this.body.position);
    tmp.normalize();
    
    vec2 first  = new vec2( tmp.y, -tmp.x);
    vec2 second = new vec2(-tmp.y,  tmp.x);
    
    first = first * this.shape.radius;
    second = second * this.shape.radius;
    
    first.add(this.body.position);
    second.add(this.body.position);
    
    Game.convertWorldToCanvas(first);
    Game.convertWorldToCanvas(second);
    
    return [first, second];
    
//    Vector tmp = new Vector.copy(lightSource);
//    Vector canvasPos = new Vector.copy(this.body.position);
//    Game.convertWorldToCanvas(canvasPos);
//    
//    tmp.subLocal(canvasPos);
//    tmp.normalize();
//    
//    
////    Game.convertWorldToCanvas(second);
// 
//    
//    Vector first  = new Vector( tmp.y, -tmp.x);
//    Vector second = new Vector(-tmp.y,  tmp.x);
//    
////    first.normalize();
////    second.normalize();
//    
//    first.mulLocal(this.shape.radius);
//    second.mulLocal(this.shape.radius);
//    
//    first.addLocal(this.body.position);
//    second.addLocal(this.body.position);
//    
//    Game.convertWorldToCanvas(first);
//    Game.convertWorldToCanvas(second);
//    
//    return [first, second];
    
  }
  
}