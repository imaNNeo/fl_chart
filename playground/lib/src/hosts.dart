import 'package:flutter/widgets.dart';

import 'hosts/bar.dart';
import 'hosts/base.dart';
import 'hosts/line.dart';
import 'hosts/pie.dart';
import 'hosts/radar.dart';
import 'hosts/scatter.dart';

/// How the properties of a documented class are shown: an [instance] to
/// start from, and the chart it's [build] into.
class Host {
  const Host({required this.instance, required this.build, this.note});

  final Object Function() instance;
  final Widget Function(Object instance) build;

  /// Shown under the chart, like how to interact with it.
  final String? note;
}

/// The hosts of the documented classes, by class name.
final hosts = <String, Host>{
  ...lineHosts,
  ...baseHosts,
  ...barHosts,
  ...pieHosts,
  ...scatterHosts,
  ...radarHosts,
};
