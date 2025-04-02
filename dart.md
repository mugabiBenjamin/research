# Dart code

```dart
////////////////////////////////////// Running the file

    dart create my_project

    cd my_project

    dart run /bin/my_project.dart      // In the terminal

    -
    void main() {
    for (var i = 1; i <= 5; i++) {
        print('hello $i');
        }
    }




////////////////////////////////////// Receiving input from the user

    import 'dart:io';

    void main() {
    stdout.write('What\'s your name? \n');
    String? name = stdin.readLineSync();
    print('My name is $name');
    }




////////////////////////////////////// Data types

    int
    double
    String
    boolean
    dynamic
    null        // It is also an object

    void main() {
        dynamic weakVariable = 'hello';
        print('The weakVariable1 is $weakVariable');
        weakVariable = 3.14;
        print('The weakVariable2 is $weakVariable');
    }




////////////////////////////////////// Strings

    void main() {
        var s = r'Hello, \n World!';    // r is used to create a raw string
        print(s);
    }

    -
    void main() {
        var first = '''
        You can create
        multi-lined strings
        ''';

        var second = """
        You can create
        multi-lined strings
        """;

        print(first);
        print(second);
    }




////////////////////////////////////// Type conversion

------ String to integer

    void main() {
        var one = int.parse('1');
        assert(one == 1);     // assert is used to check if the value is true
        print(one);
    }

------ String to double

    void main() {
        var two = double.parse('2.7');
        assert(two == 2.7);
        print(two);
    }

------ Integer to string

    void main() {
        String oneAsString = 1.toString();
        assert(oneAsString == '1');
    }

------ Double to string
    
    void main() {
        String piAsString = 3.14159.toStringAsFixed(2);
        assert(piAsString == '3.14');
    }




////////////////////////////////////// Constants

void main () {
  const constNum = 1;
  const constBool = true;
  const constString = 'Hello';

  print(constNum.runtimeType);
  print(constBool.runtimeType);
  print(constString.runtimeType);
}




////////////////////////////////////// Loops

----- For loop

  void main () {
    var numbers = [1, 2, 3, 4, 5];
    for (var i = 0; i < numbers.length; i++) {
      print(numbers[i]);
    }

    for (var number in numbers) {
      print(number);
    }
  }

  -
  numbers.forEach((number) => print(number));

  -
  void main() {
  List<int> numbers = [1, 2, 3, 4, 5];

  numbers.where((number) => number % 2 == 0).forEach((number) => print(number));
  }

  -
  void main() {
    List<int> numbers = [1, 2, 3, 4, 5];

    for (var number in numbers.where((number) => number % 2 == 0)) {
      print(number); // 2, 4
    }
  }

----- While loop

void main () {
  var number = 1;

  while (number <= 10) {
    print(number);
    number++;
  }

    do {
    print(number);
    number++;
  } while (number <= 10);
}




////////////////////////////////////// Break & Continue

void main () {
  for (var i = 0; i <= 10; i++) {
    if (i > 5) break;
      print(i);
  }

  for (var i = 0; i <= 10; i++) {
    if (i % 2 == 0) continue;
      print('Odd number: $i');
  }
}




////////////////////////////////////// Collections

----- Lists

void main() {
  // List
  var names = const ['Seth', 'Kathy', 'Lars', 10, 56.5];
  // List names = ['Seth', 'Kathy', 'Lars'];
  // List <String> names = ['Seth', 'Kathy', 'Lars'];

  print(names[0]); // Seth
  print(names.runtimeType); // List<dynamic>
  print(names.length); // 3

  for (var name in names) {
    print(name);
  }
}

--

void main() {
  List<String> names = ['Seth', 'Kathy', 'Lars'];

  var names2 = [...names];    // Copy the list
  names[1] = 'Timothy';

  for (var name in names2) {
    print(name);
  }
}

----- Sets

void main() {
  // Set is a unique collection of items, no repeated items
  var halogens = {'Flourine',  'Chlorine', 'Bromine', 'Iodine', 'Astatine'};

  for (var halogen in halogens) {
    print(halogen);
  }

  /* 
    var cars = <String>{};  // Empty set
    Set<String> cars = {};  // Empty set

    var cars2 = {};  // Empty map
  */
}

----- Map

void main() {
  // Map is a collection of key-value pairs

  var gifts = {
    'first': 'patridge',
    'second': 'turtledoves',
    'thrid': 'golden rings'
  };

  print(gifts['first']); // patridge
}

--

void main() {
  // Map is a collection of key-value pairs

  var gifts = Map();

  gifts['first'] = 'patridge';
  gifts['second'] = 'turtledoves';
  gifts['fifth'] = 'golden rings';

  print(gifts['first']); // patridge
}




////////////////////////////////////// Functions

void main() {
  showMessage(square(2));     // 4
  showMessage(square(2.5));     // 6.25
}

dynamic square(var num) {
  return num * num;
}

void showMessage(var msg) {
  print(msg);
}

----- Arrow Functions

void main() {
  showMessage(square(2)); // 4
  showMessage(square(2.5)); // 6.25

  print(square.runtimeType);    // (dynamic) => dynamic
}

dynamic square(var num) => num * num;

void showMessage(var msg) {
  print(msg);
}

--

void main() {
  var list = ['apple', 'banana', 'cherry'];
  list.forEach((item) => print(item));
}

--

void main() {
  // Position parameters
  print(sum(2, 2));   // 4
}

dynamic sum(var num1, var num2) => num1 + num2;

---

void main() {
  // Named parameters
  print(sum(num2: 4, num1: 2));   // 6
}

dynamic sum({var num1, var num2}) => num1 + num2;

---

void main() {
  print(sum(10, num2: 2));   // 12
}

dynamic sum(var num1, {var num2}) => num1 + num2;

---

void main() {
  print(sum(10));   // 10
  print(sum(10, num2: 2));   // 12
}

dynamic sum(var num1, {var num2 = 0}) => num1 + num2;

---

void main() {
  print(sum(5, 5));   // 10
  print(sum(5));   // 5
}

dynamic sum(var num1, [var num2]) => num1 + (num2 ?? 0);




////////////////////////////////////// Classes

class Person {
  String name;
  int age;

  // Parameterized constructor
  Person(this.name, [this.age = 18]);


  // Default constructor
  //   Person(String name, [int age = 18]) {
  //   this.name = name;
  //   this.age = age;
  // }

  // Named constructor
  Person.guest() : name = 'Guest', age = 18;

  void showOutput() {
    print(name);
    print(age);
  }
}

void main() {
  Person person1 = Person('Max');
  person1.showOutput();

  var person2 = Person('Tom', 25);
  person2.showOutput();

  var person3 = Person.guest();
  person3.showOutput();
}




////////////////////////////////////// Inheritance

class Vehicle {
  String model;
  int year;

  Vehicle(this.model, this.year);

  void showOutput() {
    print(model);
    print(year);
  }
}

class Car extends Vehicle {
  double price;

  Car(String model, int year, this.price) : super(model, year);
  // Car(super.model, super.year, this.price);


  void showOutput() {
    super.showOutput();
    print(this.price);
  }
}

void main() {
  var car1 = Car('Accord', 2014, 25000);
  car1.showOutput();
}

---

void main() {
  var noodles = MenuList("Veg noodles", 9.99);
  var pizza = Pizza(["mushrooms", "peppers"], "Veg volcano", 15.99);

  // print(noodles.format() + '\n'); // Veg noodles --> 9.99
  // print(pizza.format());

  print(noodles);     // Veg noodles --> 9.99
  print(pizza);       // Instance of Pizza: Veg volcano, 15.99, [mushrooms, peppers] 
}

class MenuList {
  String title;
  double price;

  MenuList(this.title, this.price);

  String format() {
    return "$title --> $price";
  }

  @override
  String toString() {
    return format();
  }
}

class Pizza extends MenuList {
  List<String> toppings;

  Pizza(this.toppings, super.title, super.price);

  @override
  String format() {
    var formattedToppings = 'Contains:';

    for (final t in toppings) {
      formattedToppings = '$formattedToppings $t';
    }
    return '$title --> \$$price \n $formattedToppings';
  }

  @override
  String toString() {
    return 'Instance of Pizza: $title, $price, $toppings \n';
  }
}




////////////////////////////////////// Exception handling

int mustVreaterThanZero(int val) {
  if (val <= 0) {
    throw Exception('Value must be greater than zero');
  }
  return val;
}

void letVerifyTheVale(var val) {
  var valueVerification;

  try {
    valueVerification = mustVreaterThanZero(val);
  } catch (e) {
    print(e);
  }
  finally {
    if (valueVerification == null) {
      print('Value is not accepted');
    } else {
      print('Value verified: ${valueVerification}');
    }
  }
}

void main() {
  letVerifyTheVale(10);
  letVerifyTheVale(0);
}




////////////////////////////////////// Async, Await and Futures

void main() async {
  // Futures are like Promises in javaScript
  // can have uncompleted or completed state

  final post = await fetchPost();
  print(post.title);
  print(post.userID);
}

Future<Post> fetchPost() {
  const delay = Duration(seconds: 5);

  return Future.delayed(delay, () {
    return Post('My Post', 123);
  });
}

class Post {
  String title;
  int userID;

  Post(this.title, this.userID);
}




////////////////////////////////////// Fetching Data

dart pub add http

import 'dart:convert' as convert;  
import 'package:http/http.dart' as http;  

void main() async {  
  try {  
    final post = await fetchPost();  
    print(post.title);  
    print(post.userId);  
  } catch (e) {  
    print('Failed to fetch post: $e');  
  }  
}  

Future<Post> fetchPost() async {  
  var uri = Uri.https('jsonplaceholder.typicode.com', '/posts/2');  
  
  final response = await http.get(uri);  

  // Check if the response was successful  
  if (response.statusCode == 200) {  
    Map<String, dynamic> data = convert.jsonDecode(response.body);  
    return Post(data['title'], data['userId']);  
  } else {  
    throw Exception('Failed to load post');  
  }  
}  

class Post {  
  String title;  
  int userId;

  Post(this.title, this.userId);  
}

```
