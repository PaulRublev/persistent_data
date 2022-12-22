import 'package:floor/floor.dart';
import 'package:persistent_data/src/person.dart';

@dao
abstract class PersonDao {
  @Query('SELECT * FROM Person')
  Future<List<Person>> findAllPersons();

  @Query('SELECT * FROM Person WHERE id = :id')
  Stream<Person?> findPersonById(int id);

  @Query('DELETE FROM Person WHERE id = :id')
  Future<void> deletePersonById(int id);

  @Query('DROP TABLE Person')
  Future<void> dropTable();

  @Query('SELECT * FROM Person WHERE id = (SELECT MAX(id) FROM Person)')
  Future<Person?> findMaxId();

  @Query(
      'UPDATE Person SET firstName = :firstName, lastName = :lastName, age = :age, imageName = :imageName, telephone = :telephone WHERE id = :id')
  Future<void> update(
    String firstName,
    String lastName,
    int age,
    String imageName,
    int telephone,
    int id,
  );

  @insert
  Future<void> insertPerson(Person person);
}
