import 'package:get/get.dart';
import 'package:senior_app/Director/AI/chroma/chroma_controller.dart';

class ChromaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChromaController>(() => ChromaController());
  }
}
