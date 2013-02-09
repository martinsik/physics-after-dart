library droidtowers;

import 'dart:html';
import 'dart:math' as Math;
import 'package:box2d/box2d_browser.dart';

part 'GameObject.dart';
part 'StaticBox.dart';
part 'DynamicBox.dart';
part 'Color.dart';
part 'ClickedFixture.dart';


class Game {
  
  static const num GRAVITY = -50;
  static const num TIME_STEP = 1/60;
  static const int VELOCITY_ITERATIONS = 10;
  static const int POSITION_ITERATIONS = 10;
  static const int VIEWPORT_SCALE = 10;
  static const double DEGRE_TO_RADIAN = 0.0174532925;
  
  // All of the bodies in a simulation.
  List<GameObject> grounds;
  List<GameObject> dynamicObjects;
  
  // HTML element used to display the FPS counter
  Element fpsCounter;
  
  // HTML element used to display the world step time
  Element worldStepTimeCounter;

  // The debug drawing tool.
  DebugDraw debugDraw;

  // The physics world.
  World world;

  // The drawing canvas.
  CanvasElement canvas;

  // The canvas rendering context.
  CanvasRenderingContext2D ctx;

  // For timing the world.step call. It is kept running but reset and polled
  // every frame to minimize overhead.
  Stopwatch stopwatch;

  // Microseconds for world step update
  int elapsedUs;
  
  // Frame count for fps
  int frameCount;

  // The transform abstraction layer between the world and drawing canvas.
  IViewportTransform viewport;
  
  static Vector canvasCenter;

  
  void init() {
//    print(window.screen.width);
//    print(window.screen.height);
    
    this.stopwatch = new Stopwatch();
    this.grounds = new List<GameObject>();
    this.dynamicObjects = new List<GameObject>();
    
    fpsCounter = query("#fps-counter");
    worldStepTimeCounter = query("#step-time-counter");
    
    canvas = query("#main_canvas");
    ctx = canvas.getContext("2d");
    resizeCanvas();
    
    this._initListeners();
    
    Vector gravity = new Vector(0, GRAVITY);
    this.world = new World(gravity, true, new DefaultWorldPool());

    this._createGround();
    
    this._createBoxes();

    // Create the viewport transform with the center at extents.
    final extents = new Vector(this.canvas.width / 2, this.canvas.height / 2);
    viewport = new CanvasViewportTransform(extents, extents);
    viewport.scale = VIEWPORT_SCALE;
    
    // Create our canvas drawing tool to give to the world.
    debugDraw = new CanvasDraw(viewport, ctx);

    // Have the world draw itself for debugging purposes.
    world.debugDraw = debugDraw;
    frameCount = 0;
    
    window.setInterval(() {
      // print('bodies[1]: [${bodies[1].position.x}, ${bodies[1].position.y}]');
      fpsCounter.innerHtml = frameCount.toString();
      frameCount = 0;
    }, 1000);
    window.setInterval(() {
      worldStepTimeCounter.innerHtml = "${elapsedUs / 1000} ms";
    }, 200);

    
//    Body ground;
//    ground = world.createBody(bd);
    
  }
  
  void _initListeners() {
    window.onClick.listen((e) {
      for (GameObject o in dynamicObjects) {
        o.highlightEdges = false;
      }
      
//      print('point: [${e.clientX};${e.clientY}]');
//      print('point from center: [${e.clientX - Game.canvasCenter.x};${e.clientY - Game.canvasCenter.y}]');
      Vector pointClicked = new Vector((e.clientX - Game.canvasCenter.x) / Game.VIEWPORT_SCALE, (Game.canvasCenter.y - e.clientY) / Game.VIEWPORT_SCALE);
//      print(pointClicked);
      
      ClickedFixture callback = new ClickedFixture();
      callback.clickedPos = pointClicked;
//      Body body = new Body();
//      AxisAlignedBox aabb1 = new AxisAlignedBox(pointClicked, pointClicked);
//      for (GameObject b in dynamicObjects) {
//        AxisAlignedBox aabb2 = b.body.
//      }
//       
      AxisAlignedBox aabb = new AxisAlignedBox(pointClicked, pointClicked);
      world.queryAABB(callback, aabb);
      
    });
    
    window.onResize.listen((e) {
      resizeCanvas();
    });
  }
  
  void _createGround() {
    StaticBox ground = new StaticBox(new Vector(200.0, 1), new Vector(0.0, -22.0));
    ground.addObjectToWorld(this.world);
    this.grounds.add(ground);
  }
  
  void _createBoxes() {
    DynamicBox box;
    box = new DynamicBox(new Vector(3.0, 3.0), new Vector(0.0, 25.0), 0.1, 1.0);
    box.addObjectToWorld(this.world);
    box.setTexture('./images/crate2.jpg');
    this.dynamicObjects.add(box);
    
    box = new DynamicBox(new Vector(2.0, 2.0), new Vector(-10.0, 25.0), 0.1, 1.0, 44.0);
    box.addObjectToWorld(this.world);
    box.setTexture('./images/crate2.jpg');
    this.dynamicObjects.add(box);

    box = new DynamicBox(new Vector(3.0, 3.0), new Vector(10.0, 35.0), 0.1, 1.0, 30.0);
    box.addObjectToWorld(this.world);
    box.setTexture('./images/crate2.jpg');
    this.dynamicObjects.add(box);
    
    box = new DynamicBox(new Vector(5.0, 5.0), new Vector(0.0, 12.0), 0.1, 1.0, -10.0);
    box.addObjectToWorld(this.world);
    box.setTexture('./images/crate2.jpg');
    this.dynamicObjects.add(box);
    
    box = new DynamicBox(new Vector(3.0, 3.0), new Vector(-4.0, 35.0), 0.1, 1.0, 10.0);
    box.addObjectToWorld(this.world);
    box.setTexture('./images/crate2.jpg');
    this.dynamicObjects.add(box);

    box = new DynamicBox(new Vector(15.0, 3.0), new Vector(-4.0, 45.0), 0.1, 1.0, 10.0);
    box.addObjectToWorld(this.world);
    box.setTexture('./images/crate2.jpg');
    this.dynamicObjects.add(box);

  }
  

  void resizeCanvas() {
//    print('resize: [${window.innerWidth}, ${window.innerHeight}]');
    this.canvas.width = window.innerWidth;
    this.canvas.height = window.innerHeight;
    Game.canvasCenter = new Vector(this.canvas.width / 2, this.canvas.height / 2); 
  }
  
  /** Advances the world forward by timestep seconds. */
  void _step(num timestamp) {
    stopwatch.reset();
    world.step(TIME_STEP, VELOCITY_ITERATIONS, POSITION_ITERATIONS);
    elapsedUs = stopwatch.elapsedMicroseconds;

    // Clear the animation panel and draw new frame.
    ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    
    // draw debug rectangles 
//    world.drawDebugData();

    // draw grounds
    for (GameObject ground in this.grounds) {
      ground.draw(this.ctx);
    }
    
    // draw dynamic bodies
    for (GameObject object in this.dynamicObjects) {
      object.draw(this.ctx);
    }
    
    frameCount++;

    window.requestAnimationFrame((num time) {
      _step(time);
//      print('bodies: ${bodies.length}');
//      print('bodies[1]: [${bodies[1].linearVelocity.x}, ${bodies[1].linearVelocity.y}]');
    });
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
