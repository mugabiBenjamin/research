# PHP

## Starting a local web server

```php
Type the following in cmd
   php -S localhost:4000
   -
   php -S localhost:8000 -t public

Type the following in your browser
   http://localhost:4000/www.site.php

   www is the folder located on :C drive, site.php is the file
```

## Writing php code

```php
   http://localhost:4000/www/site.php

   echo  ("Hello World!");
        // or
   echo "Hello World!";

echo "<h1>Benjamin's site</h1>";\
echo "<hr>";
echo "<p>This is myparagraph</p>";
```

## Variables

```php
<?php
    $characterName = "Tom";
    $characterAge = 80;

    echo "There once was a man named $characterName <br>";
    echo "He was $characterAge years old <br>";

    $characterName = "Benja ";
        echo "He really liked the name $characterName <br>";
        echo "But didn't like being $characterAge <br>";
?>
```

## Data types

```php
    $phrase = "To be or not to be";   // string
    $age = 20; //integer
    $gpa = 4.95; //float
    $isMale = true; //boolean
    $isFemale = false; //boolean
    null; //null -> means has no value

    echo $phrase;
    echo "$phrase <br>";
    echo "$gpa <br>";
    echo "$isMale <br>";
    echo "$isFemale <br>";
    echo "<h1>" . $phrase . "</h1>";
```

## Working with strings

```php
    echo strtolower($phrase) . "<br>";
    echo strtoupper($phrase) . "<br>";
    echo strlen($phrase) . "<br>";
    echo $phrase[2] . "<br>";   // r

    echo "Benjamin"[2] . "<br>";    // n
    $phrase[0] = "B";
    echo $phrase. "<hr> <br>";   // Biraffe Academy

-----

    $phrase = "Giraffe Academy";

    echo str_replace("Giraffe", "Panda", $phrase) . "<br>";  // Panda Academy
    echo str_replace("raff", "000", $phrase) . "<br>";  // Gi000e Academy

    echo substr($phrase, 8);  // Academy
    echo substr($phrase, 8, 3);  // Aca
```

## Working with numbers

```php
    $num = 10;
    $num++;     // 11
    $num += 5;
    echo $num;  // 16

-----

    echo abs(-100) . "<br>"; // 100
    echo pow(2, 4) . "<br>"; // 16
    echo sqrt(144) . "<br>"; // 12
    echo max(2, 10) . "<br>"; // 10
    echo min(2, 10) . "<br>"; // 2
    echo round(3.142) . "<br>"; // 3
    echo ceil(3.142) . "<br>"; // 4
    echo floor(3.142); // 3
```

## Getting user input

```php
    <form action="site.php" method="get">
        Name: <input type="text" name="name">
        <br>
        Age: <input type="number" name="age">
        <br>
        <input type="submit" value="Send">
    </form>

    <br>

    <?php
    echo "Your name is " . $_GET["name"] . "<br>";
    echo "Your age is " . $_GET["age"];
    ?>
```

## Building a basic calculator

```php
http://localhost:3600/www/site.php?num1=10&num2=50

    <form action="site.php" method="get">
        <input type="number" name="num1">
        <br>
        <input type="number" name="num2">
        <br>
        <input type="submit" value="Calculate">
    </form>

    <br>

    <?php
    echo "Answer: " . $_GET["num1"] + $_GET["num2"];
    ?>
```

## Building a mad libs game

```php
http://localhost:3600/www/site.php?color=Cyan&plural_noun=Elephants&celebrity=Tom+Cruise

    <form action="site.php" method="get">
        Color: <input type="text" name="color">
        <br>
        Plural noun: <input type="text" name="plural_noun">
        <br>
        Celebrity: <input type="text" name="celebrity">
        <br>
        <input type="submit">
    </form>

    <br>

    <?php
    $color = $_GET["color"];
    $plural_noun = $_GET["plural_noun"];
    $celebrity = $_GET["celebrity"];

    echo "Roses are $color <br>";
    echo "$plural_noun are blue <br>";
    echo "I love $celebrity <br>";
    ?>
```

## URL parameters

```php
http://localhost:3600/www/site.php?name=Joseph&age=70
// added age through URL, no input for age in html code

<form action="site.php" method="get">
        Name: <input type="text" name="name">
        <br>
        <input type="submit">
    </form>

    <br>

    <?php
    echo $_GET["name"] . "<br>";
    echo $_GET["age"];  // 70
    ?>
```

## POST Vs GET

