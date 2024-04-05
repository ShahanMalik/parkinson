import 'package:flutter/material.dart';
import 'package:parkinson/presentation/add_user_detail_screen/add_user_detail_screen.dart';
import 'package:parkinson/presentation/signup_screen/signup_screen.dart';
import 'package:parkinson/theme/theme_helper.dart';

class PageViewScreen extends StatefulWidget {
  @override
  _PageViewScreenState createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  final _controller = PageController();
  int _currentPage = 0;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.cyan300,
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _controller,
        children: [
          SignupScreen(
            onpress: () {
              _controller.animateToPage(
                1,
                duration: Duration(milliseconds: 1500),
                curve: Curves.slowMiddle,
              );
              setState(() {
                _currentPage = 1;
              });
            },
          ),
          AddUserDetailScreen()
        ],
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (_currentPage == 0) {
      //       _controller.animateToPage(
      //         1,
      //         duration: Duration(milliseconds: 1500),
      //         curve: Curves.slowMiddle,
      //       );
      //     } else {
      //       _controller.animateToPage(
      //         0,
      //         duration: Duration(milliseconds: 1500),
      //         curve: Curves.slowMiddle,
      //       );
      //     }
      //   },
      //   child: Icon(
      //       _currentPage == 0 ? Icons.navigate_next : Icons.navigate_before),
      // ),
    );
  }
}
