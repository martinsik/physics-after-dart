
//import 'package:box2d/box2d.dart';

part of droidtowers;

abstract class GameObject {
  
  static int static_counter = 0;
  int tag;
  
  BodyDef bodyDef;
  
  Shape shape;
  
  Body body;
  
  ImageElement texture;
  
  bool highlightEdges = false;
  
  void addObjectToWorld(World world);
  
  void draw(CanvasRenderingContext2D ctx);
 
  void setTexture(String imagePath) {
    this.texture = new Element.tag('img');
//    image.onLoad.listen((e) {
//      
////      _handleLoadedTexture(_texture, image);
//    });
    this.texture.src = imagePath;
  }
  
  
}

