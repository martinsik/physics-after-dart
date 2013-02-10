
part of droidtowers;

class Circle extends GameObject {
  
  CircleShape shape;
  
  FixtureDef activeFixtureDef;

  
  void addObjectToWorld(World world) {
    this.body = world.createBody(this.bodyDef);
    this.body.createFixture(this.activeFixtureDef);
  }
  
  void draw(CanvasRenderingContext2D ctx) { }
  
  List<Vector> getRotatedVerticies(Vector lightSource) {
    Vector tmp = new Vector.copy(lightSource);
    tmp.subLocal(this.body.position);
    tmp.normalize();
    
    Vector first  = new Vector( tmp.y, -tmp.x);
    Vector second = new Vector(-tmp.y,  tmp.x);
    
    first.mulLocal(this.shape.radius);
    second.mulLocal(this.shape.radius);
    
    first.addLocal(this.body.position);
    second.addLocal(this.body.position);
    
//    Game.convertWorldToCanvas(first);
//    Game.convertWorldToCanvas(second);
    
//    print(first);
//    print(second);
    
    return [first, second];
    
  }
  
}