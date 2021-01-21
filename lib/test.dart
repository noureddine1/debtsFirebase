import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

class TestAds extends StatefulWidget {
  @override
  _TestAdsState createState() => _TestAdsState();
}

class _TestAdsState extends State<TestAds> {
  BannerAd _bannerAd;
  BannerAd _bannerAdbuild() {
    return BannerAd(
        adUnitId: "ca-app-pub-9445708218348599/2752337998",
        size: AdSize.fullBanner,
        listener: (MobileAdEvent event) {
          _bannerAd..show();
        });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-9445708218348599~6691583008");
    _bannerAd = _bannerAdbuild()..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('test'),
    );
  }
}
