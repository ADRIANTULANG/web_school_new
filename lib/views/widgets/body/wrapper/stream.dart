import 'package:flutter/material.dart';

class StreamWrapper<T> extends StatelessWidget {
  const StreamWrapper({
    required this.stream,
    required this.child,
    this.errorWidget,
    this.progressIndicator,
    super.key,
  });

  final Stream<T>? stream;
  final Widget Function(T? data) child;
  final Widget Function(Object?)? errorWidget;
  final Widget? progressIndicator;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if ((snapshot.connectionState == ConnectionState.done
        || snapshot.connectionState == ConnectionState.active)
            && snapshot.hasData) {
          final T? data = snapshot.data;
          return child(data);
        } else if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());

          if (errorWidget != null) {
            return errorWidget!(snapshot.error);

          } else {
            return Center(
              child: Text("Something went wrong. ${snapshot.error}"),
            );
          }

        } else {
          return progressIndicator ?? const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}
