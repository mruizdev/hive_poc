import 'package:flutter/material.dart';

class FutureWidget<T> extends StatelessWidget {
  final Future<T> future;
  final FutureWidgetListener<T?> listener;

  const FutureWidget({
    Key? key,
    required this.future,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: future,
    builder: (_, snapshot) {
      try {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          return listener.onSuccess(snapshot.data as T);
        } else if (snapshot.hasError) {
          return listener.onError.call(snapshot.error.toString());
        } else {
          return listener.onWait?.call() ?? const SizedBox();
        }
      } catch (ex) {
        debugPrint('FutureWidget Error: $ex');
        return listener.onError.call(snapshot.error.toString());
      }
    },
  );
}

class FutureWidgetListener<T> {
  final Widget Function(T? result) onSuccess;
  final Widget Function(dynamic error) onError;
  final Widget Function()? onWait;

  FutureWidgetListener({
    required this.onSuccess,
    required this.onError,
    this.onWait,
  });
}