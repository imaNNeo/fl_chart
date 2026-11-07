import 'package:flutter/material.dart';

import 'src/scenarios.dart';

/// Shows each scenario's chart, to look at it or profile it by hand in
/// DevTools. The measured runs are in test/ and integration_test/.
void main() => runApp(const BenchmarkApp());

class BenchmarkApp extends StatelessWidget {
  const BenchmarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scenarios = createScenarios();
    return MaterialApp(
      title: 'fl_chart benchmark',
      home: DefaultTabController(
        length: scenarios.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('fl_chart benchmark'),
            bottom: TabBar(
              isScrollable: true,
              tabs: [for (final s in scenarios) Tab(text: s.name)],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final s in scenarios)
                Center(
                  child: SizedBox.fromSize(size: chartSize, child: s.build()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
