import 'package:flutter/material.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/text_themes.dart';
import 'package:localin/themes.dart';
import 'package:localin/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  static const routeName = 'OnBoardingPage';

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final int _numPages = 3;
  bool showLoginPage = false;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final onBoardingImage = [
    'images/onboarding_cover.png',
    'images/onboarding_cover.png',
    'images/onboarding_cover.png'
  ];
  final onBoardingTitle = [
    'Personal City Assistant',
    'Go Local',
    '#BisaDiAndelin'
  ];
  final onBoardingBody = [
    'Get ready for your personal city assistant. What do you expect in only one app can do?',
    'Go local is going global. Find local service, local news, or even local community that fulfill &  enrich your life.',
    'Anything, Localin will help. Because Localin #BisaDiandelin'
  ];

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 12.0,
      width: 12.0,
      decoration: BoxDecoration(
        color: isActive ? ThemeColors.primaryBlue : ThemeColors.black10,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              child: PageView(
                physics: ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: List.generate(onBoardingImage.length, (index) {
                  return Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          '${onBoardingImage[index]}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 26.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              '${onBoardingTitle[index]}',
                              textAlign: TextAlign.center,
                              style: ThemeText.rodinaTitle2,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              '${onBoardingBody[index]}',
                              textAlign: TextAlign.center,
                              style: ThemeText.sfRegularHeadline
                                  .copyWith(color: ThemeColors.black80),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
              InkWell(
                onTap: () async {
                  if (_currentPage == _numPages - 1) {
                    Navigator.of(context).pushNamed(LoginPage.routeName);
                    SharedPreferences sf =
                        await SharedPreferences.getInstance();
                    sf.setBool(kUserCarousel, false);
                  }
                },
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: _currentPage == _numPages - 1 ? 1 : 0,
                  child: Container(
                    height: 48.0,
                    margin: const EdgeInsets.only(top: 22.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: _currentPage == _numPages - 1
                            ? ThemeColors.primaryBlue
                            : ThemeColors.black10,
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Center(
                      child: Text(
                        'Join Now',
                        textAlign: TextAlign.center,
                        style: ThemeText.rodinaTitle3.copyWith(
                            color: _currentPage == _numPages - 1
                                ? ThemeColors.black0
                                : ThemeColors.black60),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
