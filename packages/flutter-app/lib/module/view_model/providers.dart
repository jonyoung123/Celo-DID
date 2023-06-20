import 'package:flutter_celo_composer/module/view_model/controllers/celo_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final celoProvider =
    ChangeNotifierProvider<CeloDIDProvider>((Ref ref) => CeloDIDProvider());
