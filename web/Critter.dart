
part of droidtowers;

class Critter extends Circle {
  
  
  Critter(double radius, Vector position) {
    this.width = radius;
    this.height = radius;
    
    this.shape = new CircleShape();
    this.shape.radius = radius;
    
    this.activeFixtureDef = new FixtureDef();
    this.activeFixtureDef.restitution = 0.60;
    this.activeFixtureDef.density = 0.3;
    this.activeFixtureDef.friction = 0.8;
    this.activeFixtureDef.shape = this.shape;
    this.activeFixtureDef.userData = this;

    this.bodyDef = new BodyDef();
    this.bodyDef.type = BodyType.DYNAMIC;
    this.bodyDef.position = position;
    
    this.tag = GameObject.static_counter++;
  }

  
  void draw(CanvasRenderingContext2D ctx) {
//    print('draw');
    
    double pos1x = (this.body.position.x) * Game.VIEWPORT_SCALE + Game.canvasCenter.x;
    double pos1y = -(this.body.position.y) * Game.VIEWPORT_SCALE + Game.canvasCenter.y;

    double radius = this.shape.radius * Game.VIEWPORT_SCALE;
    
    ctx.save();
    ctx.beginPath();
    ctx.translate(pos1x, pos1y);
    ctx.rotate(this.getCurrentAngle());
    ctx.drawImage(this.texture, -radius, -radius, radius * 2, radius * 2);
    ctx.closePath();
    ctx.fill();
    ctx.restore();
    
//    ctx.save();
//    ctx.beginPath();
//    ctx.translate(pos1x, pos1y);
//    ctx.fillStyle = "#f00";
//    ctx.arc(0, 0, this.width * Game.VIEWPORT_SCALE, 0, Math.PI*2, true); 
//    ctx.closePath();
//    ctx.fill();
//    ctx.restore();
    
  }

  
}
