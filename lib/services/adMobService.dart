import 'package:firebase_admob/firebase_admob.dart';

class AdMobService {
  static const String testDevice = 'MobileId';
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );
/*
  BannerAd bannerAd;
  InterstitialAd interstitialAd;
*/
  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: 'ca-app-pub-2777704196383623/2286431612',
        size: AdSize.fullBanner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {});
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: 'ca-app-pub-2777704196383623/2469947218',
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {});
  }
}
