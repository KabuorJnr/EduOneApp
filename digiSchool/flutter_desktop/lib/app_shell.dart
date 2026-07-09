import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

import 'app_config.dart';

class DesktopShell extends StatefulWidget {
  const DesktopShell({super.key});

  @override
  State<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends State<DesktopShell> {
  final WebviewController _controller = WebviewController();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _bootWebView();
  }

  Future<void> _bootWebView() async {
    try {
      await _controller.initialize();
      await _configureWebView();
      await _controller.loadUrl(AppConfig.portalUrl);
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _configureWebView() async {
    // Enable developer tools and auto-fill for better UX
    await _controller.setSettings(
      settings: WebviewSettings(
        isZoomControlEnabled: true,
        isGeneralAutofillEnabled: true,
        isPasswordAutofillEnabled: true,
        areDevToolsEnabled: AppConfig.enableDevTools,
      ),
    );
  }

  Future<void> _reloadPortal() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      await _controller.loadUrl(AppConfig.portalUrl);
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<void> _goBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }

  Future<void> _goForward() async {
    if (await _controller.canGoForward()) {
      await _controller.goForward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF07111F), Color(0xFF12243B), Color(0xFF17314F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Navigation toolbar
                _NavigationBar(
                  isLoading: _isLoading,
                  onReload: _reloadPortal,
                  onBack: _goBack,
                  onForward: _goForward,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 1120;
                      final sidebar = SizedBox(
                        width: isWide ? 320 : double.infinity,
                        child: _Sidebar(
                          portalUrl: AppConfig.portalUrl,
                          isLoading: _isLoading,
                          errorMessage: _errorMessage,
                          onReload: _reloadPortal,
                        ),
                      );

                      final portalFrame = Expanded(
                        child: _PortalFrame(
                          controller: _controller,
                          isLoading: _isLoading,
                          errorMessage: _errorMessage,
                          onReload: _reloadPortal,
                        ),
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            sidebar,
                            const SizedBox(width: 20),
                            portalFrame,
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          sidebar,
                          const SizedBox(height: 20),
                          Expanded(child: portalFrame),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.isLoading,
    required this.onReload,
    required this.onBack,
    required this.onForward,
  });

  final bool isLoading;
  final VoidCallback onReload;
  final VoidCallback onBack;
  final VoidCallback onForward;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            onPressed: onBack,
            tooltip: 'Back',
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(6),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_rounded, size: 20),
            onPressed: onForward,
            tooltip: 'Forward',
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(6),
          ),
          IconButton(
            icon: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.8)),
                    ),
                  )
                : const Icon(Icons.refresh_rounded, size: 20),
            onPressed: isLoading ? null : onReload,
            tooltip: 'Reload',
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: const EdgeInsets.all(6),
          ),
          if (AppConfig.enableDevTools)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'DevTools: F12',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.portalUrl,
    required this.isLoading,
    required this.errorMessage,
    required this.onReload,
  });

  final String portalUrl;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function() onReload;

  @override
  Widget build(BuildContext context) {
    final statusColor = errorMessage != null
        ? const Color(0xFFF97316)
        : isLoading
            ? const Color(0xFFFACC15)
            : const Color(0xFF34D399);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: const Icon(Icons.school_rounded, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 18),
                const Text(
                  AppConfig.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppConfig.appTagline,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                _StatusPill(
                  label: errorMessage != null
                      ? 'Portal error'
                      : isLoading
                          ? 'Loading portal'
                          : 'Portal ready',
                  color: statusColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Portal target',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                SelectableText(
                  portalUrl,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onReload,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reload portal'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Backend connectivity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Connected to Supabase backend\nAll features available through web app',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How to run',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '1. Start web app: npm run dev\n2. Run desktop: flutter run -d windows --dart-define=DIGISCHOOL_PORTAL_URL=http://localhost:5173',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PortalFrame extends StatelessWidget {
  const _PortalFrame({
    required this.controller,
    required this.isLoading,
    required this.errorMessage,
    required this.onReload,
  });

  final WebviewController controller;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function() onReload;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(
              child: errorMessage == null
                  ? Webview(controller)
                  : _ErrorState(
                      errorMessage: errorMessage!,
                      onRetry: onReload,
                    ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: const Color(0xFF08111E),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Opening DigiSchool portal',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.errorMessage, required this.onRetry});

  final String errorMessage;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF08111E),
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, color: Color(0xFFF97316), size: 52),
              const SizedBox(height: 16),
              const Text(
                'Could not open the portal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.76),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child, this.padding = const EdgeInsets.all(24)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 26,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}
