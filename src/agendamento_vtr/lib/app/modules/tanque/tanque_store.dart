import 'package:agendamento_vtr/app/modules/tanque/models/tanque.dart';
import 'package:flutter_triple/flutter_triple.dart';

class TanqueStore extends NotifierStore<Exception, Tanque> {
  TanqueStore(Tanque initialState) : super(initialState);
}
