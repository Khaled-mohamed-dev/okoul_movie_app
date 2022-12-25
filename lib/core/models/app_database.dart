import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Favorites extends Table {
  IntColumn get id => integer()(); //primary key

  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Favorites])
class MyDataBase extends _$MyDataBase {
  MyDataBase() : super(_openConnection());

  Stream<List<Favorite>> watchFavorites() => select(favorites).watch();

  Future insertMovie(Insertable<Favorite> movie) => into(favorites).insert(movie);

  Future deleteMovie(Insertable<Favorite> movie) => delete(favorites).delete(movie);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

