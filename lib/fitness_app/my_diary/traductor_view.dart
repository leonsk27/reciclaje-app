import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TraduccionView extends StatefulWidget {
  const TraduccionView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _TraduccionViewState createState() => _TraduccionViewState();
}

class _TraduccionViewState extends State<TraduccionView>
    with TickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _recognizedText = "";
  String _translatedText = "";
  bool _isListening = false;

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
          _translatedText = _translateToQuechua(_recognizedText);
        });
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  String _translateToQuechua(String text) {
    // Simulación de traducción (puedes integrar una API real aquí)
    return "Traducción a Quechua: $text";
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Centra en el eje horizontal
                    mainAxisAlignment: MainAxisAlignment.center, // Centra en el eje vertical
                    children: <Widget>[
                      Text(
                        "Español  a  Quechua",
                        textAlign: TextAlign.center, // Asegura que el texto esté centrado
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: FitnessAppTheme.nearlyDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextContainer("Texto en Español:", _recognizedText),
                      const SizedBox(height: 16),
                      _buildTextContainer("Texto en Quechua:", _translatedText),

                      const SizedBox(height: 16),
                      Center( // Asegura que el micrófono esté centrado
                        child: GestureDetector(
                          onTap: _isListening ? _stopListening : _startListening,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: _isListening
                                ? Colors.redAccent
                                : FitnessAppTheme.nearlyDarkBlue,
                            child: Icon(
                              _isListening ? Icons.mic_off : Icons.mic,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextContainer(String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Text(
            text.isEmpty ? "Esperando reconocimiento..." : text,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
