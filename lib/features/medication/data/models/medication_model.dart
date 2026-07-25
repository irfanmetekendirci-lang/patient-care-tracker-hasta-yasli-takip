// Bir ilacın yazılım dünyasında nasıl görüneceğini (hangi özellikleri taşıyacağını) belirliyoruz.
class MedicationModel {

  // 'final' kelimesi, bu değişkenin değeri bir kez verildikten sonra
  // bir daha değiştirilemeyeceğini söyler. Bu, verilerin güvenliği için önemlidir.
  // 'String' metinleri, 'bool' doğru/yanlış değerlerini tutar.
  final String id;          // İlacın benzersiz kimliği (Örn: "ilac_1")
  final String name;        // İlacın adı (Örn: "Aspirin")
  final String time;        // İlacın alınma saati (Örn: "08:30")
  final bool isTaken;       // İlaç içildi mi? (true = içildi, false = içilmedi)

  // Constructor (Yapıcı Metot): Bu sınıftan yeni bir ilaç üretmek istediğimizde
  // bizden hangi bilgileri zorunlu olarak isteyeceğini belirtir.
  // 'required' kelimesi, "bu veriyi vermeden bu ilacı oluşturamazsın" demektir.
  MedicationModel({
    required this.id,
    required this.name,
    required this.time,
    required this.isTaken,
  });

  // copyWith metodu: Sınıftaki değerleri değiştirmek istediğimizde kullanırız.
  // 'final' kullandığımız için mevcut ilacı değiştiremeyiz, onun yerine
  // istediğimiz özelliğini güncelleyip "yeni bir kopyasını" oluştururuz.
  // (Örneğin, isTaken false iken, butona basılınca true olan yeni bir kopya üretiriz)
  MedicationModel copyWith({
    String? id,
    String? name,
    String? time,
    bool? isTaken,
  }) {
    return MedicationModel(
      // Eger yeni bir 'id' verilmişse onu kullan (id!), verilmemişse eskisini (this.id) tut.
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      isTaken: isTaken ?? this.isTaken,
    );
  }
}