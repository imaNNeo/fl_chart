part of 'app_cubit.dart';

class AppState extends Equatable {
  final PackageInfo? currentPackageInfo;
  final String availableVersionToUpdate;
  final String usingFlChartVersion;
  final bool showDownloadNativeAppButton;

  String? get appVersion => currentPackageInfo?.version;

  const AppState([
    this.currentPackageInfo,
    this.availableVersionToUpdate = '',
    this.usingFlChartVersion = '',
    this.showDownloadNativeAppButton = false,
  ]);

  AppState copyWith({
    PackageInfo? currentPackageInfo,
    String? availableVersionToUpdate,
    String? usingFlChartVersion,
    bool? showDownloadNativeAppButton,
  }) {
    return AppState(
      currentPackageInfo ?? this.currentPackageInfo,
      availableVersionToUpdate ?? this.availableVersionToUpdate,
      usingFlChartVersion ?? this.usingFlChartVersion,
      showDownloadNativeAppButton ?? this.showDownloadNativeAppButton,
    );
  }

  @override
  List<Object?> get props => [
        currentPackageInfo,
        availableVersionToUpdate,
        usingFlChartVersion,
        showDownloadNativeAppButton,
      ];
}
