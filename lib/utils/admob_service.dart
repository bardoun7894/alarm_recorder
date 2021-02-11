import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdmobService{
  BannerAd bannerAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();
  BannerAd createBannerAd(AdSize adsize){
    return BannerAd(
      adUnitId: getBannerId(),
      size: adsize,
      targetingInfo: targetingInfo ,
      listener: (MobileAdEvent event) {
        bannerAd..show();
        print("show");
      },
    );
  }
 String getAdmobAppId(){
if(Platform.isIOS){
  return 'ca-app-pub-2529431792707464~8838597133';
}
return null;
}
String getBannerId(){

  if(Platform.isIOS){
    return 'ca-app-pub-2529431792707464/4720879414';
  }
  return null;

}


}