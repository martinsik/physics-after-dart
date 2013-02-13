
part of droidtowers;

class LightEngine {
  
  CanvasRenderingContext2D ctx;
  CanvasRenderingContext2D mainCtx;
  CanvasRenderingContext2D tmpCtx;
  CanvasRenderingContext2D secondTmpCtx;
  CanvasElement canvas;
  CanvasElement canvasTmp;
  CanvasElement secondCanvasTmp;
  double groundLevel;
  
  List<Vector> lights;
  
  Vector bottomPoint;
  Vector bottomVector;
  Vector canvasSun;
  
  
//  LightEngine(Vector pos) : this.position = pos;
  
  LightEngine(CanvasElement elm, CanvasRenderingContext2D mainCtx, double groundLevel) {
    this.lights = new List<Vector>();
    this.canvas = elm;
    this.groundLevel = groundLevel;
    this.canvasTmp = new Element.tag('canvas');
    this.canvasTmp.width = this.canvas.width;
    this.canvasTmp.height = this.canvas.height;

    this.secondCanvasTmp = new Element.tag('canvas');
    this.secondCanvasTmp.width = this.canvas.width;
    this.secondCanvasTmp.height = this.canvas.height;

    this.ctx = elm.getContext("2d");
    this.tmpCtx = this.canvasTmp.getContext("2d");
    this.secondTmpCtx = this.secondCanvasTmp.getContext("2d");
    this.mainCtx = mainCtx;
    
    this.bottomPoint = new Vector(0, this.groundLevel);
    Game.convertWorldToCanvas(this.bottomPoint);
    this.bottomVector = new Vector(Game.canvasCenter.x * 2, this.groundLevel);
    Game.convertWorldToCanvas(this.bottomVector);
  }
  
  
  void add(Vector lightPosition) {
//    Vector newLight = new Vector.copy(point);
    this.lights.add(lightPosition);
    
    if (this.lights.length == 1) {
      this.canvasSun = new Vector.copy(this.lights[0]);
      Game.convertWorldToCanvas(this.canvasSun);
    }
//    return newLight;
  }
  
//  List<Vector> get
  
