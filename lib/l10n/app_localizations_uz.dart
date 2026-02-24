// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'MedProect';

  @override
  String get registration => 'Ro\'yxatdan o\'tish';

  @override
  String get firstName => 'Ismingiz';

  @override
  String get lastName => 'Familiyangiz';

  @override
  String get age => 'Yoshingiz';

  @override
  String get gender => 'Jinsingiz';

  @override
  String get male => 'Erkak';

  @override
  String get female => 'Ayol';

  @override
  String get height => 'Bo\'yingiz (sm)';

  @override
  String get weight => 'Vazningiz (kg)';

  @override
  String get continueBtn => 'Davom etish';

  @override
  String get welcome => 'Salom';

  @override
  String get bmiTitle => 'Tana vazni indeksi (BMI)';

  @override
  String get bmiNormal => 'Normal vazn';

  @override
  String get bmiUnderweight => 'Kam vazn';

  @override
  String get bmiOverweight => 'Ortiqcha vazn';

  @override
  String get bmiObese => 'Semizlik';

  @override
  String get bmiHelperNormal => 'Siz me\'yorda ekansiz — davom eting!';

  @override
  String get bmiHelperUnderweight => 'Me\'yordan biroz past';

  @override
  String get bmiHelperOverweight => 'Me\'yordan biroz yuqori';

  @override
  String get bmiHelperObese => 'Shifokorga murojaat qilish tavsiya etiladi';

  @override
  String get bmiRecommendation =>
      'Tavsiya: kuniga 20–30 daqiqa yurish foydali bo\'ladi.';

  @override
  String get symptoms => 'Simptomlar';

  @override
  String get symptomsQuestion => 'Bugun nimalarni sezmoqdasiz?';

  @override
  String get save => 'Saqlash';

  @override
  String get home => 'Asosiy';

  @override
  String get profile => 'Profil';

  @override
  String get monthlySummary => 'Oylik hisobot';

  @override
  String get addSymptom => 'Simptom qo\'shish';

  @override
  String get nausea => 'Ko\'ngil aynishi';

  @override
  String get constipation => 'Ich qotishi';

  @override
  String get diarrhea => 'Ich ketishi';

  @override
  String get belching => 'Kekirish';

  @override
  String get headache => 'Bosh og\'rig\'i';

  @override
  String get stomachache => 'Qorin og\'rig\'i';

  @override
  String get dizziness => 'Holsizlik';

  @override
  String get fever => 'Isitma';

  @override
  String get painLevel => 'Og\'riq darajasi';

  @override
  String symptomsCount(Object count) {
    return '$count ta simptom';
  }

  @override
  String get averagePain => 'O\'rtacha og\'riq';

  @override
  String get bmiChange => 'BMI o\'zgarishi';

  @override
  String get weightChange => 'Vazn o\'zgarishi';

  @override
  String get login => 'Kirish';

  @override
  String get register => 'Ro\'yxatdan o\'tish';

  @override
  String get personalInfo => 'Shaxsiy ma\'lumotlar';

  @override
  String get bodyIndicators => 'Tana ko\'rsatkichlari';

  @override
  String get accountInfo => 'Hisob ma\'lumotlari';

  @override
  String get email => 'Email';

  @override
  String get password => 'Parol';

  @override
  String get additionalNote => 'Qo\'shimcha izoh';

  @override
  String get noteHint => 'Boshqa simptomlar yoki izohlar...';

  @override
  String get symptomSelectError => 'Iltimos, kamida bitta simptomni tanlang';

  @override
  String get saveSuccess => 'Muvaffaqiyatli saqlandi!';

  @override
  String get improvements => 'Yaxshilanishlar';

  @override
  String get symptomsDecreased => 'Simptomlar kamaydi';

  @override
  String get weightDecreased => 'Vazn kamaydi';

  @override
  String get bmiImproved => 'BMI yaxshilandi';

  @override
  String get medicalDisclaimer =>
      'Bu ma\'lumotlar faqat informatsion maqsadda. Shifokor bilan maslahatlashishni tavsiya qilamiz.';

  @override
  String get goodProgress => 'yaxshi';

  @override
  String get yourBmiLabel => 'Sizning BMI';

  @override
  String get trackHealth => 'Sog\'ligingizni kuzating';

  @override
  String get quickActions => 'Tezkor amallar';

  @override
  String get errorEmailInUse => 'Bu email manzilidan allaqachon foydalanilgan';

  @override
  String get errorWeakPassword => 'Parol juda kuchsiz (kamida 6 ta belgi)';

  @override
  String get errorNetwork => 'Internet aloqasi mavjud emas';

  @override
  String get errorInvalidEmail => 'Email manzili noto\'g\'ri formatda';

  @override
  String get errorUnknown => 'Xatolik yuz berdi';

  @override
  String get errorInvalidCredentials => 'Email yoki parol noto\'g\'ri';

  @override
  String get errorEmptyFields => 'Iltimos, barcha maydonlarni to\'ldiring';

  @override
  String get fieldRequired => 'Iltimos, ma\'lumotni kiriting';

  @override
  String get adviceHeadache => 'Ko\'proq suv iching va 15–20 daqiqa dam oling';

  @override
  String get adviceStomachache =>
      'Yengil ovqatlar iste\'mol qiling va iliq choy iching';

  @override
  String get adviceDizziness =>
      'Faollikni kamaytiring va ko\'proq uxlab dam oling';

  @override
  String get adviceNausea =>
      'Og\'ir ovqatlardan saqlaning va kam-kamdan ovqatlaning';

  @override
  String get adviceFever =>
      'Ko\'p suyuqlik iching va tana haroratini kuzatib boring';

  @override
  String get adviceConstipation => 'Kletchatka va suv iste\'molini oshiring';

  @override
  String get adviceDiarrhea =>
      'Gidratsiyani saqlang va yog\'li ovqatlardan saqlaning';

  @override
  String get adviceBelching =>
      'Gazli ichimliklardan saqlaning va sekinroq ovqatlaning';

  @override
  String get emergencyWarning => '⚠️ Tavsiya: Shifokorga murojaat qiling.';

  @override
  String get symptomAdviceTitle => 'Sog\'liq bo\'yicha tavsiya';

  @override
  String get emergencyTitle => 'OGOHLANTIRISH';

  @override
  String get adviceTitle => 'TIBBIY TAVSIYA';

  @override
  String get emailValid => 'Email manzili to\'g\'ri';

  @override
  String get emailInvalid => 'Email manzili noto\'g\'ri';

  @override
  String get passwordWeak => 'Kuchsiz';

  @override
  String get passwordMedium => 'O\'rtacha';

  @override
  String get passwordStrong => 'Kuchli';

  @override
  String get noAccount => 'Hisobingiz yo\'qmi?  ';

  @override
  String get medications => 'Dorilar';

  @override
  String get addMedication => 'Dori qo\'shish';

  @override
  String get editMedication => 'Tahrirlash';

  @override
  String get medName => 'Nomi';

  @override
  String get medNameHint => 'Masalan, Paratsetamol';

  @override
  String get dosage => 'Dozirovka';

  @override
  String get dosageHint => 'Masalan, 500 mg';

  @override
  String get schedule => 'Reja';

  @override
  String get daily => 'Har kuni';

  @override
  String get customDays => 'Kunlarni tanlash';

  @override
  String get prn => 'Zarurat bo\'lganda';

  @override
  String get reminders => 'Eslatmalar';

  @override
  String get remindersDisabled => 'Eslatmalar o\'chirilgan';

  @override
  String get setupNotifications => 'Bildirishnomalarni sozlash';

  @override
  String get notificationPermissionBanner =>
      'Takroriy eslatmalar uchun bildirishnomalarni sozlang';

  @override
  String get todaySchedule => 'Bugungi reja';

  @override
  String get allMedications => 'Mening dorilarim';

  @override
  String get taken => 'Qabul qilindi';

  @override
  String get notTaken => 'Qabul qilinmadi';

  @override
  String get selectTime => 'Vaqtni tanlang';

  @override
  String get addTime => 'Vaqt qo\'shish';

  @override
  String get mon => 'Du';

  @override
  String get tue => 'Se';

  @override
  String get wed => 'Chor';

  @override
  String get thu => 'Pay';

  @override
  String get fri => 'Ju';

  @override
  String get sat => 'Shan';

  @override
  String get sun => 'Yak';

  @override
  String get confirmDelete =>
      'Ushbu ma\'lumotlarni o\'chirishga ishonchingiz komilmi?';

  @override
  String get delete => 'O\'chirish';

  @override
  String get cancel => 'Bekor qilish';
}
