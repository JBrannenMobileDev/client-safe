
class EnvironmentUtil {
  static final EnvironmentUtil _environmentUtil = EnvironmentUtil._internal();

  static const String PROD = "prod";
  static const String STAGE = "stage";
  static const String DEV = "dev";

  String _currentEnvironment = DEV;

  factory EnvironmentUtil() {
    return _environmentUtil;
  }

  String getCurrentEnvironment(){
    return _currentEnvironment;
  }

  EnvironmentUtil._internal();
}