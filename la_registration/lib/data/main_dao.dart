import 'package:floor/floor.dart';

@dao
abstract class MainDao {
  // Очистить автоинкрементное поле (если нужно)
  @Query('DELETE FROM SQLITE_SEQUENCE WHERE NAME = :tableName')
  Future<void> resetAutoIncrement(String tableName);
}
