import 'package:floor/floor.dart';

@dao
abstract class MainDao {
  @Query(':query')
  Future<bool> clearAutoIncrementCounter(String query);
}
