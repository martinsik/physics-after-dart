library droidtowers;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:json' as json;
import 'package:box2d/box2d_browser.dart';

part 'GameObject.dart';
part 'BasicBoxObject.dart';
part 'StaticBox.dart';
part 'DynamicBox.dart';
part 'Color.dart';
part 'ClickedFixture.dart';
part 'DragHandler.dart';
part 'LightEngine.dart';
part 'GameEventHandlers.dart';
part 'Levels.dart';
part 'Circle.dart';
part 'Critter.dart';


class Game {
  
  static const num GRAVITY = -50;
  static const num TIME_STEP = 1/60;
  static const int VELOCITY_ITERATIONS = 5;
  static const int POSITION_ITERATIONS = 5;
  static const int VIEWPORT_SCALE = 10;
  static const int MOVE_VELOCITY = 5;
  static const double DEGRE_TO_RADIAN = 0.0174532925;

  static Vector canvasCenter;
  
  // All of the bodies in a simulation.
  List<GameObject> grounds;
  List<GameObject> dynamicObjects;
  List<Critter> critters;
  
  static const bool debug = false;
  
  int canvasFpsCounter = 0;
  double canvasWorldStepTime = 0.0;

  // The debug drawing tool.
  DebugDraw debugDraw;

  // The physics world.
  World world;

  // The drawing canvas.
  CanvasElement canvas;
  CanvasElement shadowCanvas;

  // The canvas rendering context.
  CanvasRenderingContext2D ctx;

  // For timing the world.step call. It is kept running but reset and polled
  // every frame to minimize overhead.
  Stopwatch stopwatch;

//  double groundHeight = 2.0;
  double groundLevel = 0.0;
  
  // Microseconds for world step update
  int elapsedUs;
  
  // Frame count for fps
  int frameCount;

  // The transform abstraction layer between the world and drawing canvas.
//  IViewportTransform viewport;
  
  LightEngine lightEngine;
  
  GameEventHandlers eventHandler;
  
  Vector sun;
  
  double groundHeight = 1.0;
  
  void init() {
//    print(window.screen.width);
//    print(window.screen.height);
    
    this.stopwatch = new Stopwatch();
    
    this.eventHandler = new GameEventHandlers(this);
    
    // create physics world
    Vector gravity = new Vector(0, GRAVITY);
    this.world = new World(gravity, true, new DefaultWorldPool());

//    fpsCounter = query("#fps-counter");
//    worldStepTimeCounter = query("#step-time-counter");
    
    // init HTML elements
    this.canvas = query("#main_canvas");
    this.shadowCanvas = query("#shadow_canvas");
    ctx = canvas.getContext("2d");
    resizeCanvas();
    
    this._reset();
    
    this._initListeners();

    // Create the viewport transform with the center at extents.
    final extents = new Vector(this.canvas.width / 2, this.canvas.height / 2);
    IViewportTransform viewport;
    viewport = new CanvasViewportTransform(extents, extents);
    viewport.scale = VIEWPORT_SCALE;
    
    // Create our canvas drawing tool to give to the world.
    debugDraw = new CanvasDraw(viewport, ctx);

    // Have the world draw itself for debugging purposes.
    world.debugDraw = debugDraw;
    frameCount = 0;
    
    window.setInterval(() {
      canvasFpsCounter = frameCount;
      frameCount = 0;
    }, 1000);
    window.setInterval(() {
      canvasWorldStepTime = elapsedUs / 1000;
    }, 200);

    
//    Body ground;
//    ground = world.createBody(bd);
    
  }
  
