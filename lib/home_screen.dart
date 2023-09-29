
import 'package:flutter/material.dart';
import 'package:synthai/colors.dart';
import 'package:synthai/features.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:synthai/openai_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:animate_do/animate_do.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  final flutterTts = FlutterTts();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {
      
    });
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

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose(){
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BounceInDown(child: const Icon(Icons.menu)),
        title:BounceInDown(
          child: const Text('Naitik')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ZoomIn(
              child: Stack(
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
            ),
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  margin:const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top:30
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Pallete.borderColor,
                    ),
                    borderRadius: BorderRadius.circular(20).copyWith(
                      topLeft: Radius.zero,
                    )
                  ),
                  child: Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    generatedContent == null
                    ?  "Hey! What can I do for you?"
                    : generatedContent!,
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                      color: Pallete.mainFontColor,
                      fontSize: generatedContent == null ? 20 : 18,
                    )
                  )),
                ),
              ),
            ),
            if(generatedImageUrl!=null) Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(generatedImageUrl!)),
            ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
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
              ),
            ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const FeaturesBox(
                      headerText: "ChatGPT", 
                      descriptionText: "A smarter way to stay organized and informed with ChantGPT",
                      color: Pallete.firstSuggestionBoxColor
                      ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: const FeaturesBox(
                      headerText: "Dall-E", 
                      descriptionText: "Get inspired and stay creative with your personal assistant", 
                      color: Pallete.secondSuggestionBoxColor
                      ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2* delay),
                    child: const FeaturesBox(
                      headerText: "Smart Voice Assistant",
                      descriptionText: "Get inspired and stay creative with your personal assistant", 
                      color: Pallete.thirdSuggestionBoxColor
                      ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton:  ZoomIn(
        delay: Duration(milliseconds: start+3*delay),
        child: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await speechToText.hasPermission && speechToText.isNotListening){
              await startListening();
            }
            else if (speechToText.isListening){
              final speech = await openAIService.isArtPromtAPI(lastWords);
              if(speech.contains('https')){
                generatedContent= null;
                generatedImageUrl= speech;
              } else {
                generatedContent = speech;
                generatedImageUrl= null;
                setState(() {});
                await systemSpeak(speech);
              }
              await stopListening();
            }
            else {
              initSpeechToText();
            }
          },
          child: Icon(
            speechToText.isListening? Icons.stop: Icons.mic)
        ),
      ),
    );
  }
}