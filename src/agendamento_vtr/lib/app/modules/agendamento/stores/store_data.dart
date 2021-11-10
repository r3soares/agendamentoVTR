import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:agendamento_vtr/app/domain/log.dart';
import 'package:flutter_triple/flutter_triple.dart';

class StoreData<T extends Object> extends StreamStore<Falha, T> {
  final T data;

  StoreData(this.data) : super(data);

  @override
  update(T data, {bool force = false}) {
    Log.message(this, 'Update $data');
    super.update(data, force: force);
  }

  @override
  setLoading(bool loading, {bool force = false}) {
    Log.message(this, 'Loading $loading');
    super.setLoading(loading, force: force);
  }

  @override
  setError(Falha erro, {bool force = false}) {
    Log.message(this, 'Erro $erro');
    super.setError(erro, force: force);
  }
}
