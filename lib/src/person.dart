import 'package:floor/floor.dart';

@entity
class Person {
  @primaryKey
  int id;
  String firstName;
  String lastName;
  int age;
  String imageName;
  int telephone;

  Person(
    this.id,
    this.firstName,
    this.lastName,
    this.age,
    this.imageName,
    this.telephone,
  );
}
