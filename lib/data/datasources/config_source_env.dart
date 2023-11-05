// ignore_for_file: avoid-late-keyword

import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:fool_back/domain/datasources/config_source.dart';

class ConfigSourceEnv extends ConfigSource {
  late String _host;
  late int _port;
  late String _dbname;
  String? _dbuser;
  String? _dbpassword;
  late String _dbhost;
  late int _dbport;
  late Directory _uploadpath;
  late bool _dbdebug;
  late bool _debug;
  late String? _secret;
  static const _defaultHOST = 'localhost';
  static const _defaultPORT = 8084;
  static const _defaultDBHOST = 'localhost';
  static const _defaultDBPORT = 5432;
  static const _defaultUPLOADPATH = './upload/';

  ConfigSourceEnv() {
    final env = DotEnv()..load();
    final dbportDef = env.isEveryDefined(['DB_PORT']);
    _host = env.isEveryDefined(['HOST']) ? env['HOST'] ?? '' : _defaultHOST;
    _port = dbportDef ? int.tryParse(env['port'] ?? '') ?? _defaultPORT : _defaultPORT;
    _dbname = env['DB_NAME'] ?? 'test';
    _dbuser = env['DB_USER'];
    _dbpassword = env['DB_PASS'];
    _dbhost = env.isEveryDefined(['DB_HOST']) ? env['DB_HOST'] ?? '' : _defaultDBHOST;
    _dbport = dbportDef ? int.tryParse(env['DB_PORT'] ?? '') ?? _defaultDBPORT : _defaultDBPORT;
    _dbdebug = env.isEveryDefined(['DB_DEBUG']) && env['DB_DEBUG']?.toLowerCase() == 'true';
    _debug = env.isEveryDefined(['DEBUG']) && env['DEBUG']?.toLowerCase() == 'true';
    _uploadpath = env.isEveryDefined(['UPLOAD_PATH'])
        ? Directory(env['UPLOAD_PATH'] ?? '')
        : Directory('${Directory.current.path}$_defaultUPLOADPATH');
    _secret = env['SECRET'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'dbdebug': dbdebug,
      'dbhost': dbhost,
      'dbname': dbname,
      'dbpass': dbpassword,
      'dbport': dbport,
      'dbuser': dbuser,
      'debug': debug,
      'secret': secret,
      'uploadpath': uploadpath,
    };
  }

  @override
  Directory get uploadpath => _uploadpath;

  @override
  bool get dbdebug => _dbdebug;

  @override
  String get dbhost => _dbhost;

  @override
  String get dbname => _dbname;

  @override
  String? get dbpassword => _dbpassword;

  @override
  int get dbport => _dbport;

  @override
  String? get dbuser => _dbuser;

  @override
  bool get debug => _debug;

  @override
  String get host => _host;

  @override
  int get port => _port;

  @override
  String? get secret => _secret;
}
