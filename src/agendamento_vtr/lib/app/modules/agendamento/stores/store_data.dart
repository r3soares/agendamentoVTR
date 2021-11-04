import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:flutter_triple/flutter_triple.dart';

class StoreData<T extends Object> extends StreamStore<Falha, T> {
  final T data;

  StoreData(this.data) : super(data);

  @override
  update(T data, {bool force = false}) {
    super.update(data, force: force);
  }

  @override
  setLoading(bool loading, {bool force = false}) {
    super.setLoading(loading, force: force);
  }

  @override
  setError(Falha erro, {bool force = false}) {
    super.setError(erro, force: force);
  }
}
