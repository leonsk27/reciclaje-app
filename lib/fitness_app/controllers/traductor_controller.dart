import 'package:get/get.dart';

class TraduccionController extends GetxController {
  var textoEntrada = ''.obs;
  var textoSalida = ''.obs;
  var esQuechuaAEspanol = true.obs; // true: Quechua -> Español, false: Español -> Quechua

  void traducirTexto() {
    if (textoEntrada.value.isEmpty) {
      textoSalida.value = "Ingrese un texto para traducir.";
      return;
    }

    if (esQuechuaAEspanol.value) {
      textoSalida.value = _traducirQuechuaAEspanol(textoEntrada.value);
    } else {
      textoSalida.value = _traducirEspanolAQuechua(textoEntrada.value);
    }
  }

  void intercambiarIdioma() {
    esQuechuaAEspanol.value = !esQuechuaAEspanol.value;
    textoSalida.value = "";
  }

  // Simulación de traducción (debes conectar con un API real)
  String _traducirQuechuaAEspanol(String texto) {
    Map<String, String> diccionario = {
      "allin": "bien",
      "rikuna": "ver",
      "mikhuy": "comer",
      "yachay": "aprender"
    };
    return diccionario[texto.toLowerCase()] ?? "Traducción no encontrada";
  }

  String _traducirEspanolAQuechua(String texto) {
    Map<String, String> diccionario = {
      "bien": "allin",
      "ver": "rikuna",
      "comer": "mikhuy",
      "aprender": "yachay"
    };
    return diccionario[texto.toLowerCase()] ?? "Traducción no encontrada";
  }
}
