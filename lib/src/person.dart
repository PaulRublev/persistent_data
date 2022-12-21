import 'package:floor/floor.dart';

@entity
class Person {
  @primaryKey
  final int id;
  final String firstName;
  final String lastName;
  final int age;
  final String imageName;
  final int telephone;

  Person(
    this.id,
    this.firstName,
    this.lastName,
    this.age,
    this.imageName,
    this.telephone,
  );
}
