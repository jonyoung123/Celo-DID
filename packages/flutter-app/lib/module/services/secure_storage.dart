import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final String _addressKey = 'address';
  final String _identifierKey = 'identifier';
  final String _isCreatedKey = 'didCreated';
  final String _celoDid = 'celoDid';

  Future<dynamic> setUserAddress(String address) async {
    await storage.write(key: _addressKey, value: address);
  }

  Future<dynamic> setIdentifier(String identifier) async {
    await storage.write(key: _identifierKey, value: identifier);
  }

  Future<dynamic> setCeloDID(String did) async {
    await storage.write(key: _celoDid, value: did);
  }

  Future<dynamic> setCreatedBoolean() async {
    await storage.write(key: _isCreatedKey, value: 'true');
  }

  Future<dynamic> getUserAddress() async {
    String? address = await storage.read(key: _addressKey);
    return address;
  }

  Future<dynamic> getIdentifier() async {
    String? identifier = await storage.read(key: _identifierKey);
    return identifier;
  }

  Future<dynamic> getCeloDID() async {
    String? celoDID = await storage.read(key: _celoDid);
    return celoDID;
  }

  Future<dynamic> getCreatedBoolean() async {
    String? boolKey = await storage.read(key: _isCreatedKey);
    return boolKey;
  }
}
