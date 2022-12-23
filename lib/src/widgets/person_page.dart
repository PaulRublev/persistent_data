import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_data/src/database.dart';
import 'package:persistent_data/src/widgets/image_picker.dart';

class PersonPage extends StatelessWidget {
  Person? person;
  final Function(Person, String) addOrUpdate;
  final int? id;
  String? cardInfo;

  late final TextEditingController _controllerFirstName;
  late final TextEditingController _controllerAge;
  late final TextEditingController _controllerLastName;
  late final TextEditingController _controllerTel;
  late final TextEditingController _controllerCard;

  String _imageName = '';
  late Person _person;

  PersonPage({
    super.key,
    this.person,
    required this.addOrUpdate,
    this.id,
    this.cardInfo,
  });

  void _setImageName(String name) {
    _imageName = name;
  }

  @override
  Widget build(BuildContext context) {
    bool isNewPerson = person == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewPerson
              ? 'Add person'
              : '${person?.firstName} ${person?.lastName}',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ImagePicker(
                callback: _setImageName,
                imagePath: isNewPerson ? null : person!.imageName,
              ),
              TextField(
                textInputAction: TextInputAction.next,
                controller: _controllerFirstName = TextEditingController(
                  text: isNewPerson ? '' : person?.firstName,
                ),
                decoration: const InputDecoration(labelText: 'First name'),
              ),
              TextField(
                textInputAction: TextInputAction.next,
                controller: _controllerLastName = TextEditingController(
                  text: isNewPerson ? '' : person?.lastName,
                ),
                decoration: const InputDecoration(labelText: 'Last name'),
              ),
              TextField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _controllerAge = TextEditingController(
                  text: isNewPerson ? '' : person?.age.toString(),
                ),
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              TextField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _controllerTel = TextEditingController(
                  text: isNewPerson ? '' : person?.telephone.toString(),
                ),
                decoration: const InputDecoration(labelText: 'Telephone'),
              ),
              TextField(
                controller: _controllerCard = TextEditingController(
                  text: isNewPerson ? '' : cardInfo.toString(),
                ),
                decoration: const InputDecoration(labelText: 'Card info'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done),
        onPressed: () {
          try {
            if (_controllerAge.value.text.isEmpty ||
                _controllerCard.value.text.isEmpty ||
                _controllerLastName.value.text.isEmpty ||
                _controllerFirstName.value.text.isEmpty ||
                _controllerTel.value.text.isEmpty) {
              throw Exception;
            }
            _person = Person(
              isNewPerson ? (id ?? 0) + 1 : person?.id ?? 1,
              _controllerFirstName.value.text,
              _controllerLastName.value.text,
              int.parse(_controllerAge.value.text),
              _imageName,
              int.parse(_controllerTel.value.text),
            );
          } catch (e) {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                height: 30,
                alignment: Alignment.center,
                child: const Text(
                  'Fill all fields!',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
            );
            return;
          }
          addOrUpdate(_person, _controllerCard.value.text);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
