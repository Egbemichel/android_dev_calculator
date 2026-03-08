/// Exercise 1: Animal Class Hierarchy
/// Demonstrates: Abstract classes, inheritance, polymorphism, property overriding

// ============================================================================
// ABSTRACT CLASS - Defines common behavior for all animals
// ============================================================================
abstract class Animal {
  final String name;

  Animal(this.name);

  // Abstract method - must be implemented by subclasses
  String makeSound();

  // Property that can be overridden
  int get legs;

  // Common method available to all animals
  void introduce() {
    print('$name says ${makeSound()}');
  }

  @override
  String toString() {
    return '$name (${runtimeType}) with $legs legs';
  }
}

// ============================================================================
// CONCRETE CLASSES - Implementing the abstract Animal class
// ============================================================================

/// Dog class - extends Animal
class Dog extends Animal {
  Dog(String name) : super(name);

  @override
  String makeSound() => 'Woof!';

  @override
  int get legs => 4;

  // Additional dog-specific behavior
  void fetch() {
    print('$name is fetching the ball!');
  }
}

/// Cat class - extends Animal
class Cat extends Animal {
  Cat(String name) : super(name);

  @override
  String makeSound() => 'Meow!';

  @override
  int get legs => 4;

  // Additional cat-specific behavior
  void purr() {
    print('$name is purring... 🐱');
  }
}

/// Bird class - extends Animal (bonus: different number of legs)
class Bird extends Animal {
  Bird(String name) : super(name);

  @override
  String makeSound() => 'Tweet!';

  @override
  int get legs => 2;

  void fly() {
    print('$name is flying! 🦅');
  }
}

// ============================================================================
// MAIN FUNCTION - Demonstrates polymorphism
// ============================================================================

void main() {
  print('\n' + '=' * 60);
  print('EXERCISE 1: Animal Class Hierarchy');
  print('=' * 60 + '\n');

  // Create a list of animals (polymorphism - different types in one list)
  final List<Animal> animals = [
    Dog('Buddy'),
    Cat('Whiskers'),
    Dog('Max'),
    Cat('Luna'),
    Bird('Tweety'),
  ];

  print('📋 Animals in the zoo:\n');

  // Iterate and print each sound (polymorphic behavior)
  for (var animal in animals) {
    animal.introduce();
  }

  print('\n' + '-' * 60);
  print('📊 Animal Details:\n');

  // Show polymorphism with toString()
  for (var animal in animals) {
    print(animal.toString());
  }

  print('\n' + '-' * 60);
  print('🎭 Type-specific behaviors:\n');

  // Demonstrate type checking and specific behaviors
  for (var animal in animals) {
    if (animal is Dog) {
      animal.fetch();
    } else if (animal is Cat) {
      animal.purr();
    } else if (animal is Bird) {
      animal.fly();
    }
  }

  print('\n' + '-' * 60);
  print('📈 Statistics:\n');

  // Count animals by type using polymorphism
  final dogCount = animals.whereType<Dog>().length;
  final catCount = animals.whereType<Cat>().length;
  final birdCount = animals.whereType<Bird>().length;

  print('Dogs: $dogCount');
  print('Cats: $catCount');
  print('Birds: $birdCount');
  print('Total Animals: ${animals.length}');

  // Calculate average legs
  final totalLegs = animals.fold<int>(0, (sum, animal) => sum + animal.legs);
  final avgLegs = totalLegs / animals.length;
  print('Average Legs: ${avgLegs.toStringAsFixed(1)}');

  print('\n' + '=' * 60 + '\n');
}

