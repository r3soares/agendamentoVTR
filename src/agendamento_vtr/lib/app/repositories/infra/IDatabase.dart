abstract class IDatabase {
  getById(id);
  getAll();
  find(instrucao, termo);
  find2(instrucao, termo);
  save(String data);
  update(String data);
  delete(id);
}
