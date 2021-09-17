import 'package:agendamento_vtr/app/models/json_serializable.dart';

abstract class IRepository<T> {
  getById(id);
  getAll();
  save(String data);
  update(String data);
  delete(id);
}