```php
get -> information shows up in the URL (not secure for password)
post -> gets more information from the user than get

    <form action="site.php" method="post">
        Password: <input type="password" name="password">
        <br>
        <input type="submit">
    </form>

    <br>

    <?php
    echo $_POST["password"] . "<br>";
    ?>
```

## Arrays

```php
<?php
    $friends = array("Kevin", "Karren", "Oscar", "Jim");

    echo $friends . "<br>"; // Array
    echo $friends[0] . "<br>";   // Kevin
    $friends[4] = "Angela";
    echo count($friends);   // 5
?>
```

## Using checkboxes

```php
    <form action="site.php" method="post">

        Apples: <input type="checkbox" name="fruits[]" value="apples">
        <br>
        Oranges: <input type="checkbox" name="fruits[]" value="oranges">
        <br>
        Pears: <input type="checkbox" name="fruits[]" value="pears">
        <br>
        <input type="submit">
    </form>

    <?php
        $fruits = $_POST["fruits"];
        echo $fruits[0] . "<br>";
    ?>
```

## Associative arrays

```php
    <?php
        $grades = array("Jim"=>"A+", "Pam"=>"B-", "Oscar"=>"C+");
        echo $grades["Jim"] . "<br>";    // A+
        echo $grades["Oscar"] . "<br>";    // C+
        $grades["Jim"] = "F";
        echo $grades["Jim"] . "<br>";    // F
        echo count($grades);    // 3
    ?>

-----

    <form action="site.php" method="post">
        Student: <input type="text" name="student">
        <br>
        <input type="submit">
    </form>

    <?php
    $grades = array("Jim" => "A+", "Pam" => "B-", "Oscar" => "C+");
    $student_grade = $_POST["student"];

    echo $grades[$student_grade];
    ?>
```

## Functions

```php
<?php
    function sayHi(){
        echo "Hello User";
    }

    sayHi();
?>

-----

<?php
    function sayHi($name, $age){
        echo "Hello $name, you are $age <br>";
    }

    sayHi("Benjamin", 40);
    sayHi("Benjn", 30);
?>
```

## Return statements

```php
<?php
    function cube($number){
        return $number * $number * $number;
        // return breaks us out of the function so whatever code is after the return will not be executed
    }

    $cube_result = cube(4);
    echo $cube_result;
?>
```

## If statements

```php
    $isMale = false;

    if ($isMale){
        echo "You're male";
    } else  {
        echo "You're not male";   // <---
    }

-----

    $isMale = true;
    $isTall = true;

    if ($isMale && $isTall){
        echo "You're a tall male";    // <---
    } else  {
        echo "You're a short male";
    }

-----

    $isMale = true;
    $isTall = false;

    if ($isMale || $isTall){
        echo "You're a tall male";    // <---
    } else  {
        echo "You're a short male";
    }

----

    $isMale = true;
    $isTall = true;

    if ($isMale && $isTall){
        echo "You're a tall male";    // <---
    } else if ($isMale && !$isTall) {
        echo "You're a short male";
    } else if (!$isMale && $isTall) {
        echo "You're not male but are tall";
    } else {
        echo "You're not male and not tall";
    }
```

## If statements with comparisons

```php
    function getMax($num1, $num2){
        if($num1 > $num2){
            return $num1;
        } else {
            return $num2;
        }
    }

    $greater = getMax(3, 90);   // 90
    $greater = getMax(300, 90);   // 300
    echo $greater;

-----

    function getMax($num1, $num2, $num3){
        if($num1 >= $num2 && $num1 >= $num3){
            return $num1;
        } else if($num2 >= $num1 && $num2 >= $num3) {
            return $num2;
        } else {
            return $num3;
        }
    }

    $greater = getMax(3, 90, 99);   // 99
    echo $greater;
```

## Building a better calculator

```php
    <form action="site.php" method="post">
        First Number: <input type="number" step="0.1" name="num1">
        <br>
        Operation: <input type="text" name="operator">
        <br>
        Second Number: <input type="number" name="num2">
        <br>
        <input type="submit">
    </form>

    <?php
    $num1 = $_POST["num1"] . "<br>";
    $num2 = $_POST["num2"] . "<br>";
    $operator = $_POST["operator"];

    if ($operator == "+") {
        echo $num1 + $num2;
    } elseif ($operator == "-") {
        echo $num1 - $num2;
    } elseif ($operator == "/") {
        echo $num1 / $num2;
    } elseif ($operator == "*") {
        echo $num1 * $num2;
    } else {
        echo "Invalid operator";
    }
    ?>
```

