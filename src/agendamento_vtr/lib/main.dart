import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';
import 'app/behaviors/override_http_protocol.dart';

void main() async => {
      HttpOverrides.global = new MyHttpOverrides(),
      runApp(
        ModularApp(module: AppModule(), child: AppWidget()),
      )
    };
