part of 'extensions.dart';

extension ContextExtension on BuildContext {
  Route<T> _buildRoute<T>(
    Widget page, {
    String? rootName,
    bool transition = true,
  }) {
    if (transition) {
      return CupertinoPageRoute<T>(
        builder: (_) => page,
        settings: RouteSettings(name: rootName),
      );
    }

    return PageRouteBuilder<T>(
      pageBuilder: (_, _, _) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  Future<T?> push<T>(Widget route, {String? rootName, bool transition = true}) {
    return Navigator.push<T?>(
      this,
      _buildRoute<T>(route, rootName: rootName, transition: transition),
    );
  }

  Future<T?> pushAndRemoveUntil<T>(
    Widget route,
    RoutePredicate predicate, {
    bool transition = true,
  }) {
    return Navigator.pushAndRemoveUntil<T?>(
      this,
      _buildRoute<T>(route, transition: transition),
      predicate,
    );
  }
}
