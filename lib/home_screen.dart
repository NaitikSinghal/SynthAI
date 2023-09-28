
import 'package:flutter/material.dart';
import 'package:synthai/colors.dart';
import 'package:synthai/features.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }
  
  Future<void> initSpeechToText() async{
    await speechToText.initialize();
    setState(() {

    });
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose(){
    super.dispose();
    speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('Naitik'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle
                    )
                  ),
                ),
                Container(
                  height: 125,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage('assets/images/virtualAssistant.png'),
                    fit: BoxFit.contain)
                  )
                )
              ],
            ),
            Container(
              margin:const EdgeInsets.symmetric(horizontal: 40).copyWith(
                top:30
              ) ,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor,
                ),
                borderRadius: BorderRadius.circular(20).copyWith(
                  topLeft: Radius.zero,
                )
              ),
              child: const Padding(padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Hey! What can I do for you?",
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.mainFontColor,
                  fontSize: 20
                )
              )),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top:10,left:25),
              alignment: Alignment.centerLeft,
              child: const Text('Here are a few features',
              style: TextStyle(
                fontFamily: 'Cera Pro',
                color: Pallete.mainFontColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
            ),
            const Column(
              children: [
                FeaturesBox(
                  headerText: "ChatGPT", 
                  descriptionText: "A smarter way to stay organized and informed with ChantGPT",
                  color: Pallete.firstSuggestionBoxColor
                  ),
                FeaturesBox(
                  headerText: "Dall-E", 
                  descriptionText: "Get inspired and stay creative with your personal assistant", 
                  color: Pallete.secondSuggestionBoxColor
                  ),
                FeaturesBox(
                  headerText: "Smart Voice Assistant",
                  descriptionText: "Get inspired and stay creative with your personal assistant", 
                  color: Pallete.thirdSuggestionBoxColor
                  ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening){
            await startListening();
          }
          else if (speechToText.isListening){
            await stopListening();
          }
          else {
            initSpeechToText();
          }
        },
        child: const Icon(Icons.mic)
      ),
    );
  }
}