## Switch statements

```php
    <form action="site.php" method="post">

        What was your grade?
        <input type="text" name="grade">
        <br>
        <input type="submit">
    </form>

    <?php
    $grade = $_POST["grade"];

    switch($grade) {
        case "A":
            echo "You did amazing!";
            break;
        case "B":
            echo "You did pretty good!";
            break;
        case "C":
            echo "You did poorly!";
            break;
        case "D":
            echo "You did very bad!";
            break;
        case "F":
            echo "YOU FAILED!";
            break;
        default:
            echo "Invalid Grade";
    }
    ?>
```

## While loops

```php
<?php
    $index = 1;

    while($index <= 5){
        echo "$index <br>";
        $index++;
        // increment comes after the echo
    }
?>

-----

    <?php
    $index = 6;
    while($index <= 5){
        echo "$index <br>";
        $index++;
        // while loop checks the condition first then executes the  loop body
    }

    $index = 6;
    do {
        echo "$index <br>";
        $index++;
    } while($index <= 5)
    // do while loop executes the loop body first then checks the condition
    ?>
```

## For loops

```php
    for ($index = 1; $index <= 5; $index++) {
        echo "$index <br>";
    }

-----

    $luckyNumbers = array(4, 8, 14, 16, 23, 42);

    for ($i = 0; $i <= count($luckyNumbers); $i++) {
        echo "$luckyNumbers[$i] <br>";
    }
```

## Including HTML

```php
    <!--  include allows us to include inside of the php file -->

    <?php include "header.html" ?>
    <p>Hello World</p>
    <?php include "footer.html" ?>
```

## Include - PHP

```php
<!-- article-header.php file -->

<h2><?php echo $title; ?></h2>
<h4><?php echo $author; ?></h4>
Word count: <?php echo $word_count; ?>

<?php
    $title = "My first host";
    $author = "Benjamin";
    $word_count = 400;
    include "article-header.php"
?>

-----

<?php
// useful-tools.php file

$feetInMiles = 5280;
function sayHi($name){
    echo "Hello $name";
}
?>

<?php
    include "useful-tools.php";
    echo sayHi("Benny") . "<br>";
    echo $feetInMiles;
?>
```

## Classes and objects

```php
<?php
    class Book {
        var $title;
        var $author;
        var $pages;
    }

    $book1 = new Book;  // obect
    // An object is an instance of a class
    $book1->title = "Harry Potter";
    $book1->author = "JK Rowling";
    $book1->pages = 400;

    echo "$book1->title <br>";
    echo "$book1->author <br>";
    echo "$book1->pages <br>" . "<br>";

    $book2 = new Book;  // obect
    $book2->title = "Lord of the Rings";
    $book2->author = "Tolkien";
    $book2->pages = 700;

    echo "$book2->title <br>";
    echo "$book2->author <br>";
    echo "$book2->pages <br>";
?>
```

## Constructors

```php
<?php
    class Book {
        var $title;
        var $author;
        var $pages;

        function __construct($aTitle, $aAuthor, $aPages){
            $this->title = $aTitle;
            $this->author = $aAuthor;
            $this->pages = $aPages;
        }
    }

    $book1 = new Book("Harry Potter", "JK Rowling", 400);
    $book1->title = "Hunger Games";
    $book2 = new Book("Lord of the Rings", "Tolkien", 700);
    echo $book1->title; // Hunger Games
?>
```

## Object Functions

```php
<?php
    class Student {
        var $name;
        var $major;
        var $gpa;

        function __construct($name, $major, $gpa){
            $this->name = $name;
            $this->major = $major;
            $this->gpa = $gpa;
        }

        function hasHonors(){
            if($this->gpa >= 4.0){
                return "true";
            } else {
                return "false";
            }
        }
    }

    $student1 = new Student("Timothy", "Business", 2.8);
    $student2 = new Student("Jimmy", "Art", 4.6);

    echo $student1->hasHonors();
?>
```

## Getters and setters \*\*\*didn't run

