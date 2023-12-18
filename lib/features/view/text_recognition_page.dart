import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;
  TextEditingController controller = TextEditingController();
  TextEditingController filterController = TextEditingController();
  String originalText = ''; // 読み取ったオリジナルのテキストを保持

  @override
  void initState() {
    super.initState();
    final InputImage inputImage = InputImage.fromFilePath(widget.path!);
    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("読み取り完了"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isBusy
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: filterController,
                    decoration: const InputDecoration(
                      labelText: "絞り込むワードを入力してください (例：'ed')",
                    ),
                    onChanged: (value) =>
                        applyFilter(), // フィルタ条件が変更されたときにフィルタリング
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () => applyFilter(),
                  child: const Text('絞り込む'),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      maxLines: MediaQuery.of(context).size.height.toInt(),
                      controller: controller,
                      decoration: const InputDecoration(
                          hintText: "Filtered text goes here..."),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    setState(() {
      _isBusy = true;
    });

    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);
    originalText = recognizedText.text; // オリジナルテキストを保持

    applyFilter(); // 初期フィルタリング

    setState(() {
      _isBusy = false;
    });
  }

  void applyFilter() {
    String filteredText = filterText(originalText, filterController.text);
    setState(() {
      controller.text = filteredText;
    });
  }

  String filterText(String text, String filter) {
    if (filter.isEmpty) return text;

    var lines = text.split('\n');
    var filteredLines = lines.where((line) => line.contains(filter)).toList();

    return filteredLines.join('\n');
  }
}
