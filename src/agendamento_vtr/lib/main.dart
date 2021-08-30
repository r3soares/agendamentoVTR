import 'package:agendamento_vtr/app/repositories/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

void main() => initializeDateFormatting().then((_) async => {
      await Database.initDatabase(),
      runApp(ModularApp(module: AppModule(), child: AppWidget()))
    });