  void draw(List<GameObject> objects) {
    
    // clear all shadows
//    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
//    this.ctx.fillStyle = "#00f";

//    this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);

    this.canvas.width = this.canvas.width;
    if (!Debug.showShadows) {
      return;
    }

    
    this.secondCanvasTmp.width = this.secondCanvasTmp.width;
    
    
//    Vector sun = new Vector.copy(this.lights[0]);
    // let's use just canvas coordinates
    //sun.mulLocal(Game.VIEWPORT_SCALE);
    
//    this.ctx.globalAlpha = 0.2;
    
//    print(objects.length);
    
    
    for (var box in objects) {
      List<Vector> verticies;
      verticies = box.getRotatedVerticies(this.lights[0]);
      
      this.canvasTmp.width = this.canvasTmp.width;
      
//      List<Vector> verticies = box.getRotatedVerticies();
      
//      Vector intersect = new Vector();

      List<Vector> intersections = new List<Vector>();
      
      double minX = double.MAX_FINITE;
      double maxX = -double.MAX_FINITE;
      int minVertexIndex = 0;
      int maxVertexIndex = 0;
            
//      for (Vector vertex in verticies) {
      for (int i=0; i < verticies.length; i++) {
        Vector intersect = new Vector();
        Vector vertex = verticies[i];
        this._isIntersecting(canvasSun, vertex, this.bottomPoint, this.bottomVector, intersect);
//        Vector nv = new Vector.copy(intersect);
        
//        Game.convertWorldToCanvas(intersect);
        intersections.add(intersect);
        
        if (intersect.x < minX) {
          minVertexIndex = i;
          minX = intersect.x;
        }
        if (intersect.x > maxX) {
          maxVertexIndex = i;
          maxX = intersect.x;
        }
        
//        if (box.highlight) {
//          print("${minX.toInt()} ${maxX.toInt()}: ${intersect.x.toInt()}");
//        }
        
//        Game.convertWorldToCanvas(vertex);
        
        if (Debug.isEnabled()) {
          this.mainCtx.strokeStyle = '#000';
          this.mainCtx.beginPath();
          this.mainCtx.moveTo(canvasSun.x, canvasSun.y);
          this.mainCtx.lineTo(intersect.x, intersect.y);
          this.mainCtx.stroke();
          this.mainCtx.closePath();
        }

      }
      
//      if (box.highlight) {
////        print("$minVertexIndex, $maxVertexIndex: $minX, $maxX");
//      }
      
      
//      List<Vector> strippedIntersections = new List<Vector>();
//      strippedIntersections.add(intersections[minVertexIndex]);
//      strippedIntersections.add(intersections[maxVertexIndex]);
      
      // strip middle intersection
//      print(strippedIntersections);
//      intersections.sort(this._pointsSortMethodX);
//      intersections.removeAt(1);
//      intersections.removeAt(2);
//      print(strippedIntersections);
      
      if (Debug.isEnabled()) {
        this.mainCtx.strokeStyle = '#f00';
        this.mainCtx.beginPath();
        this.mainCtx.moveTo(canvasSun.x, canvasSun.y);
        this.mainCtx.lineTo(intersections[minVertexIndex].x, intersections[minVertexIndex].y);
        this.mainCtx.stroke();
        this.mainCtx.moveTo(canvasSun.x, canvasSun.y);
        this.mainCtx.lineTo(intersections[maxVertexIndex].x, intersections[maxVertexIndex].y);
        this.mainCtx.stroke();
        this.mainCtx.closePath();
      }

      
      if (Debug.isEnabled()) {
//      this.secondTmpCtx.globalAlpha = 1;
        for (int i=0; i < verticies.length; i++) {
          this.mainCtx.globalAlpha = 1;
          this.mainCtx.fillStyle = '#00f';
          this.mainCtx.font = '14px courier';
          this.mainCtx.textBaseline = 'bottom';
          this.mainCtx.fillText(i.toString(), verticies[i].x, verticies[i].y);
        }
      }
      
//      this.tmpCtx.globalAlpha = 1;

//      print("$minVertexIndex, $maxVertexIndex");
      
//      ctx.moveTo(bottomLeft.x, bottomLeft.y);
//      ctx.lineTo(bottom.x, bottom.y);
//      ctx.stroke();
//      
      // draw shadow
      this.tmpCtx.strokeStyle = '#000';
      this.tmpCtx.beginPath();
      this.tmpCtx.moveTo(intersections[minVertexIndex].x / 2, intersections[minVertexIndex].y / 2);
      this.tmpCtx.lineTo(verticies[minVertexIndex].x / 2, verticies[minVertexIndex].y / 2);
      this.tmpCtx.lineTo(verticies[maxVertexIndex].x / 2, verticies[maxVertexIndex].y / 2);
      this.tmpCtx.lineTo(intersections[maxVertexIndex].x / 2, intersections[maxVertexIndex].y / 2);
      this.tmpCtx.fill();
      this.tmpCtx.closePath();

//      this.tmpCtx.beginPath();
    
      double pos1x = (box.body.position.x) * Game.VIEWPORT_SCALE + Game.canvasCenter.x;
      double pos1y = -(box.body.position.y) * Game.VIEWPORT_SCALE + Game.canvasCenter.y;
      pos1x *= 0.5;
      pos1y *= 0.5;
            
      if (box is BasicBoxObject) {
        // remove box from canvas
        this.tmpCtx.save();
        this.tmpCtx.translate(pos1x, pos1y);
        this.tmpCtx.rotate(box.getCurrentAngle());
        this.tmpCtx.clearRect(-box.width / 4, -box.height / 4, box.width / 2, box.height / 2);
        this.tmpCtx.restore();
      } else if (box is Circle) {
        this.tmpCtx.globalCompositeOperation = 'destination-out';

        this.tmpCtx.save();
        this.tmpCtx.beginPath();
        this.tmpCtx.translate(pos1x, pos1y);
        this.tmpCtx.fillStyle = "#f00";
        this.tmpCtx.arc(0, 0, box.shape.radius * Game.VIEWPORT_SCALE / 2, 0, Math.PI * 2, true); 
        this.tmpCtx.closePath();
        this.tmpCtx.fill();
        this.tmpCtx.restore();

        this.tmpCtx.globalCompositeOperation = 'source-over';
      }
      
      
//      this.tmpCtx.clearRect(box.body., 0, this.canvas.width, this.canvas.height);
//      this.tmpCtx.rotate(angle)
      this.secondTmpCtx.drawImage(this.canvasTmp, 0, 0, this.canvas.width, this.canvas.height);      

    }

    
    this.ctx.globalAlpha = 0.3;
    this.ctx.drawImage(this.secondCanvasTmp, 0, 0, this.canvas.width, this.canvas.height);
    

    // draw ground level line for debuging purposes
//    ctx.beginPath();
//    ctx.strokeStyle = '#0f0';
//    ctx.lineWidth = 1;
//    ctx.moveTo(0, -this.groundLevel * Game.VIEWPORT_SCALE + Game.canvasCenter.y);
//    ctx.lineTo(2 * Game.canvasCenter.x, -this.groundLevel * Game.VIEWPORT_SCALE + Game.canvasCenter.y);
//    //print(-this.groundLevel * Game.VIEWPORT_SCALE + Game.canvasCenter.y);
//    ctx.closePath();
//    ctx.stroke();
    
    
//    print("${this.canvas.width} ${this.canvas.height}");
    
  }
  
