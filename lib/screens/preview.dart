import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/helper/clippers.dart';
import 'package:musicplayer/widgets/shadow_clipper.dart';
import 'package:musicplayer/widgets/indicator.dart';
import 'package:musicplayer/widgets/slide.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'signin_screen.dart';

class Preview extends StatefulWidget {
  const Preview({super.key});

  @override
  State<StatefulWidget> createState() => PreviewState();
}

class PreviewState extends State<Preview> {
  final CarouselSliderController controller = CarouselSliderController();
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ShadowClipper(
                clipper: BackgroundClipper(),
                child:
                    Container(color: const Color.fromARGB(255, 205, 195, 254))),
            CarouselSlider(
                carouselController: controller,
                items: [
                  Slide(
                    quote: AppLocalizations.of(context)!.quote1,
                    description: AppLocalizations.of(context)!.des1,
                  ),
                  Slide(
                    quote: AppLocalizations.of(context)!.quote2,
                    description: AppLocalizations.of(context)!.des2,
                  ),
                  Slide(
                    quote: AppLocalizations.of(context)!.quote3,
                    description: AppLocalizations.of(context)!.des3,
                  ),
                  Slide(
                    quote: AppLocalizations.of(context)!.quote4,
                    description: AppLocalizations.of(context)!.des4,
                  ),
                  Slide(
                    quote: AppLocalizations.of(context)!.quote5,
                    description: AppLocalizations.of(context)!.des5,
                  )
                ],
                options: CarouselOptions(
                  initialPage: _index,
                  viewportFraction: 1.0,
                  aspectRatio: 1.6,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _index = index;
                    });
                  },
                ))
          ],
        )),
        Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SlideIndicator(
                  index: _index,
                  onPress: (index) {
                    controller.jumpToPage(index);
                  },
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Material(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              if (_index != 4) {
                                controller.nextPage();
                              } else {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const SignScreen();
                                }));
                              }
                            },
                            child: Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10, top: 10),
                                child: Center(
                                    child: Text(
                                        _index != 4 ? "Next" : "Let's go",
                                        style: const TextStyle(
                                            color: Colors.white)))))))
              ],
            ))
      ],
    ));
  }
}
