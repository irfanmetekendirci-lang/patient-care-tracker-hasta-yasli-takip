// Oluşturduğumuz kalıbı (MedicationModel) burada kullanabilmek için,
// o dosyanın nerede olduğunu bu dosyaya tanıtmamız (import etmemiz) gerekiyor.
// Not: "features/..." kısmı senin projendeki klasör ismine göre otomatik tamamlanmalıdır.
import '../../features/medication/data/models/medication_model.dart';

// Veritabanımız olmadığı için verileri geçici olarak bu sınıfta tutacağız.
class MockDatabase {

  // 'List', C veya C#'taki diziler (array) veya List yapısı gibidir.
  // İçinde birden fazla öğe tutmamızı sağlar.
  // Burada "Sadece MedicationModel tipinde veriler tutan bir liste" oluşturuyoruz.
  static List<MedicationModel> dummyMedications = [

    // 1. İlaç
    MedicationModel(
      id: "1",               // Veritabanında her kaydın eşsiz bir ID'si olmalıdır.
      name: "Tansiyon İlacı",
      time: "08:00",
      isTaken: true,         // Sabah içilmiş (true)
    ),

    // 2. İlaç
    MedicationModel(
      id: "2",
      name: "Göz Damlası",
      time: "14:30",
      isTaken: false,        // Henüz içilmemiş (false)
    ),

    // 3. İlaç
    MedicationModel(
      id: "3",
      name: "Vitamin Kompleksi",
      time: "20:00",
      isTaken: false,
    ),
  ];
}