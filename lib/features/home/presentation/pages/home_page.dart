import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hasta_yasli_kontrol/features/life_check/cubit/life_check_cubit.dart';
import 'package:hasta_yasli_kontrol/features/life_check/cubit/life_check_state.dart';
import 'package:hasta_yasli_kontrol/features/medication/cubit/medication_cubit.dart';
import 'package:hasta_yasli_kontrol/features/medication/cubit/medication_state.dart';
import 'package:hasta_yasli_kontrol/features/medication/data/models/medication_model.dart';
import 'package:hasta_yasli_kontrol/features/notes/cubit/notes_cubit.dart';
import 'package:hasta_yasli_kontrol/features/notes/data/models/note_model.dart';

// 1. StatefulWidget Parçası
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// 2. State (Durum) Parçası ve Ekran Çizimi
class _HomePageState extends State<HomePage> {
  final TextEditingController  _nameController = TextEditingController();
  // Saat kutusunu kontrol etmek için kumanda
  final TextEditingController _timeController = TextEditingController();
  // Notlat ksımında yazılanları kontrol etmek için controller
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteContentController = TextEditingController();
  // Alt menüde hangi sekmede olduğumuzu tutan değişken (0'dan başlar)
  int _selectedIndex = 0;

  // Modern Renk Paleti Sabitleri
  static const Color primaryColor = Color(0xFF5F8670); // Okaliptüs Yeşili
  static const Color darkText = Color(0xFF2D3250);    // Modern Koyu Lacivert
  static const Color bgColor = Color(0xFFF8F9F8);     // Ferah Arka Plan

