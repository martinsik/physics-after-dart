part of physics_after_dart;

abstract class GameObject {
  static int static_counter = 0;
  int tag;

  BodyDef bodyDef;

  Shape shape;

  box2d.Body body;

  ImageElement texture;

  double width;
  double height;
  double origAngle = 0.0;

  bool hovered = false;

  void addObjectToWorld(World world);

  void draw(CanvasRenderingContext2D ctx);

  GameObject() {
    this.tag = static_counter++;
  }

  double getCurrentAngle() {
    return -this.body.getAngle() - this.origAngle;
  }

  void setTexture(String imagePath) {
    this.texture = new Element.tag('img');
//    image.onLoad.listen((e) {
//
////      _handleLoadedTexture(_texture, image);
//    });
    this.texture.src = imagePath;
  }
}
