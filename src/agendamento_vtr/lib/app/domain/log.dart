abstract class Log {
  static message(dynamic o, String m) => print('${o.runtimeType}: $m');
}
