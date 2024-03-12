import 'dart:async';
import 'dart:typed_data';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';

class DeviceContactsDao {
  static Future<Iterable<Contact>> getDeviceContacts() async {
    return await ContactsService.getContacts(withThumbnails: false, photoHighResolution: false);
  }

  static Future<List<Contact>> getNonClientDeviceContacts(List<Client> clients) async {
    Iterable<Contact> allContacts = await getDeviceContacts();
    List<Contact> result = [];
    for (Contact contact in allContacts) {
      if (contact.phones != null && contact.phones!.isNotEmpty && contact.displayName != null && contact.displayName!.isNotEmpty){
        if(!contactAlreadyExists(clients, contact)){
          result.add(contact);
        }
      }
    }
    return result;
  }

  static bool contactAlreadyExists(List<Client> clients, Contact contact) {
    bool result = false;
    if(contact.phones != null && contact.phones!.isNotEmpty){
      for(Item phoneItem in contact.phones!){
        String contactPhone = phoneItem.value ?? "";
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
      Iterable<Item> phoneNumbers = contact.phones!.toList();
      for(Item phone in phoneNumbers) {
        if(phone.value == client.phone) contactAlreadyExists = true;
      }
    }
    if (contactAlreadyExists) {
      updateContact(client);
    } else {
      addContact(client);
    }
  }

  static Future<Contact> _contactFromClient(Client client) async {
    return Contact(
        givenName: client.firstName,
        familyName: client.lastName,
        phones: [Item(label: "mobile", value: client.phone)],
    );
  }
}
