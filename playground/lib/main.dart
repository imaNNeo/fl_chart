import 'package:flutter/material.dart';

import 'src/playground_page.dart';
import 'src/theme.dart';

/// Interactive demos of the fl_chart properties, embedded in the docs of
/// flchart.dev: `/playground/#/LineChartBarData/isCurved` shows `isCurved`.
void main() => runApp(const PlaygroundApp());

class PlaygroundApp extends StatefulWidget {
  const PlaygroundApp({super.key});

  @override
  State<PlaygroundApp> createState() => _PlaygroundAppState();
}

class _PlaygroundAppState extends State<PlaygroundApp> {
  // The docs change the URL (not the page) when another property is picked.
  final _routerConfig = RouterConfig<Uri>(
    routeInformationProvider: PlatformRouteInformationProvider(
      initialRouteInformation: RouteInformation(
        uri: Uri.parse(
          WidgetsBinding.instance.platformDispatcher.defaultRouteName,
        ),
      ),
    ),
    routeInformationParser: _UriParser(),
    routerDelegate: _PlaygroundRouterDelegate(),
  );

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'FL Chart Playground',
    debugShowCheckedModeBanner: false,
    theme: playgroundTheme,
    routerConfig: _routerConfig,
  );
}

class _UriParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async =>
      routeInformation.uri;

  @override
  RouteInformation restoreRouteInformation(Uri configuration) =>
      RouteInformation(uri: configuration);
}

class _PlaygroundRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier {
  Uri _uri = Uri(path: '/');

  @override
  Uri get currentConfiguration => _uri;

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    _uri = configuration;
    notifyListeners();
  }

  @override
  Future<bool> popRoute() async => false;

  // A single page, updated in place (no transition between properties).
  @override
  Widget build(BuildContext context) => Navigator(
    pages: [
      MaterialPage<void>(
        key: const ValueKey('playground'),
        child: PlaygroundPage(target: PlaygroundTarget.fromUri(_uri)),
      ),
    ],
    onDidRemovePage: (_) {},
  );
}
