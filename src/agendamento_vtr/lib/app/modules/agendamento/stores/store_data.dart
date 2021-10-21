import 'package:agendamento_vtr/app/domain/erros.dart';
import 'package:flutter_triple/flutter_triple.dart';

class StoreData<T extends Object> extends StreamStore<Falha, T> {
  final T data;

  StoreData(this.data) : super(data);
}
