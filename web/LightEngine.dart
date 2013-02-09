
part of droidtowers;

class LightEngine {
  
//  Vector position;
  
  CanvasRenderingContext2D ctx;
  CanvasElement canvas;
  
  List<Vector> lights;
//  LightEngine(Vector pos) : this.position = pos;
  
  LightEngine(CanvasElement elm) :
    this.lights = new List<Vector>(),
    this.canvas = elm,
    this.ctx = elm.getContext("2d");
  
  
  void add(Vector lightPosition) {
//    Vector newLight = new Vector.copy(point);
    this.lights.add(lightPosition);
//    return newLight;
  }
  
//  List<Vector> get
  
  void draw(List<GameObject> objects) {
    // clear all shadows
    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
//    this.ctx.fillStyle = "#00f";
//    this.ctx.globalAlpha = 0.3;
//    this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);

    Vector sun = new Vector.copy(this.lights[0]);
    // let's use just canvas coordinates
    sun.mulLocal(Game.VIEWPORT_SCALE);
    
    for (DynamicBox box in objects) {
      List<Vector> verticies = box.getRotatedVerticies();
      // remove closest vertex to the light source
      int closestIndex = 0;
      double closestDistance = 0.0;
      for (int i=0; i < verticies.length; i++) {
        double dist = verticies[i].distanceBetween(lights[0]);
        if (dist < closestDistance) {
          closestDistance = dist;
          closestIndex = i;
        }
      }
      verticies.removeAt(closestIndex);
      
//      Vector first = verticies.removeAt(0);
//      ctx.moveTo(first.x, first.y);
      
      for (Vector vertex in verticies) {
        ctx.beginPath();
        ctx.strokeStyle = '#000';
        ctx.lineWidth = 2;
        ctx.moveTo(sun.x, -sun.y);
        ctx.lineTo(vertex.x * Game.VIEWPORT_SCALE + Game.canvasCenter.x, -vertex.y * Game.VIEWPORT_SCALE + Game.canvasCenter.y);
        ctx.closePath();
        ctx.stroke();
      }
    }

//    print("${this.canvas.width} ${this.canvas.height}");
    
  }
  
  
}
