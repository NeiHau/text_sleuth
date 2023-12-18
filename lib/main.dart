import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'features/theme/app_strings.dart';
import 'features/utils/common_utils.dart';
import 'features/view/text_recognition_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(800, 600),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(AppStrings.homePageTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: "cameraButton", // ユニークなタグを割り当てる
              onPressed: pickImageFromCamera,
              label: const Text("カメラで撮影"),
            ),
            SizedBox(height: 30.h), // 余白を追加
            FloatingActionButton.extended(
              heroTag: "galleryButton", // 別のユニークなタグを割り当てる
              onPressed: pickImageFromGallery,
              label: const Text("アルバムから取得"),
            ),
          ],
        ),
      ),
    );
  }

  void pickImageFromCamera() {
    CommonUtils.pickImage(source: ImageSource.camera).then((value) {
      if (value != '') {
        CommonUtils.imageCropperView(value, context).then((value) {
          if (value != '') {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => RecognizePage(
                  path: value,
                ),
              ),
            );
          }
        });
      }
    });
  }

  void pickImageFromGallery() {
    CommonUtils.pickImage(source: ImageSource.gallery).then((value) {
      if (value != '') {
        CommonUtils.imageCropperView(value, context).then((value) {
          if (value != '') {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => RecognizePage(
                  path: value,
                ),
              ),
            );
          }
        });
      }
    });
  }
}
