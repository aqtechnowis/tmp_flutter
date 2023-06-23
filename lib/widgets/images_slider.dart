import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmp_flutter/widgets/app_colors.dart';
import 'package:tmp_flutter/widgets/tabs_indicator.dart';

class ImagesSlider extends StatefulWidget {
  final List<String> _imageUrls;
  final PageController pageController;
  final bool fillBoxWithoutAspectRatio;

  const ImagesSlider(this._imageUrls,
      {Key? key,
      required this.pageController,
      this.fillBoxWithoutAspectRatio = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImagesSliderState();
}

class _ImagesSliderState extends State<ImagesSlider> {
  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  late PageController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = widget.pageController;
    var _pages = _getPageViewChildren();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.animateToPage(
        _controller.initialPage,
        duration: _kDuration,
        curve: _kCurve,
      );
    });

    return Stack(
      children: <Widget>[
        PageView.builder(
          itemCount: _pages.length,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _controller,
          itemBuilder: (BuildContext context, int index) {
            return _pages[index % _pages.length];
          },
        ),
        Positioned(
          top: 4,
          left: 0,
          width: MediaQuery.of(context).size.width,
          child: TabsIndicator(
            controller: _controller,
            inactiveColor: AppColors.LightGrey,
            activeColor: AppColors.Primary,
            itemCount: _pages.length,
            onPageSelected: (int page) {
              _controller.animateToPage(
                page,
                duration: _kDuration,
                curve: _kCurve,
              );
            },
          ),
        )
      ],
    );
  }

  _getPageViewChildren() {
    return widget._imageUrls
        .map((imageUrl) => Container(
              width: MediaQuery.of(context).size.width,
              foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.75, 1],
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, imageUrl) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                      child: const CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: AppColors.Red,
                ),
                width: MediaQuery.of(context).size.width,
                fit: widget.fillBoxWithoutAspectRatio
                    ? BoxFit.cover
                    : BoxFit.fitWidth,
              ),
            ))
        .toList();
  }
}