  void _reset() {
    this.grounds = new List<GameObject>();
    this.dynamicObjects = new List<GameObject>();
    this.critters = new List<Critter>(); 
    
    this.groundLevel = -Game.canvasCenter.y / Game.VIEWPORT_SCALE;
//    this._createGround(groundHeight);
    
    this.lightEngine = new LightEngine(query("#shadow_canvas"), this.groundLevel + groundHeight);
    this.sun = new Vector(0, Game.canvasCenter.y / Game.VIEWPORT_SCALE);
    this.lightEngine.add(this.sun);

    Map level = Levels.getLevel(0);
    this._createBoxes(level['boxes']);
    this._createGround(this.groundHeight, level['grounds']);
    document.body.style.backgroundImage = "url(./images/${level['background']})";
    double aspect = this.canvas.height / 1000.0;
    document.body.style.backgroundSize = "${aspect * 1500}px ${aspect * 1000}px";
    
//    print(Levels.getLevel(0));
  }
  
  void _initListeners() {
    
    this.shadowCanvas.onMouseDown.listen((e) {
      eventHandler.onMouseDown(e);
    });
    
    this.shadowCanvas.onMouseUp.listen((e) {
      eventHandler.onMouseUp(e);
    });

    this.shadowCanvas.onMouseMove.listen((e) {
      eventHandler.onMouseMove(e);
    });
    
    window.onKeyDown.listen((e) {
      if (this.eventHandler.dragHandler.isActive()) {
        if (e.keyCode == 37) { // left arrow
          this.eventHandler.dragHandler.rotateLeft = true;
        } else if (e.keyCode == 39) { // right arrow
          this.eventHandler.dragHandler.rotateRight = true;
        } else if (e.keyCode == 32) { // space
          // @TODO: rotate to default position
        }
      }
    });

    window.onKeyUp.listen((e) {
      if (this.eventHandler.dragHandler.isActive()) {
        if (e.keyCode == 37) { // left arrow
          this.eventHandler.dragHandler.rotateLeft = false;
        } else if (e.keyCode == 39) { // right arrow
          this.eventHandler.dragHandler.rotateRight = false;
        } else if (e.keyCode == 32) { // space
          // @TODO: rotate to default position
        }
        
        this.eventHandler.dragHandler.getActiveObject().body.angularVelocity = 0.0;
      }
    });

    window.onResize.listen((e) {
      resizeCanvas();
    });
  }
  
  void _createGround(double height, List moreGrounds) {
    StaticBox ground;
    ground = new StaticBox(new Vector(200.0, height / 2), new Vector(0.0, this.groundLevel + height / 2));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);
    
