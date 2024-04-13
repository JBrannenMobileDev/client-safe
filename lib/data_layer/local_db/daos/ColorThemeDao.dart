import 'dart:async';

import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;

import '../../../models/ColorTheme.dart';

class ColorThemeDao extends Equatable{
  static const String COLOR_THEME_STORE_NAME = 'color_theme';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _ColorThemeStore = sembast.intMapStoreFactory.store(COLOR_THEME_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future<ColorTheme> insert(ColorTheme colorTheme) async {
    colorTheme.id = await _ColorThemeStore.add(await _db, colorTheme.toMap());
    return colorTheme;
  }

  static Future insertLocalOnly(ColorTheme? colorTheme) async {
    colorTheme!.id = null;
    await _ColorThemeStore.add(await _db, colorTheme.toMap());
  }

  static Future<ColorTheme> insertOrUpdate(ColorTheme colorTheme) async {
    List<ColorTheme> colorThemeList = await getAllSortedMostFrequent();
    bool alreadyExists = false;
    for(ColorTheme singleColorTheme in colorThemeList){
      if(singleColorTheme.themeName == colorTheme.themeName){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      return await update(colorTheme);
    }else{
      return await insert(colorTheme);
    }
  }

  static Future<Stream<List<sembast.RecordSnapshot>>> getColorThemesStream() async {
    var query = _ColorThemeStore.query();
    return query.onSnapshots(await _db);
  }

  static Future<ColorTheme> update(ColorTheme colorTheme) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('themeName', colorTheme.themeName));
    await _ColorThemeStore.update(
      await _db,
      colorTheme.toMap(),
      finder: finder,
    );
    return colorTheme;
  }

  static Future delete(ColorTheme theme) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('themeName', theme.themeName));
    await _ColorThemeStore.delete(
      await _db,
      finder: finder,
    );
  }

  static Future<List<ColorTheme>> getAllSortedMostFrequent() async {
    final finder = sembast.Finder(sortOrders: [
      sembast.SortOrder('themeName'),
    ]);

    final recordSnapshots = await _ColorThemeStore.find(await _db, finder: finder).catchError((error) {
      print(error);
    });

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final colorTheme = ColorTheme.fromMap(snapshot.value);
      colorTheme.id = snapshot.key;
      return colorTheme;
    }).toList();
  }

  static Future<void> _deleteAllLocalColorThemes(List<ColorTheme> allLocalColorThemes) async {
    for(ColorTheme location in allLocalColorThemes) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('themeName', location.themeName));
      await _ColorThemeStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<ColorTheme> locations = await getAllSortedMostFrequent();
    _deleteAllLocalColorThemes(locations);
  }
}