```php
<?php
    class Movie {
        public $title;
        private $rating;

        // visibility modifier is a key word thet tells php what code is able to access and use different attributes in the program

        function __construct($title, $rating){
            $this->title = $title;
            // $this->rating = $rating;     // initially
            $this->setRating($rating);
        }

        function getRating(){
            return $this->rating;
        }

        function setRating($rating){
            // $this->rating = $rating; // initially

            if($rating == "G" || $rating == "PG" || $rating == "PG-13" || $rating == "R" || $rating == "NR"){
                $this->rating = $rating;
            } esle {
                $this->rating = "NR";
            }
        }
    }

    // G, PG, PG-13, R, NR
    $avengers = new Movie("Avengers", "PG-13");
        // $avengers->setRating("R");
    echo $avengers->getRating();
?>
```

## Inheritance

```php
<?php
    class Chef {
        function makeChicken() {
            echo "The chef makes chicken <br>";
        }
        function makeSalad() {
            echo "The chef makes salad <br>";
        }
        function makeSpecialDish() {
            echo "The chef makes bbq ribs <br>";
        }
    }

    class IntalianChef extends Chef {
        function makePasta() {
            echo "The chef makes pasta <br>";
        }
        function makeSpecialDish() {
            // overwritting makeSpecialDish() function
            echo "The chef makes lasgne <br>";
        }
    }

    $chef = new Chef();
    $chef->makeSpecialDish();

    $italianChef = new IntalianChef();
    $italianChef->makeSpecialDish();
    $italianChef->makePasta();
?>
```

## PHP OOP

### Creating Classes

```php
// newclass.inc.php in the includes folder (served)
<?php
    class NewClass {

        //  Properties and Methods go here
            public $info = "This is some info";
    }

    // Instanciating the class
    $object = new NewClass();
    var_dump($object);      // object(NewClass)#1 (1) { ["info"]=> string(17) "This is some info" }
```

### Visibility and Inheritance

```php
// person.inc.php
<?php
    class Person {
        private $first = "Daniel";
        private $last = "Nielsen";
        private $age = 28;
    }

    class Pet {
        public function owner() {
            $a = "Hi there!";
            return $a;
        }
    }

// index.php
    <?php
        require 'includes/person.inc.php';
        $pet01 = new Pet();
        echo $pet01->owner();
    ?>

-----

<?php
    class Person {
        private $first = "Daniel";
        private $last = "nielsen";
        private $age = 28;

        public function owner() {
            $a = $this->first;
            return $a;
        }
    }

-----

// person.inc.php
<?php
    class Person {
        protected $first = "Daniel";
        private $last = "Nielsen";
        private $age = 28;
    }

    class Pet extends Person {
        public function owner() {
            $a = $this->first;
            return $a;
        }
    }

// index.php
<?php
    require 'includes/person.inc.php';
    $pet01 = new Pet();
    echo $pet01->owner();
?>
```

### Properties and Methods

```php
// person.inc.php
<?php
    class Person {
        // Properties
        public $name;
        public $eyeColor;
        public $age;

        // Method
        public function setName($aName) {
            $this->name = $aName;
        }
    }

// index.php
<?php
    require 'includes/person.inc.php';

    $person1 = new Person();
    $person1->setName("Daniel");
    echo $person1->name . "<br>";

    $person2 = new Person();
    $person2->setName("Timmy");
    echo $person2->name;
?>
```

### Constructors and Destructors

```php
    // Destructors runs as soon as the class is done loading

// person.inc.php
<?php
    class Person {
        public $name;
        public $eyeColor;
        public $age;

    public function __construct($aName, $aEyeColor, $aAge) {
        $this->name = $aName;
        $this->eyeColor = $aEyeColor;
        $this->age = $aAge;
    }

        public function setName($aName) {
            $this->name = $aName;
        }
    }

// index.php
<?php
    require 'includes/person.inc.php';

    $person1 = new Person("Daniel", "Blue", 28);
    echo  $person1->name . "<br>";
    echo  $person1->eyeColor . "<br>";
    echo  $person1->age . "<br> <br>";

    $person1->setName("John");
    echo $person1->name         // John
?>

-----## Getters and setters

<?php
class Person {
    private $name;
    private $eyeColor;
    private $age;

    public function __construct($aName, $aEyeColor, $aAge) {
        $this->name = $aName;
        $this->eyeColor = $aEyeColor;
        $this->age = $aAge;
    }

    public function setName($aName) {
        $this->name = $aName;
    }

    public function getName() {
        return $this->name;
    }
}

// index.php
<?php
    require 'includes/person.inc.php';
    $person1 = new Person("Daniel", "Blue", 28);
    echo $person1->getName();        // John
?>
```

### Deleting objects in PHP

