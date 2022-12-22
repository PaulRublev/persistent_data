import 'package:flutter/material.dart';
import 'package:persistent_data/src/database.dart';
import 'package:persistent_data/src/widgets/person_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppDatabase? _database;
  List<Person> _persons = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  void _initDatabase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final personDao = _database!.personDao;
    await _initPersonTable();
    _persons = await personDao.findAllPersons();
    setState(() {});
  }

  void _insertPerson(Person person) async {
    await _database!.personDao.insertPerson(person);
    _persons = await _database!.personDao.findAllPersons();
    setState(() {});
  }

  void _updatePerson(Person person) async {
    await _database!.personDao.update(
      person.firstName,
      person.lastName,
      person.age,
      person.imageName,
      person.telephone,
      person.id,
    );
    _persons = await _database!.personDao.findAllPersons();
    setState(() {});
  }

  void _deletePerson(int id) async {
    await _database!.personDao.deletePersonById(id);
    _persons = await _database!.personDao.findAllPersons();
    setState(() {});
  }

  void _dropPersonTable() async {
    await _database!.personDao.dropTable();
    setState(() {
      _persons = [];
    });
  }

  Future<void> _initPersonTable() async {
    await _database!.database.execute(
        'CREATE TABLE IF NOT EXISTS `Person` (`id` INTEGER NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `age` INTEGER NOT NULL, `imageName` TEXT NOT NULL, `telephone` INTEGER NOT NULL, PRIMARY KEY (`id`))');
  }

  Future<void> _findMaxIdAndPush(
    BuildContext context,
    Function(int?) navigate,
  ) async {
    Person? person = await _database!.personDao.findMaxId();
    int? id = person?.id;
    navigate(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persons'),
        actions: [
          IconButton(
            onPressed: () async {
              await _initPersonTable();
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => _dropPersonTable(),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _persons.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(4),
            color: Colors.blueAccent,
            child: ListTile(
              minLeadingWidth: 80,
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent.shade100,
                maxRadius: 26,
                backgroundImage: AssetImage(_persons[index].imageName),
              ),
              title: Text("${_persons[index].firstName} "
                  "${_persons[index].lastName}"),
              subtitle: Text("Tel: ${_persons[index].telephone}, "
                  "age: ${_persons[index].age}"),
              onLongPress: () => _deletePerson(_persons[index].id),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PersonPage(
                    addOrUpdate: _updatePerson,
                    person: _persons[index],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: () => _findMaxIdAndPush(
          context,
          (id) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  PersonPage(addOrUpdate: _insertPerson, id: id),
            ),
          ),
        ),
      ),
    );
  }
}
