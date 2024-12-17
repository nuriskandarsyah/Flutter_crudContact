import 'package:flutter_kontak_hp/db/db_helper.dart';

class Contact {
  final int? id;
  final String name;
  final String phone;

  Contact({this.id, required this.name, required this.phone});

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }
}

class ContactRepository {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<int> addContact(Contact contact) async {
    return await dbHelper.createContact(contact.name, contact.phone);
  }

  Future<List<Contact>> getContacts() async {
    final data = await dbHelper.readContacts();
    return data.map((e) => Contact.fromMap(e)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    return await dbHelper.updateContact(
      contact.id!,
      contact.name,
      contact.phone,
    );
  }

  Future<int> deleteContact(int id) async {
    return await dbHelper.deleteContact(id);
  }
}
