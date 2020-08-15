import 'package:localin/model/hotel/hotel_suggest_local_model.dart';
import 'package:sembast/sembast.dart';
import 'app_database.dart';

class HotelLastSearchDao {
  static const String HOTEL_LAST_SEARCH_DAO = 'HotelLastSearchDao';

  final _hotelLastSearchStore = intMapStoreFactory.store(HOTEL_LAST_SEARCH_DAO);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(HotelSuggestLocalModel model) async {
    try {
      if (model != null) {
        final db = await _db;
        final data = model.toJson();
        final isNeedToAdd = await _shouldInsertData(model);
        if (isNeedToAdd) {
          await deleteOldRecords();
          return await _hotelLastSearchStore.add(db, data);
        } else {
          return isNeedToAdd ? 0 : 1;
        }
      }
      return null;
    } catch (e) {
      //print
    }
  }

  Future<bool> _shouldInsertData(HotelSuggestLocalModel model) async {
    try {
      final finder = Finder(filter: Filter.equals('hotel_id', model.hotelId));
      final result = await _hotelLastSearchStore
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
    final data = await _hotelLastSearchStore.find(await _db, finder: Finder());
    if (data != null && data.length > 2) {
      final result = await _hotelLastSearchStore.delete(await _db,
          finder: Finder(offset: 0, limit: 1));
      return result;
    }
    return -1;
  }

  Future<int> delete() async {
    final result = await _hotelLastSearchStore.delete(await _db);
    return result;
  }

  Future<List<HotelSuggestLocalModel>> getAllHotelListView() async {
    try {
      final finder = Finder(
        limit: 3,
        sortOrders: [
          SortOrder(Field.key, false),
        ],
      );
      final recordSnapshots =
          await _hotelLastSearchStore.find(await _db, finder: finder);

      return recordSnapshots.map((snapshot) {
        final draft = HotelSuggestLocalModel.fromJson(snapshot.value);
        draft.id = snapshot.key;
        return draft;
      }).toList();
    } catch (e) {
      throw Exception();
    }
  }
}
