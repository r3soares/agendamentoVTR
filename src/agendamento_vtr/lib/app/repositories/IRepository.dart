abstract class IRepository<T> {
  getById(id);
  getAll();
  save(data);
  update(data);
  delete(id);
}
