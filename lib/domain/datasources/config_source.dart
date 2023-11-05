import 'dart:io';

abstract class ConfigSource {
  String get host;
  int get port;
  String get dbhost;
  int get dbport;
  String get dbname;
  String? get dbuser;
  String? get dbpassword;
  String? get secret;
  Directory get uploadpath;
  bool get dbdebug;
  bool get debug;
  String get redisHost;
  int get redisPort;

  Map<String, dynamic> toJson();
}
