import 'package:flutter/material.dart';

typedef LibraryLoader = Future<void> Function();
typedef WidgetBuilder = Widget Function();

/// Widget que gestiona la carga diferida (code-splitting) de módulos en Flutter Web.
class DeferredLoader extends StatefulWidget {
  final LibraryLoader loader;
  final WidgetBuilder builder;
  final Widget? fallback;

  const DeferredLoader({
    super.key,
    required this.loader,
    required this.builder,
    this.fallback,
  });

  @override
  State<DeferredLoader> createState() => _DeferredLoaderState();
}

class _DeferredLoaderState extends State<DeferredLoader> {
  late Future<void> _loadingFuture;

  @override
  void initState() {
    super.initState();
    _loadingFuture = widget.loader();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar el módulo:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return widget.builder();
        }
        return widget.fallback ??
            const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003087)),
                ),
              ),
            );
      },
    );
  }
}