```php
<?php
    require 'includes/newclass.inc.php';

    $object = new NewClass();
    unset($object);     // destroy an object after it is created
    echo $object->getProperty();
?>
```

### Static properties and Methods

```php
// person.inc.php
<?php
class Person {
    private $name;
    private $eyeColor;
    private $age;

    public static $drinkingAge = 21;

    public function __construct($aName, $aEyeColor, $aAge) {
        $this->name = $aName;
        $this->eyeColor = $aEyeColor;
        $this->age = $aAge;
    }

    public function setName($aName) {
        $this->name = $aName;
    }

    public function getDA() {
        return self::$drinkingAge;
    }

    public static function setDrinkingAge($newDA) {
        self::$drinkingAge = $newDA;
    }
}

// index.php
<?php
    require 'includes/person.inc.php';

    // echo Person::$drinkingAge . "<br>";     //  21
    // Person::setDrinkingAge(18);
    // echo Person::$drinkingAge . "<br>";      // 18

    $person1 = new Person("Daniel", "Blue", 28);
    echo $person1->getDA();         // 21
?>
```

## Load classes automatically and namespace

```php
// autoloader.inc.php in the includes folder
<?php
spl_autoload_register('myAutoLoader');

function myAutoLoader($className) {
    $path = "classes/";
    $extension = ".class.php";
    $fullPath = $path . $className . $extension;

    if(!file_exists($fullPath)) {
        return false;
    }

    include_once $fullPath;
}

// person.class.php in class folder
<?php
class Person {
    private $name;
    private $eyeColor;
    private $age;

    public function __construct($aName, $aEyeColor, $aAge) {
        $this->name = $aName;
        $this->eyeColor = $aEyeColor;
        $this->age = $aAge;
    }

    public function setName($aName) {
        $this->name = $aName;
    }

    public function getName() {
        return $this->name;
    }
}

// index.php
<?php
    require 'includes/autoloader.inc.php';

    $person1 = new Person("Daniel", "Blue", 28);
    echo $person1->getName();        // Daniel
?>
```

## Type declarations

```php
// person.class.php
<?php
class Person {
    private $name;
    private $eyeColor;
    private $age;

    public function setName(string $aName) {
        $this->name = $aName;
    }

    public function getName() {
        return $this->name;
    }
}

// index.php
<?php
    declare(strict_types = 1);
?>
<?php
    require 'includes/autoloader.inc.php';

    $person1 = new Person();

    try {
        $person1->setName("Benny");
        echo $person1->getName();
    } catch (TypeError $e) {
            echo "Error!" . $e->getMessage();
    }
?>
```

## First exercise

```php
// class-autoload.inc.php
<?php
spl_autoload_register('myAutoLoader');

function myAutoLoader($className) {
    $url = $_SERVER['HTTP_HOST'].$_SERVER["REQUEST_URI"];

    if (strpos($url, 'includes') !== false) {
        $path = '../classes/';
    } else {
        $path = 'classes/';
    }
    $extension = '.class.php';
    $fullPath = $path . $className . $extension;

    require_once $fullPath;
}

// index.php
<?php
    declare(strict_types = 1);
    require 'includes/class-autoload.inc.php';
?>
<body>
    <form action="includes/calc.inc.php" method="post">
        <p>My own calculator</p>
        <input type="number" name="num1" placeholder="First Number">
        <select name="oper">
            <option value="add">Addition</option>
            <option value="sub">Subtraction</option>
            <option value="mul">Multiplication</option>
            <option value="div">Division</option>
        </select> <br>
        <input type="number" name="num2" placeholder="Second Number"> <br><br>
        <button type="Submit" name="submit">Calculate</button>
    </form>
</body>

// calc.inc.php
<?php
    declare(strict_types = 1);
    require 'class-autoload.inc.php';

    $oper = $_POST["oper"];
    $num1 = $_POST["num1"];
    $num2 = $_POST["num2"];

    $calc = new Calc($oper, (int)$num1, (int)$num2);

    try {
        echo $calc->calculator();
    } catch (TypeError $e) {
        echo "Error!: " . $e->getMessage();
    }
?>

// calc.class.php
<?php
class Calc {
    public $operator;
    public $num1;
    public $num2;

    public function __construct(string $sign, int $first_num, int $last_num) {
        $this->operator = $sign;
        $this->num1 = $first_num;
        $this->num2 = $last_num;
    }

    public function calculator() {
        switch ($this->operator) {
            case 'add':
                $result = $this->num1 + $this->num2;
                return $result;
                break;
            case 'sub':
                    $result = $this->num1 - $this->num2;
                    return $result;
                    break;
            case 'mul':
                    $result = $this->num1 * $this->num2;
                    return $result;
                    break;
            case 'div':
                    $result = $this->num1 / $this->num2;
                    return $result;
                    break;
            default:
                echo "Error!";
                break;
        }
    }
}
?>
```

