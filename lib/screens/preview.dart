import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:usicat/helper/clippers.dart';
import 'package:usicat/widgets/shadow_clipper.dart';
import 'package:usicat/widgets/indicator.dart';
import 'package:usicat/widgets/slide.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        Container(
            padding: const EdgeInsets.all(10),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SlideIndicator(
                  index: _index,
                  onPress: (index) {
                    controller.jumpToPage(index);
                  },
                ),
                Material(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          if (_index != 4) {
                            controller.nextPage();
                          } else {
                            context.pushReplacement('/signin');
                          }
                        },
                        child: Container(
                            height: 40,
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10, top: 10),
                            child: Center(
                                child: Text(_index != 4 ? "Next" : "Let's go",
                                    style: const TextStyle(
                                        color: Colors.white))))))
              ],
            ))
      ],
    ));
  }
}
