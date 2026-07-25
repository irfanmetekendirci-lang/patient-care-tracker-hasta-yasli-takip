import 'dart:async'; // Kronometre (Timer) için şart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'life_check_state.dart'; // Az önce yazdığımız durumları tanıtalım

class LifeCheckCubit extends Cubit<LifeCheckState> {
  // Başlangıçta 3 saat (10800 saniye) süremiz var
  LifeCheckCubit() : super(LifeCheckInitial());

  Timer? _timer;
  int _currentSeconds = 10800;

  // SAYACI BAŞLATAN FONKSİYON
  void startTimer() {
    _timer?.cancel(); // Eğer çalışan bir sayaç varsa durdur (üst üste binmesin)

    // Uygulama her tıklandığında (1 saniyede bir) çalışacak
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        _currentSeconds--;
        // Ekrana yeni saniyeyi bağırıyoruz: "Zaman akıyor!"
        emit(LifeCheckRunning(_currentSeconds));
      } else {
        _timer?.cancel();
        // Süre bitti, ekrana bağırıyoruz: "TEHLİKE!"
        emit(LifeCheckAlert());
      }
    });
  }

  // BUTONA BASILDIĞINDA SÜREYİ SIFIRLA
  void resetCheck() {
    _currentSeconds = 10800; // Süreyi tekrar 3 saate kur
    startTimer(); // Tekrar saymaya başla
  }

  // Belleği temizle (Uygulama kapanınca sayacı durdurur)
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}