import 'package:sembast/sembast.dart';
import 'app_database.dart';
import 'package:localin/model/article/darft_article_model.dart';

class DraftDao {
  static const String DRAFT_STORE_NAME = 'draft';

  final _draftStore = intMapStoreFactory.store(DRAFT_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(DraftArticleModel model) async {
    try {
      if (model != null) {
        final db = await _db;
        final data = model.toJson();
        final result = await _shouldInsertData(model);
        return result ? await _draftStore.add(db, data) : result ? 0 : 1;
      }
      return null;
    } catch (e) {
      //print
    }
  }

  Future<bool> _shouldInsertData(DraftArticleModel model) async {
    try {
      final finder = Finder(filter: Filter.byKey(model.id));
      final result =
          await _draftStore.update(await _db, model.toJson(), finder: finder);
      return result < 1;
    } catch (error) {
      throw Exception();
    }
  }

  Future update(DraftArticleModel model) async {
    final finder = Finder(filter: Filter.byKey(model.id));
    await _draftStore.update(await _db, model.toJson(), finder: finder);
  }

  Future<int> delete(DraftArticleModel model) async {
    final finder = Finder(filter: Filter.byKey(model.id));
    final result = await _draftStore.delete(await _db, finder: finder);
    return result;
  }

  Future<List<DraftArticleModel>> getAllDraft(int offset, int limit) async {
    try {
      final finder = Finder(
        offset: offset,
        limit: limit,
        sortOrders: [
          SortOrder('datetime', false),
        ],
      );
      final recordSnapshots = await _draftStore.find(await _db, finder: finder);

      return recordSnapshots.map((snapshot) {
        final draft = DraftArticleModel.fromMap(snapshot.value);
        draft.id = snapshot.key;
        return draft;
      }).toList();
    } catch (e) {
      throw Exception();
    }
  }
}
