import 'package:flutter/material.dart';
import 'package:persistent_data/src/app_database_interaction.dart';
import 'package:persistent_data/src/widgets/person_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppDatabaseInteraction dbInteraction;

  @override
  void initState() {
    super.initState();
    dbInteraction = AppDatabaseInteraction(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persons'),
        actions: [
          IconButton(
            onPressed: () async {
              await dbInteraction.initPersonTable();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => dbInteraction.dropPersonTable(),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dbInteraction.persons.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(4),
            color: Colors.blueAccent,
            child: ListTile(
              isThreeLine: true,
              minLeadingWidth: 80,
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent.shade100,
                maxRadius: 26,
                backgroundImage:
                    AssetImage(dbInteraction.persons[index].imageName),
              ),
              title: Text("${dbInteraction.persons[index].firstName} "
                  "${dbInteraction.persons[index].lastName}"),
              subtitle: Text("Tel: ${dbInteraction.persons[index].telephone}, "
                  "age: ${dbInteraction.persons[index].age} "
                  "cardInfo: ${dbInteraction.cards[dbInteraction.persons[index].id.toString()]}"),
              onLongPress: () =>
                  dbInteraction.deletePerson(dbInteraction.persons[index].id),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PersonPage(
                    addOrUpdate: dbInteraction.updatePerson,
                    person: dbInteraction.persons[index],
                    cardInfo: dbInteraction
                        .cards[dbInteraction.persons[index].id.toString()],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: () => dbInteraction.findMaxIdAndPush(
          (id) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  PersonPage(addOrUpdate: dbInteraction.insertPerson, id: id),
            ),
          ),
        ),
      ),
    );
  }
}
