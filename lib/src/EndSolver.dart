
part of physics_after_dart;

class EndSolver {
  
  List<Vector2> endPoints;
  List<Critter> critters;
  Vector2 spawnPoint;
  Game game;
  
  EndSolver(List<Vector2> endPoints, Vector2 spawnPoint, List<Critter> critters, Game game):
    this.endPoints = endPoints,
    this.game = game,
    this.spawnPoint = spawnPoint,
    this.critters = critters;
  
  
  void draw(CanvasRenderingContext2D ctx) {
    
    // draw end triangle
    ctx.beginPath();
    ctx.strokeStyle = '#fff';
    ctx.lineWidth = 2;
    ctx.moveTo(this.endPoints[0].x * Game.VIEWPORT_SCALE + Game.canvasCenter.x, -this.endPoints[0].y * Game.VIEWPORT_SCALE + Game.canvasCenter.y);
    ctx.lineTo(this.endPoints[1].x * Game.VIEWPORT_SCALE + Game.canvasCenter.x, -this.endPoints[1].y * Game.VIEWPORT_SCALE + Game.canvasCenter.y);
    ctx.lineTo(this.endPoints[2].x * Game.VIEWPORT_SCALE + Game.canvasCenter.x, -this.endPoints[2].y * Game.VIEWPORT_SCALE + Game.canvasCenter.y);
    ctx.closePath();
    
    ctx.globalAlpha = 0.2;
    ctx.fillStyle = "#fff";
    ctx.fill();
    
    ctx.globalAlpha = 0.8;
    ctx.stroke();

    ctx.beginPath();
    ctx.arc((this.spawnPoint.x + Game.CRITTER_SPAWN_RADIUS / 2) * Game.VIEWPORT_SCALE + Game.canvasCenter.x,
            (-this.spawnPoint.y - Game.CRITTER_SPAWN_RADIUS / 2) * Game.VIEWPORT_SCALE + Game.canvasCenter.y, Game.CRITTER_SPAWN_RADIUS * Game.VIEWPORT_SCALE, 0, 2 * math.PI, false);
    ctx.fillStyle = "#fff";
    ctx.lineWidth = 2;
    ctx.closePath();
    ctx.globalAlpha = 0.2;
    ctx.stroke();
    
    ctx.globalAlpha = 0.05;
    ctx.fillStyle = "#fff";
    ctx.fill();

    
    ctx.globalAlpha = 1.0;
    
  }
  
  void check() {
    for (Critter critter in this.critters) {
      if (this._pointInTriangle(critter.body.position, this.endPoints[0], this.endPoints[1], this.endPoints[2])) {
//        print("true: ${critter.tag}");
        critter.fadeOut = true;
      }
    }
    
  }
  
  
  double _sign(Vector2 p1, Vector2 p2, Vector2 p3)
  {
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
  }

  bool _pointInTriangle(Vector2 pt, Vector2 v1, Vector2 v2, Vector2 v3)
  {
    bool b1, b2, b3;

    b1 = this._sign(pt, v1, v2) < 0.0;
    b2 = this._sign(pt, v2, v3) < 0.0;
    b3 = this._sign(pt, v3, v1) < 0.0;

    return ((b1 == b2) && (b2 == b3));
  }
  
}