  bool _isIntersecting(Vector p1, Vector p2, Vector p3, Vector p4, Vector out)
  {
    double denominator = ((p1.x - p2.x) * (p3.y - p4.y)) - ((p1.y - p2.y) * (p3.x - p4.x));
    double numerator1 = (p1.x * p2.y - p1.y * p2.x) * (p3.x - p4.x) - ((p1.x - p2.x) * (p3.x * p4.y - p3.y * p4.x));
    double numerator2 = (p1.x * p2.y - p1.y * p2.x) * (p3.y - p4.y) - ((p1.y - p2.y) * (p3.x * p4.y - p3.y * p4.x));
    
    if (denominator == 0) {
      return (numerator1 == 0.0 && numerator2 == 0.0);
    }

    out.x = numerator1 / denominator;
    out.y = numerator2 / denominator;
    
    return (out.x >= 0 && out.x <= 1) && (out.y >= 0 && out.y <= 1);
  }
  
//  bool _isIntersectingAlt(Vector p1, Vector p2, Vector p3, Vector p4)
//  {
//    double denominator = ((p2.x - p1.x) * (p4.y - p3.y)) - ((p2.y - p1.y) * (p4.x - p3.x));
//    double numerator1 = ((p1.y - p3.y) * (p4.x - p3.x)) - ((p1.x - p3.x) * (p4.y - p3.y));
//    double numerator2 = ((p1.y - p3.y) * (p2.x - p1.x)) - ((p1.x - p3.x) * (p2.y - p1.y));
//
//    // Detect coincident lines (has a problem, read below)
//    if (denominator == 0) {
//      return (numerator1 == 0.0 && numerator2 == 0.0);
////      return (numerator1 == 0 and numerator2 == 0.0);
//    }
//
//    double r = numerator1 / denominator;
//    double s = numerator2 / denominator;
//
//    return (r >= 0 && r <= 1) && (s >= 0 && s <= 1);
//  }
  
//  int _pointsSortMethodX(Vector a, Vector b) {
//    return (a.x > b.x) ? 1 : 0;
//  }
//
//  int _pointsSortMethodY(Vector a, Vector b) {
//    return (a.y > b.y) ? 1 : 0;
//  }

  
}
