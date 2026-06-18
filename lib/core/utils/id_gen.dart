import 'package:uuid/uuid.dart';

class IdGen {
  IdGen._();

  static const _uuid = Uuid();

  static String newId() => _uuid.v4();
}
