part of 'app_cubit.dart';

class AppState extends Equatable {
  final PackageInfo? currentPackageInfo;
  final String availableVersionToUpdate;
  final String usingFlChartVersion;

  String? get appVersion => currentPackageInfo?.version;

  const AppState([
    this.currentPackageInfo,
    this.availableVersionToUpdate = '',
    this.usingFlChartVersion = '',
  ]);

  AppState copyWith({
    PackageInfo? currentPackageInfo,
    String? availableVersionToUpdate,
    String? usingFlChartVersion,
  }) {
    return AppState(
      currentPackageInfo ?? this.currentPackageInfo,
      availableVersionToUpdate ?? this.availableVersionToUpdate,
      usingFlChartVersion ?? this.usingFlChartVersion,
    );
  }

  @override
  List<Object?> get props => [
        currentPackageInfo,
        availableVersionToUpdate,
        usingFlChartVersion,
      ];
}
