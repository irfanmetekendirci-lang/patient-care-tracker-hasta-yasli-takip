// Gerekli paketleri ve dosyaları içeri aktarıyoruz
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hasta_yasli_kontrol/features/medication/data/models/medication_model.dart';
import '../../../core/dummy_data/mock_database.dart';
import 'medication_state.dart';

// MedicationCubit: İlaçlarla ilgili tüm iş mantığını yöneten sınıf.
// 'Cubit<MedicationState>' diyerek, bu beyinin sadece ilaç durumlarını
// (Loading, Loaded, Error) dışarı fırlatacağını belirtiyoruz.
class MedicationCubit extends Cubit<MedicationState> {

  // Başlangıçta boş bir listeyle "Yüklendi" durumunda başla
  MedicationCubit() : super(MedicationLoaded([]));
  // FONKSİYON 1: İlaçları Getir
  void fetchMedications() async {
    try {
      // 1. Önce ekrana "Yükleniyor..." durumunu gönderiyoruz.
      emit(MedicationLoading());

      // 2. Normalde burada internetten veri beklenir (await).
      // Biz şimdilik sahte veritabanımızdan listeyi alıyoruz.
      final medicines = MockDatabase.dummyMedications;

      // 3. Veri başarıyla geldi! Ekrana "Yüklendi" durumunu ve ilaç listesini gönderiyoruz.
      emit(MedicationLoaded(medicines));
    } catch (e) {
      // 4. Eğer bir hata oluşursa, ekrana hata mesajını gönderiyoruz.
      emit(MedicationError("İlaçlar yüklenirken bir hata oluştu."));
    }
  }

  // FONKSİYON 2: İlacı İçildi/İçilmedi Olarak İşaretle
  void toggleMedicationStatus(String id) {
    // Eğer şu anki durumumuz 'MedicationLoaded' ise işlem yapabiliriz
    if (state is MedicationLoaded) {
      // Mevcut listeyi alıyoruz
      final currentList = (state as MedicationLoaded).medications;

      // Listeyi gezip, ID'si eşleşen ilacın durumunu tersine çeviriyoruz (true ise false, false ise true)
      final updatedList = currentList.map((med) {
        if (med.id == id) {
          return med.copyWith(isTaken: !med.isTaken);
        }
        return med;
      }).toList();

      // Güncellenmiş listeyi tekrar ekrana fırlatıyoruz (Ekran anında yenilenir!)
      emit(MedicationLoaded(updatedList));
    }
  }

  void addMedication(MedicationModel newMedication){
    if(state is MedicationLoaded){
      final currentList = (state as MedicationLoaded).medications;
      final updatedList = List<MedicationModel>.from(currentList)..add(newMedication);
      emit(MedicationLoaded(updatedList));
    }else{
      emit(MedicationLoaded([newMedication]));
    }
  }

  void deleteMedication(String id) {
    if (state is MedicationLoaded) {
      final currentState = state as MedicationLoaded;
      // Listeden o ID'ye sahip olmayanları filtrele (yani o ID'liyi çıkar)
      final updatedList = currentState.medications.where((m) => m.id != id).toList();
      emit(MedicationLoaded(updatedList));
    }
  }

}