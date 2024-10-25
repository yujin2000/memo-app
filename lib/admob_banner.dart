import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 배너를 한 번만 호출해야 하기 때문에 StatefulWidget 를 상속받아야 함
class AdmobBanner extends StatefulWidget {
  const AdmobBanner({super.key});

  @override
  State<AdmobBanner> createState() => _AdmobBannerState();
}

class _AdmobBannerState extends State<AdmobBanner> {
  AdManagerBannerAd? _bannerAd;
  bool _isLoaded = false;

  // 개발 모드에서는 테스트 용 unitId 를 사용해야 함
  final adUnitId = '/21775744923/example/adaptive-banner';
  // final asUnitId = 'ca-app-pub-6417730698637946/9621415781';

  void loadAd() {
    _bannerAd = AdManagerBannerAd(
      adUnitId: adUnitId,
      request: const AdManagerAdRequest(),
      sizes: [AdSize.banner],
      listener: AdManagerBannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null && _isLoaded) {
      return SizedBox(
        width: _bannerAd!.sizes.first.width.toDouble(),
        height: _bannerAd!.sizes.first.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return Container(height: 1);
  }
}
