import 'package:flutter/material.dart';
import 'package:saksham_digital/Ceritificates/CertificateReq.dart';
import 'package:saksham_digital/Courses/Courses.dart';
import 'package:saksham_digital/SplashScreen.dart';
import 'package:saksham_digital/Temp.dart';
import 'package:saksham_digital/Test.dart';
import 'package:saksham_digital/User/LoginPage.dart';
import 'package:saksham_digital/User/RegistrationPage.dart';

import 'Ceritificates/CertificateVer.dart';
import 'Home.dart';
import 'InternshipPage/InternshipPage.dart';

void main() {
  runApp(MaterialApp(
    home:   Splashscreen(),
    //home: BannerCarouselPage()
//    home: Test()

    debugShowCheckedModeBanner: false
    ,
  ));
}

