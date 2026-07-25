abstract class LifeCheckState {}

// 1. Başlangıç durumu (Uygulama ilk açıldığında)
class LifeCheckInitial extends LifeCheckState {}

// 2. Çalışma durumu (Saniye saniye geriye sayarken)
class LifeCheckRunning extends LifeCheckState {
  final int remainingSeconds; // Kalan saniyeyi içinde taşır
  LifeCheckRunning(this.remainingSeconds);
}

// 3. Tehlike durumu (Süre bitti, yaşlımız butona basmadı!)
class LifeCheckAlert extends LifeCheckState {}