## Scope resolution operator (::)

```php
// calc.inc.php
<?php
class FirstClass {
    const EXAMPLE = "You can't change this!";

    public static function test() {
        $testing = "This is a test!";
        return $testing;
        // echo self::EXAMPLE;
    }
}

$a = FirstClass::EXAMPLE;
echo "$a <br>";     // You can't change this!
echo $tes = FirstClass::test() . "<br>";    // This is a test!

class SecondClass extends FirstClass {
    public static $staticProperty = "A static property!";

    public static function anotherTest() {
        echo parent::EXAMPLE . "<br>";
        echo self::$staticProperty . "<br>";
    }
}

$b = SecondClass::anotherTest();    // You can't change this!       A static property!
echo $b;
```

## Interfaces **\*\*** needs improving

```php
<?php
// Interfaces
interface PaymentInterface {
    public function payNow();
}

interface LoginInterface {
    public function loginFirst();
}

// Classses
class Paypal implements PaymentInterface, LoginInterface {
    public function loginFirst() {}
    public function payNow() {}
    public function paymentProcess() {
        $this->loginFirst();
        $this->payNow();
    }
}

class BankTransfer implements PaymentInterface, LoginInterface {
    public function loginFirst() {}
    public function payNow() {}
    public function paymentProcess() {
        $this->loginFirst();
        $this->payNow();
    }
}

class Visa implements PaymentInterface {
    public function payNow() {}
    public function paymentProcess() {
        $this->payNow();
    }
}

class Cash implements PaymentInterface {
    public function payNow() {}
    public function paymentProcess() {
        $this->payNow();
    }
}

class BuyProduct {
    public function pay(PaymentInterface $paymentType) {
        $paymentType->paymentProcess();
    }
    public function onlinePay(LoginInterface $paymentType) {
        $paymentType->paymentProcess();
    }
}

$paymentType = new Cash();      // for instance, Cash
$paymentType = new BuyProduct();
$buyProduct->pay($paymentType);
```

## Abstract classes

```php
        Can only be referenced from other classes

// paymentTypes.abstract.php
<?php
    abstract class Visa {
        public function visaPayment() {
            return "Perform a payment";
        }

        abstract public function getPayment();
        // any class that inherits the Visa abstract class should have exactly getPayment() method in it by default
    }

// buyProduct.class.php
<?php
    class BuyProduct extends Visa{
        public function getPayment() {
            return $this->visaPayment();
        }
    }

// index.php
<?php
    include_once "abstract/paymentTypes.abtsract.php";
    include_once "classes/buyProduct.class.php";

    $buyProduct = new BuyProduct();
    echo $buyProduct->getPayment();
```

## Anonymous classes

```php
       // Less heavy to load, don't get stored in the memory of the website

// SimpleClass.class.php
<?php
    class SimpleClass {
        public function helloWorld() {
            echo "Hello World!";
        }
    }

// index.php
<?php
    // Regular class
    include_once "classes/simpleClass.class.php";

    $obj = new SimpleClass();
    $obj->helloWorld();

    // Anonymous class
    $newObj = new class() {
        public function helloWorld() {
            echo "Hello World!";
        }
    };

    $newObj->helloWorld();
```

## OOP Traits

```php
<?php
    // Solution to multiple inheritance

    trait notificationManager {
        public function getNotification() {
            return "Admin user process complete!";
        }
    }

    trait proceeController {
        public function getCurrentProcess() {
            return "Your current process is 001882";
        }

        public function getKillProcess() {
            return "Your process is 008882";
        }
    }

    class User {
        use notificationManager, proceeController;
    }

    $userObj = new User();
    echo $userObj->getKillProcess() . "<br>";
    echo $userObj->getNotification();

-----

<?php
    trait Speak {
        public function speaking() {
            echo "Hello I'm speaking";
        }
    }

    trait Eat {
        public function eating() {
            echo "Hello I'm eating";
        }
    }

    class Human {
        use Speak, Eat;
    }

    $human1 = new Human();
    echo $human1->speaking() . "<br>";
    echo $human1->eating();
```
