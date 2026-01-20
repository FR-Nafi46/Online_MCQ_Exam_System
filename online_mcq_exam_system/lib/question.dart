import 'package:flutter/material.dart';

class Question {
  final int id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class QuestionBank {
  // ================= C PROGRAMMING - 3 SETS =================

  // C Programming Set 1: Basics
  static List<Question> cSet1 = [
    Question(
      id: 1,
      question: 'Who developed the C programming language?',
      options: [
        'Dennis Ritchie',
        'Bjarne Stroustrup',
        'James Gosling',
        'Guido van Rossum',
      ],
      correctAnswerIndex: 0,
      explanation: 'C was developed by Dennis Ritchie at Bell Labs in 1972.',
    ),
    Question(
      id: 2,
      question: 'Which of the following is not a valid C variable name?',
      options: [
        'int',
        '_int',
        'int1',
        'Int',
      ],
      correctAnswerIndex: 0,
      explanation: '"int" is a keyword in C and cannot be used as a variable name.',
    ),
    Question(
      id: 3,
      question: 'What is the size of "int" data type in C?',
      options: [
        '2 bytes',
        '4 bytes',
        'Depends on compiler',
        '8 bytes',
      ],
      correctAnswerIndex: 2,
      explanation: 'The size of int depends on the compiler and architecture.',
    ),
    Question(
      id: 4,
      question: 'What does the "printf()" function return?',
      options: [
        'Number of characters printed',
        '0 if successful',
        '1 if successful',
        'Pointer to the string',
      ],
      correctAnswerIndex: 0,
      explanation: 'printf() returns the number of characters printed.',
    ),
    Question(
      id: 5,
      question: 'Which operator is used to get the address of a variable?',
      options: [
        '*',
        '&',
        '#',
        '@',
      ],
      correctAnswerIndex: 1,
      explanation: 'The & operator is used to get the address of a variable.',
    ),
    Question(
      id: 6,
      question: 'What is the default return type of a function in C?',
      options: [
        'int',
        'void',
        'float',
        'char',
      ],
      correctAnswerIndex: 0,
      explanation: 'If no return type is specified, int is assumed.',
    ),
    Question(
      id: 7,
      question: 'Which header file is required for malloc() function?',
      options: [
        '<stdio.h>',
        '<stdlib.h>',
        '<conio.h>',
        '<malloc.h>',
      ],
      correctAnswerIndex: 1,
      explanation: 'malloc() is declared in <stdlib.h>.',
    ),
    Question(
      id: 8,
      question: 'What is the output of: printf("%d", 5 & 3);',
      options: [
        '7',
        '1',
        '0',
        '8',
      ],
      correctAnswerIndex: 1,
      explanation: '5 (101) & 3 (011) = 1 (001)',
    ),
    Question(
      id: 9,
      question: 'Which loop is guaranteed to execute at least once?',
      options: [
        'for',
        'while',
        'do-while',
        'All of the above',
      ],
      correctAnswerIndex: 2,
      explanation: 'do-while checks condition at the end, so it executes at least once.',
    ),
    Question(
      id: 10,
      question: 'What is a pointer in C?',
      options: [
        'A variable that stores address of another variable',
        'A function that points to another function',
        'A data type',
        'An array element',
      ],
      correctAnswerIndex: 0,
      explanation: 'Pointer stores memory address of another variable.',
    ),
  ];

  // C Programming Set 2: Intermediate
  static List<Question> cSet2 = [
    Question(
      id: 1,
      question: 'What is the purpose of "typedef" in C?',
      options: [
        'To define a new type',
        'To create a new variable',
        'To allocate memory',
        'To include header files',
      ],
      correctAnswerIndex: 0,
      explanation: 'typedef is used to create a new name for an existing type.',
    ),
    Question(
      id: 2,
      question: 'Which function is used to read a string in C?',
      options: [
        'scanf()',
        'gets()',
        'fgets()',
        'All of the above',
      ],
      correctAnswerIndex: 3,
      explanation: 'All these functions can be used to read strings.',
    ),
    Question(
      id: 3,
      question: 'What is the output of: printf("%d", sizeof("Hello"));',
      options: [
        '5',
        '6',
        '4',
        'Compiler error',
      ],
      correctAnswerIndex: 1,
      explanation: 'String length 5 + null terminator = 6 bytes.',
    ),
    Question(
      id: 4,
      question: 'Which storage class has the longest lifetime?',
      options: [
        'auto',
        'register',
        'static',
        'extern',
      ],
      correctAnswerIndex: 3,
      explanation: 'extern variables exist throughout the program execution.',
    ),
    Question(
      id: 5,
      question: 'What is a structure in C?',
      options: [
        'A collection of variables under one name',
        'A type of loop',
        'A function',
        'A pointer',
      ],
      correctAnswerIndex: 0,
      explanation: 'Structure groups different data types together.',
    ),
    Question(
      id: 6,
      question: 'Which operator has highest precedence in C?',
      options: [
        '+',
        '*',
        '()',
        '=',
      ],
      correctAnswerIndex: 2,
      explanation: 'Parentheses have the highest precedence.',
    ),
    Question(
      id: 7,
      question: 'What does "calloc()" function do?',
      options: [
        'Allocates memory and initializes to zero',
        'Allocates memory without initialization',
        'Frees memory',
        'Reallocates memory',
      ],
      correctAnswerIndex: 0,
      explanation: 'calloc() allocates memory and initializes it to zero.',
    ),
    Question(
      id: 8,
      question: 'What is the use of "break" statement?',
      options: [
        'To exit a loop',
        'To skip current iteration',
        'To continue next iteration',
        'To stop program',
      ],
      correctAnswerIndex: 0,
      explanation: 'break is used to exit from loops or switch statements.',
    ),
    Question(
      id: 9,
      question: 'Which is not a valid file opening mode in C?',
      options: [
        'r',
        'w',
        'a',
        'x',
      ],
      correctAnswerIndex: 3,
      explanation: '"x" is not a valid file mode in standard C.',
    ),
    Question(
      id: 10,
      question: 'What is recursion in C?',
      options: [
        'A function calling itself',
        'A loop structure',
        'A data structure',
        'A file operation',
      ],
      correctAnswerIndex: 0,
      explanation: 'Recursion is when a function calls itself.',
    ),
  ];

  // C Programming Set 3: Advanced
  static List<Question> cSet3 = [
    Question(
      id: 1,
      question: 'What is a dangling pointer?',
      options: [
        'Pointer pointing to deleted memory',
        'Uninitialized pointer',
        'NULL pointer',
        'Pointer to constant',
      ],
      correctAnswerIndex: 0,
      explanation: 'Dangling pointer points to memory that has been freed.',
    ),
    Question(
      id: 2,
      question: 'What is the use of "volatile" keyword?',
      options: [
        'To prevent compiler optimization',
        'To make variable constant',
        'To increase variable speed',
        'To allocate static memory',
      ],
      correctAnswerIndex: 0,
      explanation: 'volatile tells compiler variable may change unexpectedly.',
    ),
    Question(
      id: 3,
      question: 'What is function pointer in C?',
      options: [
        'Pointer that points to a function',
        'Pointer returned by function',
        'Pointer as function argument',
        'Pointer to array',
      ],
      correctAnswerIndex: 0,
      explanation: 'Function pointer stores address of a function.',
    ),
    Question(
      id: 4,
      question: 'Which is not a valid memory allocation function?',
      options: [
        'malloc()',
        'calloc()',
        'realloc()',
        'memalloc()',
      ],
      correctAnswerIndex: 3,
      explanation: 'memalloc() is not a standard C function.',
    ),
    Question(
      id: 5,
      question: 'What does "const" keyword do?',
      options: [
        'Makes variable read-only',
        'Allocates constant memory',
        'Defines constant function',
        'Creates constant pointer',
      ],
      correctAnswerIndex: 0,
      explanation: 'const makes variable value unchangeable.',
    ),
    Question(
      id: 6,
      question: 'What is union in C?',
      options: [
        'Shares memory among members',
        'Collection of different data types',
        'Similar to structure',
        'All of the above',
      ],
      correctAnswerIndex: 3,
      explanation: 'Union shares memory, can hold different types, similar to structure.',
    ),
    Question(
      id: 7,
      question: 'What is command line argument in C?',
      options: [
        'Arguments passed to main()',
        'Compiler arguments',
        'Function arguments',
        'Loop arguments',
      ],
      correctAnswerIndex: 0,
      explanation: 'Command line arguments are passed to main() function.',
    ),
    Question(
      id: 8,
      question: 'Which function converts string to integer?',
      options: [
        'atoi()',
        'itoa()',
        'strcat()',
        'strcmp()',
      ],
      correctAnswerIndex: 0,
      explanation: 'atoi() converts ASCII string to integer.',
    ),
    Question(
      id: 9,
      question: 'What is bit field in C?',
      options: [
        'Structure member with specified width',
        'Array of bits',
        'Binary field',
        'Memory field',
      ],
      correctAnswerIndex: 0,
      explanation: 'Bit field allows packing data in structure using specified bits.',
    ),
    Question(
      id: 10,
      question: 'What is the use of "enum" in C?',
      options: [
        'Define set of named constants',
        'Create enumeration loop',
        'Define structure',
        'Create array',
      ],
      correctAnswerIndex: 0,
      explanation: 'enum defines a set of named integer constants.',
    ),
  ];

  // ================= C++ PROGRAMMING - 2 SETS =================

  // C++ Set 1: OOP Basics
  static List<Question> cppSet1 = [
    Question(
      id: 1,
      question: 'Who developed C++?',
      options: [
        'Bjarne Stroustrup',
        'Dennis Ritchie',
        'James Gosling',
        'Guido van Rossum',
      ],
      correctAnswerIndex: 0,
      explanation: 'C++ was developed by Bjarne Stroustrup.',
    ),
    Question(
      id: 2,
      question: 'What is the extension of C++ source file?',
      options: [
        '.cpp',
        '.c',
        '.java',
        '.py',
      ],
      correctAnswerIndex: 0,
      explanation: 'C++ source files typically have .cpp extension.',
    ),
    Question(
      id: 3,
      question: 'Which concept is not supported by C?',
      options: [
        'Object Oriented Programming',
        'Structures',
        'Pointers',
        'Functions',
      ],
      correctAnswerIndex: 0,
      explanation: 'C does not support OOP concepts like classes and objects.',
    ),
    Question(
      id: 4,
      question: 'What is encapsulation?',
      options: [
        'Binding data and functions together',
        'Hiding implementation details',
        'Inheriting properties',
        'Multiple forms',
      ],
      correctAnswerIndex: 0,
      explanation: 'Encapsulation binds data and functions that manipulate them.',
    ),
    Question(
      id: 5,
      question: 'Which is an access specifier in C++?',
      options: [
        'private',
        'protected',
        'public',
        'All of the above',
      ],
      correctAnswerIndex: 3,
      explanation: 'C++ has three access specifiers: private, protected, and public.',
    ),
    Question(
      id: 6,
      question: 'What is a constructor?',
      options: [
        'Special function called when object is created',
        'Function that destroys object',
        'Normal class function',
        'Static function',
      ],
      correctAnswerIndex: 0,
      explanation: 'Constructor initializes object when it is created.',
    ),
    Question(
      id: 7,
      question: 'What is function overloading?',
      options: [
        'Multiple functions with same name but different parameters',
        'Single function with multiple names',
        'Function that calls itself',
        'Virtual function',
      ],
      correctAnswerIndex: 0,
      explanation: 'Function overloading allows same function name with different parameters.',
    ),
    Question(
      id: 8,
      question: 'Which operator is used for dynamic memory allocation in C++?',
      options: [
        'new',
        'malloc',
        'alloc',
        'create',
      ],
      correctAnswerIndex: 0,
      explanation: '"new" operator is used for dynamic memory allocation in C++.',
    ),
    Question(
      id: 9,
      question: 'What is inheritance?',
      options: [
        'Deriving new class from existing class',
        'Creating multiple objects',
        'Hiding data',
        'Function overloading',
      ],
      correctAnswerIndex: 0,
      explanation: 'Inheritance allows creating new class from existing class.',
    ),
    Question(
      id: 10,
      question: 'What is polymorphism?',
      options: [
        'Ability to take multiple forms',
        'Data hiding',
        'Memory management',
        'Exception handling',
      ],
      correctAnswerIndex: 0,
      explanation: 'Polymorphism allows objects to be treated as instances of parent class.',
    ),
  ];

  // C++ Set 2: Advanced Features
  static List<Question> cppSet2 = [
    Question(
      id: 1,
      question: 'What is a virtual function?',
      options: [
        'Function that can be overridden in derived class',
        'Function that cannot be overridden',
        'Static function',
        'Inline function',
      ],
      correctAnswerIndex: 0,
      explanation: 'Virtual functions enable runtime polymorphism.',
    ),
    Question(
      id: 2,
      question: 'What is template in C++?',
      options: [
        'Blueprint for creating generic functions/classes',
        'Predefined class',
        'Header file',
        'Compiler directive',
      ],
      correctAnswerIndex: 0,
      explanation: 'Templates allow writing generic code.',
    ),
    Question(
      id: 3,
      question: 'What is namespace in C++?',
      options: [
        'Container for identifiers',
        'Memory space',
        'File system',
        'Database',
      ],
      correctAnswerIndex: 0,
      explanation: 'Namespace prevents naming conflicts.',
    ),
    Question(
      id: 4,
      question: 'Which is not a type of constructor?',
      options: [
        'Default',
        'Parameterized',
        'Copy',
        'Virtual',
      ],
      correctAnswerIndex: 3,
      explanation: 'Virtual is not a type of constructor.',
    ),
    Question(
      id: 5,
      question: 'What is exception handling in C++?',
      options: [
        'Dealing with runtime errors',
        'Compile time errors',
        'Logical errors',
        'Syntax errors',
      ],
      correctAnswerIndex: 0,
      explanation: 'Exception handling deals with runtime anomalies.',
    ),
    Question(
      id: 6,
      question: 'What is STL in C++?',
      options: [
        'Standard Template Library',
        'System Template Library',
        'Standard Type Library',
        'System Type Library',
      ],
      correctAnswerIndex: 0,
      explanation: 'STL stands for Standard Template Library.',
    ),
    Question(
      id: 7,
      question: 'What is "this" pointer?',
      options: [
        'Pointer to current object',
        'Pointer to parent object',
        'Pointer to child object',
        'Null pointer',
      ],
      correctAnswerIndex: 0,
      explanation: '"this" pointer points to current object instance.',
    ),
    Question(
      id: 8,
      question: 'What is friend function?',
      options: [
        'Function that can access private members',
        'Function that cannot access any members',
        'Static function',
        'Inline function',
      ],
      correctAnswerIndex: 0,
      explanation: 'Friend function can access private and protected members.',
    ),
    Question(
      id: 9,
      question: 'What is operator overloading?',
      options: [
        'Giving new meaning to existing operator',
        'Creating new operator',
        'Deleting operator',
        'Changing operator precedence',
      ],
      correctAnswerIndex: 0,
      explanation: 'Operator overloading allows operators to work with user-defined types.',
    ),
    Question(
      id: 10,
      question: 'What is destructor?',
      options: [
        'Cleans up object before destruction',
        'Creates object',
        'Copies object',
        'Compares object',
      ],
      correctAnswerIndex: 0,
      explanation: 'Destructor is called when object is destroyed.',
    ),
  ];

  // ================= PYTHON PROGRAMMING - 2 SETS =================

  // Python Set 1: Basics
  static List<Question> pythonSet1 = [
    Question(
      id: 1,
      question: 'Who created Python?',
      options: [
        'Guido van Rossum',
        'James Gosling',
        'Dennis Ritchie',
        'Bjarne Stroustrup',
      ],
      correctAnswerIndex: 0,
      explanation: 'Python was created by Guido van Rossum.',
    ),
    Question(
      id: 2,
      question: 'Which type of language is Python?',
      options: [
        'Interpreted',
        'Compiled',
        'Assembly',
        'Machine',
      ],
      correctAnswerIndex: 0,
      explanation: 'Python is an interpreted language.',
    ),
    Question(
      id: 3,
      question: 'What is the correct extension for Python files?',
      options: [
        '.py',
        '.python',
        '.pt',
        '.pyt',
      ],
      correctAnswerIndex: 0,
      explanation: 'Python files have .py extension.',
    ),
    Question(
      id: 4,
      question: 'Which of these is mutable in Python?',
      options: [
        'List',
        'Tuple',
        'String',
        'Number',
      ],
      correctAnswerIndex: 0,
      explanation: 'Lists are mutable in Python.',
    ),
    Question(
      id: 5,
      question: 'What does PEP stand for?',
      options: [
        'Python Enhancement Proposal',
        'Python Extension Protocol',
        'Python Execution Process',
        'Python Environment Program',
      ],
      correctAnswerIndex: 0,
      explanation: 'PEP stands for Python Enhancement Proposal.',
    ),
    Question(
      id: 6,
      question: 'Which is used for single line comment?',
      options: [
        '#',
        '//',
        '/* */',
        '<!-- -->',
      ],
      correctAnswerIndex: 0,
      explanation: 'Hash (#) is used for single line comments in Python.',
    ),
    Question(
      id: 7,
      question: 'What is list comprehension?',
      options: [
        'Concise way to create lists',
        'Method to sort lists',
        'Way to delete lists',
        'Type of loop',
      ],
      correctAnswerIndex: 0,
      explanation: 'List comprehension provides concise way to create lists.',
    ),
    Question(
      id: 8,
      question: 'Which is not a Python data type?',
      options: [
        'array',
        'list',
        'tuple',
        'dictionary',
      ],
      correctAnswerIndex: 0,
      explanation: 'array is not a built-in Python data type.',
    ),
    Question(
      id: 9,
      question: 'What is lambda function?',
      options: [
        'Anonymous function',
        'Named function',
        'Main function',
        'Built-in function',
      ],
      correctAnswerIndex: 0,
      explanation: 'Lambda functions are anonymous functions.',
    ),
    Question(
      id: 10,
      question: 'What does "self" refer to?',
      options: [
        'Instance of the class',
        'Class itself',
        'Parent class',
        'Child class',
      ],
      correctAnswerIndex: 0,
      explanation: 'self refers to the instance of the class.',
    ),
  ];

  // Python Set 2: Advanced
  static List<Question> pythonSet2 = [
    Question(
      id: 1,
      question: 'What is Django?',
      options: [
        'Python web framework',
        'Python library',
        'Python IDE',
        'Python compiler',
      ],
      correctAnswerIndex: 0,
      explanation: 'Django is a Python web framework.',
    ),
    Question(
      id: 2,
      question: 'What is NumPy used for?',
      options: [
        'Numerical computing',
        'Web development',
        'GUI development',
        'Game development',
      ],
      correctAnswerIndex: 0,
      explanation: 'NumPy is used for numerical computing.',
    ),
    Question(
      id: 3,
      question: 'Which is used for unit testing?',
      options: [
        'unittest',
        'testunit',
        'pytest',
        'Both A and C',
      ],
      correctAnswerIndex: 3,
      explanation: 'Both unittest and pytest are used for testing.',
    ),
    Question(
      id: 4,
      question: 'What is decorator in Python?',
      options: [
        'Function that modifies another function',
        'Type of loop',
        'Data structure',
        'Exception handler',
      ],
      correctAnswerIndex: 0,
      explanation: 'Decorators modify functions or classes.',
    ),
    Question(
      id: 5,
      question: 'What is generator in Python?',
      options: [
        'Function that yields values',
        'Function that returns values',
        'Class generator',
        'Loop generator',
      ],
      correctAnswerIndex: 0,
      explanation: 'Generators yield values one at a time.',
    ),
    Question(
      id: 6,
      question: 'What is pickling?',
      options: [
        'Object serialization',
        'Object deletion',
        'Object creation',
        'Object modification',
      ],
      correctAnswerIndex: 0,
      explanation: 'Pickling converts Python objects to byte stream.',
    ),
    Question(
      id: 7,
      question: 'What is virtual environment?',
      options: [
        'Isolated Python environment',
        'Virtual machine',
        'Cloud environment',
        'Docker container',
      ],
      correctAnswerIndex: 0,
      explanation: 'Virtual environment isolates Python packages.',
    ),
    Question(
      id: 8,
      question: 'What is Flask?',
      options: [
        'Micro web framework',
        'Full-stack framework',
        'Database',
        'Testing framework',
      ],
      correctAnswerIndex: 0,
      explanation: 'Flask is a micro web framework for Python.',
    ),
    Question(
      id: 9,
      question: 'What is PyPI?',
      options: [
        'Python Package Index',
        'Python Program Interface',
        'Python Programming Interface',
        'Python Package Installer',
      ],
      correctAnswerIndex: 0,
      explanation: 'PyPI is Python Package Index repository.',
    ),
    Question(
      id: 10,
      question: 'What is async/await?',
      options: [
        'Asynchronous programming',
        'Synchronous programming',
        'Parallel programming',
        'Thread programming',
      ],
      correctAnswerIndex: 0,
      explanation: 'async/await is for asynchronous programming.',
    ),
  ];

  // ================= DART PROGRAMMING - 4 SETS =================

  // Dart Set 1: Basics
  static List<Question> dartSet1 = [
    Question(
      id: 1,
      question: 'Who developed Dart?',
      options: [
        'Google',
        'Microsoft',
        'Facebook',
        'Apple',
      ],
      correctAnswerIndex: 0,
      explanation: 'Dart was developed by Google.',
    ),
    Question(
      id: 2,
      question: 'What is Dart primarily used for?',
      options: [
        'Flutter development',
        'Web development',
        'Server development',
        'All of the above',
      ],
      correctAnswerIndex: 3,
      explanation: 'Dart is used for Flutter, web, and server development.',
    ),
    Question(
      id: 3,
      question: 'What type of language is Dart?',
      options: [
        'Object-oriented',
        'Functional',
        'Procedural',
        'All of the above',
      ],
      correctAnswerIndex: 3,
      explanation: 'Dart supports multiple programming paradigms.',
    ),
    Question(
      id: 4,
      question: 'How to declare a variable in Dart?',
      options: [
        'var',
        'dynamic',
        'final',
        'All of the above',
      ],
      correctAnswerIndex: 3,
      explanation: 'Dart supports var, dynamic, final, and const.',
    ),
    Question(
      id: 5,
      question: 'What is the entry point of Dart program?',
      options: [
        'main()',
        'run()',
        'start()',
        'init()',
      ],
      correctAnswerIndex: 0,
      explanation: 'main() is the entry point in Dart.',
    ),
    Question(
      id: 6,
      question: 'What does "?" after type indicate?',
      options: [
        'Nullable type',
        'Required parameter',
        'Optional parameter',
        'Constant value',
      ],
      correctAnswerIndex: 0,
      explanation: '? indicates nullable type in Dart.',
    ),
    Question(
      id: 7,
      question: 'What is async in Dart?',
      options: [
        'Asynchronous operation',
        'Synchronous operation',
        'Parallel operation',
        'Thread operation',
      ],
      correctAnswerIndex: 0,
      explanation: 'async indicates asynchronous function.',
    ),
    Question(
      id: 8,
      question: 'What is "await" used for?',
      options: [
        'Wait for async operation',
        'Stop execution',
        'Pause program',
        'End function',
      ],
      correctAnswerIndex: 0,
      explanation: 'await waits for async operation to complete.',
    ),
    Question(
      id: 9,
      question: 'What is Stream in Dart?',
      options: [
        'Sequence of asynchronous events',
        'File stream',
        'Network stream',
        'Data stream',
      ],
      correctAnswerIndex: 0,
      explanation: 'Stream provides sequence of asynchronous events.',
    ),
    Question(
      id: 10,
      question: 'What is Future in Dart?',
      options: [
        'Potential value or error',
        'Current value',
        'Past value',
        'Constant value',
      ],
      correctAnswerIndex: 0,
      explanation: 'Future represents potential value or error.',
    ),
  ];

  // Dart Set 2: Intermediate
  static List<Question> dartSet2 = [
    Question(
      id: 1,
      question: 'What is mixin in Dart?',
      options: [
        'Reusable class',
        'Interface',
        'Abstract class',
        'Final class',
      ],
      correctAnswerIndex: 0,
      explanation: 'Mixin allows code reuse across class hierarchies.',
    ),
    Question(
      id: 2,
      question: 'What is extension method?',
      options: [
        'Add method to existing class',
        'Extend class',
        'Modify class',
        'Delete method',
      ],
      correctAnswerIndex: 0,
      explanation: 'Extension methods add functionality to existing classes.',
    ),
    Question(
      id: 3,
      question: 'What is "cascade operator"?',
      options: [
        '..',
        '...',
        '::',
        '->',
      ],
      correctAnswerIndex: 0,
      explanation: '.. is cascade operator for sequential operations.',
    ),
    Question(
      id: 4,
      question: 'What is "factory" constructor?',
      options: [
        'Returns instance of class',
        'Creates factory',
        'Builds objects',
        'Destroys objects',
      ],
      correctAnswerIndex: 0,
      explanation: 'factory constructor returns instance of class.',
    ),
    Question(
      id: 5,
      question: 'What is "late" keyword?',
      options: [
        'Initialize variable later',
        'Delay execution',
        'Slow operation',
        'Late binding',
      ],
      correctAnswerIndex: 0,
      explanation: 'late allows non-nullable variable initialization later.',
    ),
    Question(
      id: 6,
      question: 'What is "const" constructor?',
      options: [
        'Creates compile-time constant',
        'Constant value',
        'Constructor parameter',
        'Static constructor',
      ],
      correctAnswerIndex: 0,
      explanation: 'const constructor creates compile-time constants.',
    ),
    Question(
      id: 7,
      question: 'What is "typedef"?',
      options: [
        'Function type alias',
        'Type definition',
        'Type declaration',
        'Type conversion',
      ],
      correctAnswerIndex: 0,
      explanation: 'typedef creates alias for function types.',
    ),
    Question(
      id: 8,
      question: 'What is "isolate" in Dart?',
      options: [
        'Independent worker thread',
        'Isolated variable',
        'Separate class',
        'Independent function',
      ],
      correctAnswerIndex: 0,
      explanation: 'Isolate is independent worker with own memory.',
    ),
    Question(
      id: 9,
      question: 'What is "generator" in Dart?',
      options: [
        'sync*/async* functions',
        'Class generator',
        'Code generator',
        'Test generator',
      ],
      correctAnswerIndex: 0,
      explanation: 'Generators use sync*/async* to yield values.',
    ),
    Question(
      id: 10,
      question: 'What is "zone" in Dart?',
      options: [
        'Execution context',
        'Memory zone',
        'Network zone',
        'File zone',
      ],
      correctAnswerIndex: 0,
      explanation: 'Zone is execution context for handling async operations.',
    ),
  ];

  // Dart Set 3: Flutter Basics
  static List<Question> flutterSet1 = [
    Question(
      id: 1,
      question: 'What is Flutter?',
      options: [
        'UI toolkit by Google',
        'Programming language',
        'Database',
        'Operating system',
      ],
      correctAnswerIndex: 0,
      explanation: 'Flutter is Google\'s UI toolkit for natively compiled apps.',
    ),
    Question(
      id: 2,
      question: 'What language does Flutter use?',
      options: [
        'Dart',
        'JavaScript',
        'Python',
        'Java',
      ],
      correctAnswerIndex: 0,
      explanation: 'Flutter uses Dart programming language.',
    ),
    Question(
      id: 3,
      question: 'What is widget in Flutter?',
      options: [
        'Building block of UI',
        'Database table',
        'Network request',
        'File handler',
      ],
      correctAnswerIndex: 0,
      explanation: 'Everything in Flutter is a widget.',
    ),
    Question(
      id: 4,
      question: 'What is StatefulWidget?',
      options: [
        'Widget with mutable state',
        'Widget without state',
        'Static widget',
        'Constant widget',
      ],
      correctAnswerIndex: 0,
      explanation: 'StatefulWidget has mutable state.',
    ),
    Question(
      id: 5,
      question: 'What is StatelessWidget?',
      options: [
        'Widget without mutable state',
        'Widget with state',
        'Dynamic widget',
        'Interactive widget',
      ],
      correctAnswerIndex: 0,
      explanation: 'StatelessWidget has immutable state.',
    ),
    Question(
      id: 6,
      question: 'What is BuildContext?',
      options: [
        'Location in widget tree',
        'Build process',
        'Context menu',
        'Build file',
      ],
      correctAnswerIndex: 0,
      explanation: 'BuildContext is location of widget in tree.',
    ),
    Question(
      id: 7,
      question: 'What is MaterialApp?',
      options: [
        'Root widget for Material Design',
        'Material design system',
        'App material',
        'Design system',
      ],
      correctAnswerIndex: 0,
      explanation: 'MaterialApp implements Material Design.',
    ),
    Question(
      id: 8,
      question: 'What is Scaffold?',
      options: [
        'Basic visual layout structure',
        'Building framework',
        'Design pattern',
        'Layout template',
      ],
      correctAnswerIndex: 0,
      explanation: 'Scaffold provides basic Material Design layout.',
    ),
    Question(
      id: 9,
      question: 'What is setState()?',
      options: [
        'Update widget state',
        'Set static state',
        'Create state',
        'Delete state',
      ],
      correctAnswerIndex: 0,
      explanation: 'setState() notifies framework to rebuild widget.',
    ),
    Question(
      id: 10,
      question: 'What is Hot Reload?',
      options: [
        'Quickly see code changes',
        'Restart app',
        'Reload data',
        'Refresh screen',
      ],
      correctAnswerIndex: 0,
      explanation: 'Hot Reload instantly shows code changes.',
    ),
  ];

  // Dart Set 4: Flutter Advanced
  static List<Question> flutterSet2 = [
    Question(
      id: 1,
      question: 'What is Provider?',
      options: [
        'State management solution',
        'Data provider',
        'Network provider',
        'File provider',
      ],
      correctAnswerIndex: 0,
      explanation: 'Provider is a state management package.',
    ),
    Question(
      id: 2,
      question: 'What is BLoC pattern?',
      options: [
        'Business Logic Component',
        'Basic Logic Control',
        'Binary Logic Component',
        'Business Layer Control',
      ],
      correctAnswerIndex: 0,
      explanation: 'BLoC separates business logic from UI.',
    ),
    Question(
      id: 3,
      question: 'What is Navigator?',
      options: [
        'Manages app screens/routes',
        'Navigation bar',
        'Map navigation',
        'Route planner',
      ],
      correctAnswerIndex: 0,
      explanation: 'Navigator manages stack of routes.',
    ),
    Question(
      id: 4,
      question: 'What is pubspec.yaml?',
      options: [
        'Project configuration file',
        'Publication file',
        'Specification file',
        'Package file',
      ],
      correctAnswerIndex: 0,
      explanation: 'pubspec.yaml defines project dependencies.',
    ),
    Question(
      id: 5,
      question: 'What is FutureBuilder?',
      options: [
        'Widget for async operations',
        'Future creator',
        'Builder pattern',
        'Future handler',
      ],
      correctAnswerIndex: 0,
      explanation: 'FutureBuilder builds widget based on Future.',
    ),
    Question(
      id: 6,
      question: 'What is StreamBuilder?',
      options: [
        'Widget for streams',
        'Stream creator',
        'Builder for streams',
        'Stream handler',
      ],
      correctAnswerIndex: 0,
      explanation: 'StreamBuilder builds widget based on Stream.',
    ),
    Question(
      id: 7,
      question: 'What is InheritedWidget?',
      options: [
        'Efficiently propagate info down tree',
        'Inherit properties',
        'Parent widget',
        'Base widget',
      ],
      correctAnswerIndex: 0,
      explanation: 'InheritedWidget efficiently passes data down.',
    ),
    Question(
      id: 8,
      question: 'What is Key in Flutter?',
      options: [
        'Preserves state across rebuilds',
        'Keyboard key',
        'Unique identifier',
        'Both A and C',
      ],
      correctAnswerIndex: 3,
      explanation: 'Key preserves state and uniquely identifies widgets.',
    ),
    Question(
      id: 9,
      question: 'What is AnimationController?',
      options: [
        'Controls animation',
        'Creates animation',
        'Stops animation',
        'Deletes animation',
      ],
      correctAnswerIndex: 0,
      explanation: 'AnimationController controls animation playback.',
    ),
    Question(
      id: 10,
      question: 'What is Platform Channel?',
      options: [
        'Communication with native code',
        'Network channel',
        'Data channel',
        'File channel',
      ],
      correctAnswerIndex: 0,
      explanation: 'Platform Channel communicates with platform-specific code.',
    ),
  ];

  // ================= GENERAL KNOWLEDGE - 1 SET =================

  // Bangladesh & Programming GK
  static List<Question> gkSet1 = [
    Question(
      id: 1,
      question: 'What is the capital of Bangladesh?',
      options: [
        'Dhaka',
        'Chittagong',
        'Khulna',
        'Rajshahi',
      ],
      correctAnswerIndex: 0,
      explanation: 'Dhaka is the capital and largest city of Bangladesh.',
    ),
    Question(
      id: 2,
      question: 'When did Bangladesh gain independence?',
      options: [
        '1971',
        '1947',
        '1952',
        '1965',
      ],
      correctAnswerIndex: 0,
      explanation: 'Bangladesh gained independence on December 16, 1971.',
    ),
    Question(
      id: 3,
      question: 'Who is known as the father of Computer Science?',
      options: [
        'Alan Turing',
        'Charles Babbage',
        'John von Neumann',
        'Ada Lovelace',
      ],
      correctAnswerIndex: 0,
      explanation: 'Alan Turing is considered the father of Computer Science.',
    ),
    Question(
      id: 4,
      question: 'What does CPU stand for?',
      options: [
        'Central Processing Unit',
        'Computer Processing Unit',
        'Central Program Unit',
        'Computer Program Unit',
      ],
      correctAnswerIndex: 0,
      explanation: 'CPU stands for Central Processing Unit.',
    ),
    Question(
      id: 5,
      question: 'What is the national flower of Bangladesh?',
      options: [
        'Water Lily',
        'Rose',
        'Lotus',
        'Marigold',
      ],
      correctAnswerIndex: 0,
      explanation: 'Water Lily (Shapla) is the national flower of Bangladesh.',
    ),
    Question(
      id: 6,
      question: 'Which programming language was originally called "Oak"?',
      options: [
        'Java',
        'Python',
        'C++',
        'JavaScript',
      ],
      correctAnswerIndex: 0,
      explanation: 'Java was originally called "Oak" before being renamed.',
    ),
    Question(
      id: 7,
      question: 'What is the currency of Bangladesh?',
      options: [
        'Taka',
        'Rupee',
        'Dollar',
        'Yen',
      ],
      correctAnswerIndex: 0,
      explanation: 'The currency of Bangladesh is Taka (BDT).',
    ),
    Question(
      id: 8,
      question: 'What does HTML stand for?',
      options: [
        'HyperText Markup Language',
        'HighText Machine Language',
        'HyperText Machine Language',
        'HighText Markup Language',
      ],
      correctAnswerIndex: 0,
      explanation: 'HTML stands for HyperText Markup Language.',
    ),
    Question(
      id: 9,
      question: 'Which river is called the lifeline of Bangladesh?',
      options: [
        'Padma',
        'Jamuna',
        'Meghna',
        'All of the above',
      ],
      correctAnswerIndex: 3,
      explanation: 'Padma, Jamuna, and Meghna are major rivers of Bangladesh.',
    ),
    Question(
      id: 10,
      question: 'What does API stand for?',
      options: [
        'Application Programming Interface',
        'Application Program Interface',
        'Applied Programming Interface',
        'Applied Program Interface',
      ],
      correctAnswerIndex: 0,
      explanation: 'API stands for Application Programming Interface.',
    ),
  ];

  // ================= GETTER METHODS =================

  // C Programming
  static List<Question> getCQuestions() => cSet1;
  static List<Question> getCSet1() => cSet1;
  static List<Question> getCSet2() => cSet2;
  static List<Question> getCSet3() => cSet3;

  // C++ Programming
  static List<Question> getCppQuestions() => cppSet1;
  static List<Question> getCppSet1() => cppSet1;
  static List<Question> getCppSet2() => cppSet2;

  // Python Programming
  static List<Question> getPythonQuestions() => pythonSet1;
  static List<Question> getPythonSet1() => pythonSet1;
  static List<Question> getPythonSet2() => pythonSet2;

  // Dart Programming
  static List<Question> getDartQuestions() => dartSet1;
  static List<Question> getDartSet1() => dartSet1;
  static List<Question> getDartSet2() => dartSet2;
  static List<Question> getFlutterSet1() => flutterSet1;
  static List<Question> getFlutterSet2() => flutterSet2;

  // General Knowledge
  static List<Question> getGKQuestions() => gkSet1;

  // Get all questions by exam type (for backward compatibility)
  static List<Question> getQuestionsByType(String examType) {
    switch (examType) {
      case 'C':
        return getCQuestions();
      case 'C++':
        return getCppQuestions();
      case 'Python':
        return getPythonQuestions();
      case 'Dart':
        return getDartQuestions();
      case 'General Knowledge':
        return getGKQuestions();
      default:
        return [];
    }
  }
}