    ground = new StaticBox(new Vector(200.0, 1.0), new Vector(0.0, Game.canvasCenter.y / Game.VIEWPORT_SCALE));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);

    ground = new StaticBox(new Vector(1.0, (Game.canvasCenter.y * 2) / Game.VIEWPORT_SCALE), new Vector(Game.canvasCenter.x / Game.VIEWPORT_SCALE, 0));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);

    ground = new StaticBox(new Vector(1.0, (Game.canvasCenter.y * 2) / Game.VIEWPORT_SCALE), new Vector(-Game.canvasCenter.x / Game.VIEWPORT_SCALE, 0));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);
    
    for (List groundDefinition in moreGrounds) { 
      ground = new StaticBox(new Vector(groundDefinition[2], groundDefinition[3]),
                             new Vector(groundDefinition[0], groundDefinition[1]),
                             groundDefinition[4]);
      ground.addObjectToWorld(this.world);
      this.grounds.add(ground);
      this.dynamicObjects.add(ground);
    }
    
  }
  
  void _createBoxes(List boxes) {
    DynamicBox box;
    
    for (List boxDefinition in boxes) {
      
//      double test = boxDefinition[4];
      
      box = new DynamicBox(new Vector(boxDefinition[2], boxDefinition[3]),
                           new Vector(boxDefinition[0], boxDefinition[1]),
                           boxDefinition[5], boxDefinition[6], boxDefinition[4]);
      box.addObjectToWorld(this.world);
      box.setTexture("./images/${boxDefinition[7]}");
      
      this.dynamicObjects.add(box);
    }
    
    Critter c1 = new Critter(2.0, new Vector(20, 0));
    c1.setTexture("./images/circle.png");
    c1.addObjectToWorld(this.world);
    
    this.dynamicObjects.add(c1);
    
  }
  

  void resizeCanvas() {
//    print('resize: [${window.innerWidth}, ${window.innerHeight}]');
    this.canvas.width = window.innerWidth;
    this.canvas.height = window.innerHeight;
    this.shadowCanvas.width = window.innerWidth;
    this.shadowCanvas.height = window.innerHeight;
    Game.canvasCenter = new Vector(this.canvas.width / 2, this.canvas.height / 2); 
  }
  
  /** Advances the world forward by timestep seconds. */
  void _step(num timestamp) {
    stopwatch.reset();
    world.step(TIME_STEP, VELOCITY_ITERATIONS, POSITION_ITERATIONS);
    elapsedUs = stopwatch.elapsedMicroseconds;

    // am I draging something?
    if (this.eventHandler.dragHandler.isActive()) {
      double dist = this.eventHandler.dragHandler.objectDistanceToDestination();
      GameObject obj = this.eventHandler.dragHandler.getActiveObject(); 
//      if (dist < 0.1) {
//        obj.body.linearVelocity = new Vector(0, 0);
//        mouseDragHandler.deactivate();
//      } else {
      Vector diffVector = new Vector.copy(this.eventHandler.dragHandler.getCorrectedDestination());
      diffVector.subLocal(obj.body.position);
//        print(diffVector);
      
      obj.body.linearVelocity = new Vector(diffVector.x * Game.MOVE_VELOCITY, diffVector.y * Game.MOVE_VELOCITY);
      
      if (this.eventHandler.dragHandler.rotateLeft) {
        obj.body.angularVelocity = 1.0;
      } else if (this.eventHandler.dragHandler.rotateRight) {
        obj.body.angularVelocity = -1.0;
      } else {
        obj.body.angularVelocity = obj.body.angularVelocity / 1.05;
      }
      
      
//      }
      
//      obj.body.linearVelocity = new Vector(0, 10 * 60);
      
    }
    
    window.requestAnimationFrame((num time) {
      _step(time);
      _draw();
//      print('bodies: ${bodies.length}');
//      print('bodies[1]: [${bodies[1].linearVelocity.x}, ${bodies[1].linearVelocity.y}]');
    });
  }
  
  void _draw() {
    // Clear the animation panel and draw new frame.
//    ctx.fillStyle = "#fff";
//    ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    this.canvas.width = this.canvas.width;
    
    // draw debug rectangles
    if (Game.debug) {
      world.drawDebugData();
    }

    // draw grounds
    for (GameObject ground in this.grounds) {
      ground.draw(this.ctx);
    }
    
    // draw dynamic bodies
    for (GameObject object in this.dynamicObjects) {
      object.draw(this.ctx);
    }
    
    this.lightEngine.draw(this.dynamicObjects);
    
    this._drawDebugInfo();
    
    frameCount++;
  }
  
  void _drawDebugInfo() {
    this.ctx.fillStyle = '#ddd';
    this.ctx.font = '12px courier';
    this.ctx.textBaseline = 'bottom';
    this.ctx.fillText("fps: ${this.canvasFpsCounter}, physics step: ${this.canvasWorldStepTime} ms", 5, 20);
  }
  
  static Vector convertCanvasToWorld(Vector canvasVectorOrPoint) {
    return new Vector((canvasVectorOrPoint.x - Game.canvasCenter.x) / Game.VIEWPORT_SCALE,
                      (Game.canvasCenter.y - canvasVectorOrPoint.y) / Game.VIEWPORT_SCALE);
  }

  static void convertWorldToCanvas(Vector worldVectorOrPoint) {
    worldVectorOrPoint.x = worldVectorOrPoint.x * Game.VIEWPORT_SCALE + Game.canvasCenter.x;
    worldVectorOrPoint.y = -worldVectorOrPoint.y * Game.VIEWPORT_SCALE + Game.canvasCenter.y;
  }

  /**
   * Starts running the demo as an animation using an animation scheduler.
   */
  void run() {
    this.stopwatch.start();
    window.requestAnimationFrame((num time) { _step(time); });
  }
  
}

void main() {
  final game = new Game();
  game.init();
  game.run();
}
