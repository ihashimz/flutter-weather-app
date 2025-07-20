import 'dart:convert';
import 'dart:io';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

Map<String, dynamic> jsonFixture(String name) => json.decode(fixture(name));