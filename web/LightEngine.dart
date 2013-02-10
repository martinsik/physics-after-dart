
part of droidtowers;

class LightEngine {
  
  CanvasRenderingContext2D ctx;
  CanvasRenderingContext2D tmpCtx;
  CanvasRenderingContext2D secondTmpCtx;
  CanvasElement canvas;
  CanvasElement canvasTmp;
  CanvasElement secondCanvasTmp;
  double groundLevel;
  
  List<Vector> lights;
//  LightEngine(Vector pos) : this.position = pos;
  
  LightEngine(CanvasElement elm, double groundLevel) {
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
  }
  
  
  void add(Vector lightPosition) {
//    Vector newLight = new Vector.copy(point);
    this.lights.add(lightPosition);
//    return newLight;
  }
  
//  List<Vector> get
  
  void draw(List<GameObject> objects) {
    
    // clear all shadows
//    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
//    this.ctx.fillStyle = "#00f";

//    this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);

    this.canvas.width = this.canvas.width;
    this.secondCanvasTmp.width = this.secondCanvasTmp.width;
    
    Vector bottomPoint = new Vector(0, this.groundLevel);
    Vector bottomVector = new Vector(Game.canvasCenter.x * 2, this.groundLevel);
    
    Vector sun = new Vector.copy(this.lights[0]);
    // let's use just canvas coordinates
    //sun.mulLocal(Game.VIEWPORT_SCALE);
    
//    this.ctx.globalAlpha = 0.2;
    
//    print(objects.length);
    
    Vector canvasSun = new Vector.copy(sun);
    Game.convertWorldToCanvas(canvasSun);
    
    for (GameObject box in objects) {
      List<Vector> verticies;
      if (box is BasicBoxObject) {
        verticies = box.getRotatedVerticies();
      } else if (box is Circle) {
        verticies = box.getRotatedVerticies(sun);
//        continue;
      } else {
        continue;
      }
      
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
        this._isIntersecting(sun, vertex, bottomPoint, bottomVector, intersect);
//        Vector nv = new Vector.copy(intersect);
        
        Game.convertWorldToCanvas(intersect);
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
        
        Game.convertWorldToCanvas(vertex);
        
        if (Game.debug) {
          this.secondTmpCtx.strokeStyle = '#000';
          this.secondTmpCtx.beginPath();
          this.secondTmpCtx.moveTo(canvasSun.x, canvasSun.y);
          this.secondTmpCtx.lineTo(intersect.x, intersect.y);
          this.secondTmpCtx.stroke();
          this.secondTmpCtx.closePath();
        }

      }
      
//      if (box.highlight) {
////        print("$minVertexIndex, $maxVertexIndex: $minX, $maxX");
//      }
      
      
      List<Vector> strippedIntersections = new List<Vector>();
      strippedIntersections.add(intersections[minVertexIndex]);
      strippedIntersections.add(intersections[maxVertexIndex]);
      
      // strip middle intersection
//      print(strippedIntersections);
//      intersections.sort(this._pointsSortMethodX);
//      intersections.removeAt(1);
//      intersections.removeAt(2);
//      print(strippedIntersections);
      
      if (Game.debug) {
        this.secondTmpCtx.strokeStyle = '#f00';
        this.secondTmpCtx.beginPath();
        this.secondTmpCtx.moveTo(canvasSun.x, canvasSun.y);
        this.secondTmpCtx.lineTo(strippedIntersections[0].x, strippedIntersections[0].y);
        this.secondTmpCtx.stroke();
        this.secondTmpCtx.moveTo(canvasSun.x, canvasSun.y);
        this.secondTmpCtx.lineTo(strippedIntersections[1].x, strippedIntersections[1].y);
        this.secondTmpCtx.stroke();
        this.secondTmpCtx.closePath();
      }

      
      if (Game.debug) {
//      this.secondTmpCtx.globalAlpha = 1;
        for (int i=0; i < verticies.length; i++) {
          this.secondTmpCtx.fillStyle = '#00f';
          this.secondTmpCtx.font = '12px courier';
          this.secondTmpCtx.textBaseline = 'bottom';
          this.secondTmpCtx.fillText(i.toString(), verticies[i].x, verticies[i].y);
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
      this.tmpCtx.moveTo(strippedIntersections[0].x, strippedIntersections[0].y);
      this.tmpCtx.lineTo(verticies[minVertexIndex].x, verticies[minVertexIndex].y);
      this.tmpCtx.lineTo(verticies[maxVertexIndex].x, verticies[maxVertexIndex].y);
      this.tmpCtx.lineTo(strippedIntersections[1].x, strippedIntersections[1].y);
      this.tmpCtx.fill();
      this.tmpCtx.closePath();
      

//      this.tmpCtx.beginPath();
      
      double pos1x = (box.body.position.x) * Game.VIEWPORT_SCALE + Game.canvasCenter.x;
      double pos1y = -(box.body.position.y) * Game.VIEWPORT_SCALE + Game.canvasCenter.y;
            
      if (box is BasicBoxObject) {
        // remove box from canvas
        this.tmpCtx.save();
        this.tmpCtx.translate(pos1x, pos1y);
        this.tmpCtx.rotate(box.getCurrentAngle());
        this.tmpCtx.clearRect(-box.width / 2, -box.height / 2, box.width, box.height);
        this.tmpCtx.restore();
      } else if (box is Circle) {
        this.tmpCtx.globalCompositeOperation = 'destination-out';

        this.tmpCtx.save();
        this.tmpCtx.beginPath();
        this.tmpCtx.translate(pos1x, pos1y);
        this.tmpCtx.fillStyle = "#f00";
        this.tmpCtx.arc(0, 0, box.shape.radius * Game.VIEWPORT_SCALE, 0, Math.PI*2, true); 
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
  
  int _pointsSortMethodX(Vector a, Vector b) {
    return (a.x > b.x) ? 1 : 0;
  }

  int _pointsSortMethodY(Vector a, Vector b) {
    return (a.y > b.y) ? 1 : 0;
  }

  
}
