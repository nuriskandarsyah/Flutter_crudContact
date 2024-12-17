import 'package:flutter/material.dart';
import 'kontak_hp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nomor Kontak',
      home: ContactPage(),
    );
  }
}

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final ContactRepository contactRepo = ContactRepository();
  List<Contact> contacts = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  void _fetchContacts() async {
    final data = await contactRepo.getContacts();
    setState(() {
      contacts = data;
    });
  }

  void _addContact() async {
    if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
      await contactRepo.addContact(
          Contact(name: nameController.text, phone: phoneController.text));
      nameController.clear();
      phoneController.clear();
      _fetchContacts();
    }
  }

  void _updateContact(Contact contact) async {
    if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
      await contactRepo.updateContact(Contact(
        id: contact.id,
        name: nameController.text,
        phone: phoneController.text,
      ));
      nameController.clear();
      phoneController.clear();
      _fetchContacts();
    }
  }

  void _showEditDialog(Contact contact) {
    // Pre-fill the fields with existing data
    nameController.text = contact.name;
    phoneController.text = contact.phone;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Kontak'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Update the contact
                await contactRepo.updateContact(Contact(
                  id: contact.id,
                  name: nameController.text,
                  phone: phoneController.text,
                ));
                nameController.clear();
                phoneController.clear();
                Navigator.pop(context); // Close the dialog
                _fetchContacts(); // Refresh the contact list
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(int id) async {
    await contactRepo.deleteContact(id);
    _fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nomor Kontak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addContact,
              child: Text('Simpan'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return ListTile(
                    title: Text(contact.name),
                    subtitle: Text(contact.phone),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditDialog(contact),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteContact(contact.id!),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
