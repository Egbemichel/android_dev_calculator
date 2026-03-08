/// Exercise 3: Interface Drawable
abstract class Drawable {
  void draw();
}
class Circle implements Drawable {
  final int radius;
  Circle(this.radius);
  @override
  void draw() {
    print('Circle (radius: \):');
    print('  ***  ');
    print(' ***** ');
    print('*******');
    print(' ***** ');
    print('  ***  ');
  }
}
class Square implements Drawable {
  final int sideLength;
  Square(this.sideLength);
  @override
  void draw() {
    print('Square (side: \):');
    print('**********');
    print('*        *');
    print('*        *');
    print('*        *');
    print('**********');
  }
}
void main() {
  print('\nEXERCISE 3: Interface - Drawable\n');
  final shapes = <Drawable>[Circle(3), Square(5)];
  shapes.forEach((s) => s.draw());
}
