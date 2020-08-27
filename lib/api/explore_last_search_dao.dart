import 'package:localin/model/explore/explore_event_local_model.dart';
import 'package:sembast/sembast.dart';
import 'app_database.dart';

class ExploreLastSearchDao {
  static const String EXPLORE_LAST_SEARCH_DAO = 'ExploreLastSearchDao';

  final _exploreLastSearchDao =
      intMapStoreFactory.store(EXPLORE_LAST_SEARCH_DAO);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(ExploreEventLocalModel model) async {
    try {
      if (model != null) {
        final db = await _db;
        final data = model.toJson();
        final isNeedToAdd = await _shouldInsertData(model);
        if (isNeedToAdd) {
          await deleteOldRecords();
          return await _exploreLastSearchDao.add(db, data);
        } else {
          return isNeedToAdd ? 0 : 1;
        }
      }
      return null;
    } catch (e) {
      //print
    }
  }

  Future<bool> _shouldInsertData(ExploreEventLocalModel model) async {
    try {
      final finder = Finder(filter: Filter.equals('title', model.title));
      final result = await _exploreLastSearchDao
          .update(await _db, model.toJson(), finder: finder);
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
    final data = await _exploreLastSearchDao.find(await _db, finder: Finder());
    if (data != null && data.length > 2) {
      final result = await _exploreLastSearchDao.delete(await _db,
          finder: Finder(offset: 0, limit: 1));
      return result;
    }
    return -1;
  }

  Future<int> delete() async {
    final result = await _exploreLastSearchDao.delete(await _db);
    return result;
  }

  Future<List<ExploreEventLocalModel>> getAllExploreList() async {
    try {
      final finder = Finder(
        limit: 3,
        sortOrders: [
          SortOrder('timeStamp', false),
        ],
      );
      final recordSnapshots =
          await _exploreLastSearchDao.find(await _db, finder: finder);

      return recordSnapshots.map((snapshot) {
        final draft = ExploreEventLocalModel.fromJson(snapshot.value);
        draft.id = snapshot.key;
        return draft;
      }).toList();
    } catch (e) {
      throw Exception();
    }
  }
}
