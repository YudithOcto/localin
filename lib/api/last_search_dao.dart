import 'package:localin/model/restaurant/restaurant_local_model.dart';
import 'package:sembast/sembast.dart';

import 'app_database.dart';

class LastSearchDao {
  static const String DRAFT_STORE_NAME = 'LastStoreDao';

  final _draftStore = intMapStoreFactory.store(DRAFT_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(RestaurantLocalModal model) async {
    try {
      if (model != null) {
        final db = await _db;
        final data = model.toJson();
        final isNeedToAdd = await _shouldInsertData(model);
        if (isNeedToAdd) {
          await deleteOldRecords();
          return await _draftStore.add(db, data);
        } else {
          return isNeedToAdd ? 0 : 1;
        }
      }
      return null;
    } catch (e) {
      //print
    }
  }

  Future<bool> _shouldInsertData(RestaurantLocalModal model) async {
    try {
      final finder =
          Finder(filter: Filter.equals('restaurant_id', model.restaurantId));
      final result =
          await _draftStore.update(await _db, model.toJson(), finder: finder);
      return result < 1;
    } catch (error) {
      throw Exception();
    }
  }

  int parseInt(String id) {
    if (id == null || id.isEmpty) {
      return null;
    } else {
      return int.parse(id);
    }
  }

  Future<int> deleteOldRecords() async {
    final data = await _draftStore.find(await _db, finder: Finder());
    if (data != null && data.length > 2) {
      final result = await _draftStore.delete(await _db,
          finder: Finder(offset: 0, limit: 1));
      return result;
    }
    return -1;
  }

  Future<int> delete() async {
    final result = await _draftStore.delete(await _db);
    return result;
  }

  Future<List<RestaurantLocalModal>> getAllDraft() async {
    try {
      final finder = Finder(
        limit: 3,
        sortOrders: [
          SortOrder(Field.key, false),
        ],
      );
      final recordSnapshots = await _draftStore.find(await _db, finder: finder);

      return recordSnapshots.map((snapshot) {
        final draft = RestaurantLocalModal.fromJson(snapshot.value);
        draft.id = snapshot.key;
        return draft;
      }).toList();
    } catch (e) {
      throw Exception();
    }
  }
}
