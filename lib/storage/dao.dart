abstract class Dao<T> {



  List<T> getAll();
  void save(T t) {
  }
  void update(T t);
  void delete(T t);
}
