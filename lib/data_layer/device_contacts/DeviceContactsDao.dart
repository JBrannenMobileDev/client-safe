import 'dart:async';
import 'dart:typed_data';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/utils/TextFormatterUtil.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';

class DeviceContactsDao {
  static Future<Iterable<Contact>> getDeviceContacts() async {
    return await ContactsService.getContacts();
  }

  static Future<List<Contact>> getNonClientDeviceContacts(List<Client> clients) async {
    Iterable<Contact> allContacts = await getDeviceContacts();
    List<Contact> result = List();
    for (Contact contact in allContacts) {
      if (contact.phones != null && contact.phones.isNotEmpty && contact.displayName != null && contact.displayName.isNotEmpty){
        if(!contactAlreadyExists(clients, contact)){
          result.add(contact);
        }
      }
    }
    return result;
  }

  static bool contactAlreadyExists(List<Client> clients, Contact contact) {
    bool result = false;
    if(contact.phones != null && contact.phones.length > 0){
      for(Item phoneItem in contact.phones){
        String contactPhone = phoneItem.value;
        for(Client client in clients){
          String clientPhone = client.phone;
          contactPhone = TextFormatterUtil.formatPhoneNum(contactPhone);
          clientPhone = TextFormatterUtil.formatPhoneNum(clientPhone);
          if(contactPhone == clientPhone) return true;
        }
      }
    }
    return result;
  }

  static void addContact(Client client) async {
    await ContactsService.addContact(await _contactFromClient(client));
  }

  static void deleteContact(Client client) async {
    await ContactsService.deleteContact(await _contactFromClient(client));
  }

  static void updateContact(Client client) async {
    await ContactsService.updateContact(await _contactFromClient(client));
  }

  static void addOrUpdateContact(Client client) async {
    Iterable<Contact> allContacts = await getDeviceContacts();
    bool contactAlreadyExists = false;
    for (Contact contact in allContacts) {
      if (contact.phones.contains(client.phone)) contactAlreadyExists = true;
    }
    if (contactAlreadyExists) {
      updateContact(client);
    } else {
      addContact(client);
    }
  }

  static Future<Contact> _contactFromClient(Client client) async {
    ByteData avatarBytes = await rootBundle.load(client.iconUrl);
    Uint8List avatar = avatarBytes.buffer.asUint8List();
    return Contact(
        givenName: client.firstName,
        familyName: client.lastName,
        phones: [Item(label: "mobile", value: client.phone)],
        avatar: avatar);
  }
}
