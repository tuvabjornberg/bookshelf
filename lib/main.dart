import 'package:bookshelf/addBook/add_book.dart';
import 'package:bookshelf/bookshelf/user_bookshelf.dart';
import 'package:bookshelf/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MainApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MainApp> {
  int index = 0;
  final screens = [const BookShelf(), const AddBook(), const Profile()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'InterRegular'),
      home: Scaffold(
        body: screens[index],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (newIndex) {
            setState(() {
              index = newIndex;
            });
          },
          currentIndex: index,
          backgroundColor: const Color.fromARGB(255, 246, 190, 85),
          selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/library.svg',
                  width: 40,
                  height: 40,
                  colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 241, 135, 70), BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset(
                  'assets/icons/library.svg',
                  width: 40,
                  height: 40,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                label: 'Bookshelf'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/add.svg',
                  width: 40,
                  height: 40,
                  colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 241, 135, 70), BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset('assets/icons/add.svg',
                    width: 40,
                    height: 40,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                label: 'Add book'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/profile.svg',
                  width: 40,
                  height: 40,
                  colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 241, 135, 70), BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset('assets/icons/profile.svg',
                    width: 40,
                    height: 40,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                label: 'Profile')
          ],
        ),
      ),
    );
  }
}
