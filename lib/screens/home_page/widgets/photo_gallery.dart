import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:gokul_weds_vrinda/const/app_assets.dart';
import 'package:gokul_weds_vrinda/const/screen_helper.dart';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({
    super.key,
    this.autoScrollInterval = const Duration(seconds: 3),
    this.itemWidth = 280,
    this.itemHeight = 400,
  });

  final Duration autoScrollInterval;
  final double itemWidth;
  final double itemHeight;

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  static const int _loopMultiplier = 10000;
  static const Duration _slideDuration = Duration(milliseconds: 700);
  static const Curve _slideCurve = Curves.easeInOutCubic;

  late final List<String> _images;
  late final PageController _controller;
  Timer? _timer;
  bool _isHovering = false;
  int _currentPage = 0;

  int get _count => _images.length;

  @override
  void initState() {
    super.initState();
    _images = AppAssets.galleryImages;
    final initial = _count == 0 ? 0 : _count * _loopMultiplier;
    _currentPage = initial;
    _controller = PageController(initialPage: initial);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final path in _images) {
      precacheImage(AssetImage(path), context);
    }
  }

  // ---------------------------------------------------------------- timer

  void _startAutoScroll() {
    _timer?.cancel();
    if (_count < 2) return;
    _timer = Timer.periodic(widget.autoScrollInterval, (_) {
      if (_isHovering || !mounted || !_controller.hasClients) return;
      _goTo(_currentPage + 1);
    });
  }

  void _stopAutoScroll() {
    _timer?.cancel();
    _timer = null;
  }

  void _onHover(bool hovering) {
    _isHovering = hovering;
    if (hovering) {
      _stopAutoScroll();
    } else {
      _startAutoScroll();
    }
  }

  void _goTo(int page) {
    if (!_controller.hasClients) return;
    _controller.animateToPage(
      page,
      duration: _slideDuration,
      curve: _slideCurve,
    );
  }

  void _manualNavigate(int delta) {
    _goTo(_currentPage + delta);
    // Restart the cadence so the timer doesn't fire right after a click.
    if (!_isHovering) _startAutoScroll();
  }

  // ---------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    if (_count == 0) return const SizedBox.shrink();

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          // Distance between neighbouring photo centres; shrinks on phones.
          final spacing = math.min(widget.itemWidth * 0.62, width * 0.30);
          final stageHeight = widget.itemHeight + 80;

          return SizedBox(
            height: stageHeight,
            width: width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Coverflow visuals, driven by the controller's live page value.
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => _buildCoverflow(spacing),
                ),
                // Invisible PageView: provides swipe / mouse-drag physics.
                Positioned.fill(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad,
                      },
                    ),
                    child: PageView.builder(
                      controller: _controller,
                      onPageChanged: (page) =>
                          setState(() => _currentPage = page),
                      itemBuilder: (_, __) => const SizedBox.expand(),
                    ),
                  ),
                ),

                ScreenHelper.isMobile(context)
                    ? const SizedBox.shrink()
                    : _buildArrow(
                        alignment: Alignment.centerLeft,
                        icon: Icons.chevron_left_rounded,
                        onTap: () => _manualNavigate(-1),
                      ),

                ScreenHelper.isMobile(context)
                    ? const SizedBox.shrink()
                    : _buildArrow(
                        alignment: Alignment.centerRight,
                        icon: Icons.chevron_right_rounded,
                        onTap: () => _manualNavigate(1),
                      ),
                Positioned(
                  bottom: 0,
                  child: Text(
                    '${(_currentPage % _count) + 1} / $_count',
                    style: TextStyle(
                      fontSize: 13,
                      letterSpacing: 1.2,
                      color: Colors.brown.shade400,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoverflow(double spacing) {
    final page = _controller.hasClients && _controller.page != null
        ? _controller.page!
        : _currentPage.toDouble();

    const visibleRange = 3;
    final first = page.floor() - visibleRange;
    final last = page.ceil() + visibleRange;

    // Farthest first so the centre photo is painted on top.
    final indices = [for (var i = first; i <= last; i++) i]
      ..sort((a, b) => (b - page).abs().compareTo((a - page).abs()));

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        for (final i in indices)
          _buildItem(
            image: _images[i % _count],
            delta: i - page,
            spacing: spacing,
          ),
      ],
    );
  }

  Widget _buildItem({
    required String image,
    required double delta,
    required double spacing,
  }) {
    final distance = delta.abs();
    final t = distance.clamp(0.0, 1.0);

    final scale = 1.0 - 0.22 * t - 0.06 * (distance - t).clamp(0.0, 2.0);
    final opacity = (1.0 - 0.4 * t - 0.2 * (distance - t).clamp(0.0, 1.0))
        .clamp(0.0, 1.0);
    final blur = 3.5 * t;
    final angle = -delta.clamp(-1.5, 1.5) * 0.55; // radians

    final dx = delta.sign * (spacing * t + spacing * 0.8 * (distance - t));

    Widget card = _PhotoCard(
      image: image,
      width: widget.itemWidth,
      height: widget.itemHeight,
    );

    if (blur > 0.05) {
      card = ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
          tileMode: TileMode.decal,
        ),
        child: card,
      );
    }

    return RepaintBoundary(
      child: Transform.translate(
        offset: Offset(dx, 0),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateY(angle)
            ..multiply(Matrix4.diagonal3Values(scale, scale, 1.0)),
          child: Opacity(opacity: opacity, child: card),
        ),
      ),
    );
  }

  Widget _buildArrow({
    required Alignment alignment,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Material(
          color: Colors.black.withValues(alpha: 0.45),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({
    required this.image,
    required this.width,
    required this.height,
  });

  final String image;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 28,
            spreadRadius: 1,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image_outlined),
          ),
        ),
      ),
    );
  }
}
