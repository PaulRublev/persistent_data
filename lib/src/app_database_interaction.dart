import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_database.dart';

class AppDatabaseInteraction {
  AppDatabase? _database;
  late PersonDao _personDao;
  FlutterSecureStorage? _storage;
  Map<String, String> _cards = {};
  List<Person> _persons = [];
  Function setStateCallback;

  AppDatabaseInteraction(this.setStateCallback) {
    _initDatabase();
  }

  Map<String, String> get cards {
    return _cards;
  }

  List<Person> get persons {
    return _persons;
  }

  Future<void> _readStorage() async {
    _cards = await _storage!.readAll();
  }

  void _initDatabase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _personDao = _database!.personDao;
    _storage = const FlutterSecureStorage();
    await _readStorage();
    await initPersonTable();
    _persons = await _personDao.findAllPersons();
    setStateCallback(() {});
  }

  void insertPerson(Person person, String cardInfo) async {
    await _personDao.insertPerson(person);
    await _storage!.write(key: person.id.toString(), value: cardInfo);
    await _readStorage();
    _persons = await _personDao.findAllPersons();
    setStateCallback(() {});
  }

  void updatePerson(Person person, String cardInfo) async {
    await _personDao.update(
      person.firstName,
      person.lastName,
      person.age,
      person.imageName,
      person.telephone,
      person.id,
    );
    await _storage!.write(key: person.id.toString(), value: cardInfo);
    await _readStorage();
    _persons = await _personDao.findAllPersons();
    setStateCallback(() {});
  }

  void deletePerson(int id) async {
    await _personDao.deletePersonById(id);
    await _storage!.delete(key: id.toString());
    await _readStorage();
    _persons = await _personDao.findAllPersons();
    setStateCallback(() {});
  }

  void dropPersonTable() async {
    await _personDao.dropTable();
    await _storage!.deleteAll();
    setStateCallback(() {
      _persons = [];
    });
  }

  Future<void> initPersonTable() async {
    await _database!.database.execute(
        'CREATE TABLE IF NOT EXISTS `Person` (`id` INTEGER NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `age` INTEGER NOT NULL, `imageName` TEXT NOT NULL, `telephone` INTEGER NOT NULL, PRIMARY KEY (`id`))');
  }

  Future<void> findMaxIdAndPush(
    Function(int?) navigate,
  ) async {
    Person? person = await _personDao.findMaxId();
    int? id = person?.id;
    navigate(id);
  }
}