  // Tıklanan sekmeye göre ekranda gösterilecek geçici boş sayfalar listesi.
   List<Widget> get _pages => [
    Center(child: Text('💊 İlaç Takip Ekranı', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkText))),
    _buildLifeCheckPage(),
    _buildNotesPage(),
  ];

  // Alt menüdeki butonlara tıklandığında çalışacak fonksiyon
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        title: const Text(
          'Hasta Kontrol Uygulaması',
          style: TextStyle(color: darkText, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),

      body: _selectedIndex == 0
        ? BlocBuilder<MedicationCubit, MedicationState>(
          builder: (context ,state){
            if(state is MedicationLoading){
              return const Center(child: CircularProgressIndicator());
            }

            if(state is MedicationLoaded){
              if(state.medications.isEmpty){
                return const Center(
                  child: Text("Henüz İlaç Eklenmemiş. \nSağ Alttaki Butondan Ekleyebilirsiniz.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)),
                );
              }
              return ListView.builder(
                  padding: const EdgeInsets.all(10),
                    itemCount: state.medications.length,
                    itemBuilder: (context, index){
                      final med = state.medications[index];

                      return Dismissible(
                        key: Key(med.id),

                          direction: DismissDirection.endToStart,
                          background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                        onDismissed: (direction) {
                          context.read<MedicationCubit>().deleteMedication(med.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${med.name} silindi"),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: primaryColor,
                              child: Icon(Icons.medication,color: Colors.white,),
                            ),
                            title: Text(
                                med.name, style: TextStyle(
                                fontWeight: FontWeight.bold,
                              decoration: med.isTaken ? TextDecoration.lineThrough : TextDecoration.none,
                              color: med.isTaken ? Colors.grey : darkText,
                            ),
                            ),
                            subtitle: Text("Saat: ${med.time}"),
                            trailing: Checkbox(
                              activeColor: primaryColor,
                              value: med.isTaken,
                              onChanged: (bool? value){
                                context.read<MedicationCubit>().toggleMedicationStatus(med.id); //fonksiyonu bağladık
                              },
                            ),
                          ),
                        ),
                      );
                    }
                );
            }
            return const Center(child: Text("Bir Hata Oluştu"));
          },
      )
      : _pages[_selectedIndex],

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            iconSize: 30,   //ikonların boyunu arttırdık
            selectedFontSize: 14,   //yazıları okunaklı duruma getirdik
            unselectedFontSize: 12,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.medical_services_rounded),
                label: 'İlaçlar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_rounded),
                label: 'Hayatta Mı?',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notes_rounded),
                label: 'Notlar',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey.shade400,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
          ),
        ),
      ),

      // FAB tasarımı senin düzeninde ayarlandı
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 2)
          ? SizedBox(
            width: 75,
            height: 75,
            child: FloatingActionButton(
                    backgroundColor: primaryColor,
                    onPressed: () {
            if (_selectedIndex == 0) {
              _showMedicationSheet(context);
            } else if (_selectedIndex == 2) {
              _showNoteSheet(context);
            }
                    },
              elevation: 8,
              shape: const CircleBorder(),
                    child: Icon(
            _selectedIndex == 0 ? Icons.medication : Icons.note_add,
            color: Colors.white,
                      size: 35,
                    ),
                  ),
          )
          : null,
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
      print("seçilen saat ${picked.format(context)}");
    }
  }

  // İLAÇ EKLEME PENCERESİ (AYRI FONKSİYON)
  void _showMedicationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Yeni İlaç Ekle",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkText)),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "İlaç Adı",
                    prefixIcon: const Icon(Icons.medication, color: primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  decoration: InputDecoration(
                    labelText: "Kullanım Saati",
                    prefixIcon: const Icon(Icons.access_time_filled, color: primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    hintText: "Saat Seçmek İçin Tıklayın",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final medicationName = _nameController.text;
                    final medicationTime = _timeController.text;

                    if (medicationTime.isNotEmpty && medicationName.isNotEmpty) {
                      final newMedication = MedicationModel(
                        id: DateTime.now().toString(),
                        name: medicationName,
                        time: medicationTime,
                        isTaken: false,
                      );
                      context.read<MedicationCubit>().addMedication(newMedication);
                      _timeController.clear();
                      _nameController.clear();
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("İlaç Başarıyla Eklendi"),
                          backgroundColor: primaryColor,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Kaydet", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNoteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Yeni Not Ekle",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkText)),
                const SizedBox(height: 20),

                // 1. BAŞLIK İÇİN TEXTFIELD (Eksikti, ekledik)
                TextField(
                  controller: _noteTitleController, // Kontrolcüyü bağladık!
                  decoration: InputDecoration(
                    labelText: "Not Başlığı",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 15),

                // 2. İÇERİK İÇİN TEXTFIELD
                TextField(
                  controller: _noteContentController, // Kontrolcüyü bağladık!
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Notunuzu buraya yazın...",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    final title = _noteTitleController.text;
                    final content = _noteContentController.text;

                    if (title.isNotEmpty) {
                      final newNote = NoteModel(
                        id: DateTime.now().toString(),
                        title: title,
                        content: content,
                        createdAt: DateTime.now(),
                      );

                      context.read<NoteCubit>().addNote(newNote);

                      _noteTitleController.clear();
                      _noteContentController.clear();
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Not kaydedildi"), backgroundColor: primaryColor),
                      );
                    } else {
                      // Eğer başlık boşsa kullanıcıya küçük bir uyarı verelim
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Lütfen bir başlık girin!"), backgroundColor: Colors.orange),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Notu Kaydet", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLifeCheckPage(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //DURUM PANELİ
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("DURUM : GÜVENDE",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 50,),

          //İYİYİM BUTONU
          GestureDetector(
            onTap: () => context.read<LifeCheckCubit>().resetCheck(),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  )
                ],
                border: Border.all(color: primaryColor,width: 8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite,size: 60, color: Colors.redAccent),
                    SizedBox(height: 10),
                    Text("İYİYİM",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold,color: primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),

          //ZAMANLAYICI
          const Text("Bir Sonraki Kontrol",style: TextStyle(color: Colors.grey,fontSize: 16),
          ),
          const SizedBox(height: 10),
          BlocBuilder<LifeCheckCubit, LifeCheckState>(
            builder: (context, state) {
              // 1. Eğer sayaç çalışıyorsa saniyeyi saate çevirip yaz
              if (state is LifeCheckRunning) {
                final duration = Duration(seconds: state.remainingSeconds);
              // Saat:Dakika:Saniye formatına getiriyoruz
                String formatliZaman = "${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
                return Text(formatliZaman, style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: darkText));
              }
                // 2. Eğer süre bittiyse "TEHLİKE" yaz
              else if (state is LifeCheckAlert) {
                return const Text("DURUM KRİTİK!", style: TextStyle(fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold));
              }
                // 3. Başlangıçta 03:00:00 göster
              return const Text("03:00:00", style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: darkText));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotesPage() {
    // 1. ADIM: BlocBuilder'ı en başa koyuyoruz.
    // Bu, "Not Beyni'nden (NoteCubit) gelen haberleri dinle" demek.
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {

        // 2. ADIM: Eğer notlar yüklendiyse ve liste boş değilse
        if (state is NoteLoaded && state.notes.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final note = state.notes[index];

              // Her bir notu bir "Kart" (Card) içinde gösteriyoruz
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(note.content),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      // SİLME BUTONU: Cubit'e "bu ID'li notu sil" diyoruz
                      context.read<NoteCubit>().deleteNote(note.id);
                    },
                  ),
                ),
              );
            },
          );
        }

        // 3. ADIM: Eğer henüz hiç not eklenmemişse (Senin eski kodun buraya geliyor)
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notes_rounded, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                "Henüz bir not eklenmemiş.\nSağ alttaki butondan ekleyebilirsiniz.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ],
          ),
        );
      },
    );
  }

}