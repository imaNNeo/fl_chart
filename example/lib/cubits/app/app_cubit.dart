import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:equatable/equatable.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(const AppState()) {
    initialize();
  }

  void initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    emit(state.copyWith(
      currentPackageInfo: packageInfo,
      availableVersionToUpdate: '',
      usingFlChartVersion: BuildConstants.usingFlChartVersion,
    ));
  }
}

class BuildConstants {
  static const String usingFlChartVersion = String.fromEnvironment(
    'USING_FL_CHART_VERSION',
    defaultValue: '',
  );
}
