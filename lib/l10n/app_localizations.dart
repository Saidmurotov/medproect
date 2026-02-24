import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In uz, this message translates to:
  /// **'MedProect'**
  String get appTitle;

  /// No description provided for @registration.
  ///
  /// In uz, this message translates to:
  /// **'Ro\'yxatdan o\'tish'**
  String get registration;

  /// No description provided for @firstName.
  ///
  /// In uz, this message translates to:
  /// **'Ismingiz'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In uz, this message translates to:
  /// **'Familiyangiz'**
  String get lastName;

  /// No description provided for @age.
  ///
  /// In uz, this message translates to:
  /// **'Yoshingiz'**
  String get age;

  /// No description provided for @gender.
  ///
  /// In uz, this message translates to:
  /// **'Jinsingiz'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In uz, this message translates to:
  /// **'Erkak'**
  String get male;

  /// No description provided for @female.
  ///
  /// In uz, this message translates to:
  /// **'Ayol'**
  String get female;

  /// No description provided for @height.
  ///
  /// In uz, this message translates to:
  /// **'Bo\'yingiz (sm)'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In uz, this message translates to:
  /// **'Vazningiz (kg)'**
  String get weight;

  /// No description provided for @continueBtn.
  ///
  /// In uz, this message translates to:
  /// **'Davom etish'**
  String get continueBtn;

  /// No description provided for @welcome.
  ///
  /// In uz, this message translates to:
  /// **'Salom'**
  String get welcome;

  /// No description provided for @bmiTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tana vazni indeksi (BMI)'**
  String get bmiTitle;

  /// No description provided for @bmiNormal.
  ///
  /// In uz, this message translates to:
  /// **'Normal vazn'**
  String get bmiNormal;

  /// No description provided for @bmiUnderweight.
  ///
  /// In uz, this message translates to:
  /// **'Kam vazn'**
  String get bmiUnderweight;

  /// No description provided for @bmiOverweight.
  ///
  /// In uz, this message translates to:
  /// **'Ortiqcha vazn'**
  String get bmiOverweight;

  /// No description provided for @bmiObese.
  ///
  /// In uz, this message translates to:
  /// **'Semizlik'**
  String get bmiObese;

  /// No description provided for @bmiHelperNormal.
  ///
  /// In uz, this message translates to:
  /// **'Siz me\'yorda ekansiz — davom eting!'**
  String get bmiHelperNormal;

  /// No description provided for @bmiHelperUnderweight.
  ///
  /// In uz, this message translates to:
  /// **'Me\'yordan biroz past'**
  String get bmiHelperUnderweight;

  /// No description provided for @bmiHelperOverweight.
  ///
  /// In uz, this message translates to:
  /// **'Me\'yordan biroz yuqori'**
  String get bmiHelperOverweight;

  /// No description provided for @bmiHelperObese.
  ///
  /// In uz, this message translates to:
  /// **'Shifokorga murojaat qilish tavsiya etiladi'**
  String get bmiHelperObese;

  /// No description provided for @bmiRecommendation.
  ///
  /// In uz, this message translates to:
  /// **'Tavsiya: kuniga 20–30 daqiqa yurish foydali bo\'ladi.'**
  String get bmiRecommendation;

  /// No description provided for @symptoms.
  ///
  /// In uz, this message translates to:
  /// **'Simptomlar'**
  String get symptoms;

  /// No description provided for @symptomsQuestion.
  ///
  /// In uz, this message translates to:
  /// **'Bugun nimalarni sezmoqdasiz?'**
  String get symptomsQuestion;

  /// No description provided for @save.
  ///
  /// In uz, this message translates to:
  /// **'Saqlash'**
  String get save;

  /// No description provided for @home.
  ///
  /// In uz, this message translates to:
  /// **'Asosiy'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In uz, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @monthlySummary.
  ///
  /// In uz, this message translates to:
  /// **'Oylik hisobot'**
  String get monthlySummary;

  /// No description provided for @addSymptom.
  ///
  /// In uz, this message translates to:
  /// **'Simptom qo\'shish'**
  String get addSymptom;

  /// No description provided for @nausea.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'ngil aynishi'**
  String get nausea;

  /// No description provided for @constipation.
  ///
  /// In uz, this message translates to:
  /// **'Ich qotishi'**
  String get constipation;

  /// No description provided for @diarrhea.
  ///
  /// In uz, this message translates to:
  /// **'Ich ketishi'**
  String get diarrhea;

  /// No description provided for @belching.
  ///
  /// In uz, this message translates to:
  /// **'Kekirish'**
  String get belching;

  /// No description provided for @headache.
  ///
  /// In uz, this message translates to:
  /// **'Bosh og\'rig\'i'**
  String get headache;

  /// No description provided for @stomachache.
  ///
  /// In uz, this message translates to:
  /// **'Qorin og\'rig\'i'**
  String get stomachache;

  /// No description provided for @dizziness.
  ///
  /// In uz, this message translates to:
  /// **'Holsizlik'**
  String get dizziness;

  /// No description provided for @fever.
  ///
  /// In uz, this message translates to:
  /// **'Isitma'**
  String get fever;

  /// No description provided for @painLevel.
  ///
  /// In uz, this message translates to:
  /// **'Og\'riq darajasi'**
  String get painLevel;

  /// No description provided for @symptomsCount.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta simptom'**
  String symptomsCount(Object count);

  /// No description provided for @averagePain.
  ///
  /// In uz, this message translates to:
  /// **'O\'rtacha og\'riq'**
  String get averagePain;

  /// No description provided for @bmiChange.
  ///
  /// In uz, this message translates to:
  /// **'BMI o\'zgarishi'**
  String get bmiChange;

  /// No description provided for @weightChange.
  ///
  /// In uz, this message translates to:
  /// **'Vazn o\'zgarishi'**
  String get weightChange;

  /// No description provided for @login.
  ///
  /// In uz, this message translates to:
  /// **'Kirish'**
  String get login;

  /// No description provided for @register.
  ///
  /// In uz, this message translates to:
  /// **'Ro\'yxatdan o\'tish'**
  String get register;

  /// No description provided for @personalInfo.
  ///
  /// In uz, this message translates to:
  /// **'Shaxsiy ma\'lumotlar'**
  String get personalInfo;

  /// No description provided for @bodyIndicators.
  ///
  /// In uz, this message translates to:
  /// **'Tana ko\'rsatkichlari'**
  String get bodyIndicators;

  /// No description provided for @accountInfo.
  ///
  /// In uz, this message translates to:
  /// **'Hisob ma\'lumotlari'**
  String get accountInfo;

  /// No description provided for @email.
  ///
  /// In uz, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In uz, this message translates to:
  /// **'Parol'**
  String get password;

  /// No description provided for @additionalNote.
  ///
  /// In uz, this message translates to:
  /// **'Qo\'shimcha izoh'**
  String get additionalNote;

  /// No description provided for @noteHint.
  ///
  /// In uz, this message translates to:
  /// **'Boshqa simptomlar yoki izohlar...'**
  String get noteHint;

  /// No description provided for @symptomSelectError.
  ///
  /// In uz, this message translates to:
  /// **'Iltimos, kamida bitta simptomni tanlang'**
  String get symptomSelectError;

  /// No description provided for @saveSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Muvaffaqiyatli saqlandi!'**
  String get saveSuccess;

  /// No description provided for @improvements.
  ///
  /// In uz, this message translates to:
  /// **'Yaxshilanishlar'**
  String get improvements;

  /// No description provided for @symptomsDecreased.
  ///
  /// In uz, this message translates to:
  /// **'Simptomlar kamaydi'**
  String get symptomsDecreased;

  /// No description provided for @weightDecreased.
  ///
  /// In uz, this message translates to:
  /// **'Vazn kamaydi'**
  String get weightDecreased;

  /// No description provided for @bmiImproved.
  ///
  /// In uz, this message translates to:
  /// **'BMI yaxshilandi'**
  String get bmiImproved;

  /// No description provided for @medicalDisclaimer.
  ///
  /// In uz, this message translates to:
  /// **'Bu ma\'lumotlar faqat informatsion maqsadda. Shifokor bilan maslahatlashishni tavsiya qilamiz.'**
  String get medicalDisclaimer;

  /// No description provided for @goodProgress.
  ///
  /// In uz, this message translates to:
  /// **'yaxshi'**
  String get goodProgress;

  /// No description provided for @yourBmiLabel.
  ///
  /// In uz, this message translates to:
  /// **'Sizning BMI'**
  String get yourBmiLabel;

  /// No description provided for @trackHealth.
  ///
  /// In uz, this message translates to:
  /// **'Sog\'ligingizni kuzating'**
  String get trackHealth;

  /// No description provided for @quickActions.
  ///
  /// In uz, this message translates to:
  /// **'Tezkor amallar'**
  String get quickActions;

  /// No description provided for @errorEmailInUse.
  ///
  /// In uz, this message translates to:
  /// **'Bu email manzilidan allaqachon foydalanilgan'**
  String get errorEmailInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In uz, this message translates to:
  /// **'Parol juda kuchsiz (kamida 6 ta belgi)'**
  String get errorWeakPassword;

  /// No description provided for @errorNetwork.
  ///
  /// In uz, this message translates to:
  /// **'Internet aloqasi mavjud emas'**
  String get errorNetwork;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In uz, this message translates to:
  /// **'Email manzili noto\'g\'ri formatda'**
  String get errorInvalidEmail;

  /// No description provided for @errorUnknown.
  ///
  /// In uz, this message translates to:
  /// **'Xatolik yuz berdi'**
  String get errorUnknown;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In uz, this message translates to:
  /// **'Email yoki parol noto\'g\'ri'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmptyFields.
  ///
  /// In uz, this message translates to:
  /// **'Iltimos, barcha maydonlarni to\'ldiring'**
  String get errorEmptyFields;

  /// No description provided for @fieldRequired.
  ///
  /// In uz, this message translates to:
  /// **'Iltimos, ma\'lumotni kiriting'**
  String get fieldRequired;

  /// No description provided for @adviceHeadache.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'proq suv iching va 15–20 daqiqa dam oling'**
  String get adviceHeadache;

  /// No description provided for @adviceStomachache.
  ///
  /// In uz, this message translates to:
  /// **'Yengil ovqatlar iste\'mol qiling va iliq choy iching'**
  String get adviceStomachache;

  /// No description provided for @adviceDizziness.
  ///
  /// In uz, this message translates to:
  /// **'Faollikni kamaytiring va ko\'proq uxlab dam oling'**
  String get adviceDizziness;

  /// No description provided for @adviceNausea.
  ///
  /// In uz, this message translates to:
  /// **'Og\'ir ovqatlardan saqlaning va kam-kamdan ovqatlaning'**
  String get adviceNausea;

  /// No description provided for @adviceFever.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'p suyuqlik iching va tana haroratini kuzatib boring'**
  String get adviceFever;

  /// No description provided for @adviceConstipation.
  ///
  /// In uz, this message translates to:
  /// **'Kletchatka va suv iste\'molini oshiring'**
  String get adviceConstipation;

  /// No description provided for @adviceDiarrhea.
  ///
  /// In uz, this message translates to:
  /// **'Gidratsiyani saqlang va yog\'li ovqatlardan saqlaning'**
  String get adviceDiarrhea;

  /// No description provided for @adviceBelching.
  ///
  /// In uz, this message translates to:
  /// **'Gazli ichimliklardan saqlaning va sekinroq ovqatlaning'**
  String get adviceBelching;

  /// No description provided for @emergencyWarning.
  ///
  /// In uz, this message translates to:
  /// **'⚠️ Tavsiya: Shifokorga murojaat qiling.'**
  String get emergencyWarning;

  /// No description provided for @symptomAdviceTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sog\'liq bo\'yicha tavsiya'**
  String get symptomAdviceTitle;

  /// No description provided for @emergencyTitle.
  ///
  /// In uz, this message translates to:
  /// **'OGOHLANTIRISH'**
  String get emergencyTitle;

  /// No description provided for @adviceTitle.
  ///
  /// In uz, this message translates to:
  /// **'TIBBIY TAVSIYA'**
  String get adviceTitle;

  /// No description provided for @emailValid.
  ///
  /// In uz, this message translates to:
  /// **'Email manzili to\'g\'ri'**
  String get emailValid;

  /// No description provided for @emailInvalid.
  ///
  /// In uz, this message translates to:
  /// **'Email manzili noto\'g\'ri'**
  String get emailInvalid;

  /// No description provided for @passwordWeak.
  ///
  /// In uz, this message translates to:
  /// **'Kuchsiz'**
  String get passwordWeak;

  /// No description provided for @passwordMedium.
  ///
  /// In uz, this message translates to:
  /// **'O\'rtacha'**
  String get passwordMedium;

  /// No description provided for @passwordStrong.
  ///
  /// In uz, this message translates to:
  /// **'Kuchli'**
  String get passwordStrong;

  /// No description provided for @noAccount.
  ///
  /// In uz, this message translates to:
  /// **'Hisobingiz yo\'qmi?  '**
  String get noAccount;

  /// No description provided for @medications.
  ///
  /// In uz, this message translates to:
  /// **'Dorilar'**
  String get medications;

  /// No description provided for @addMedication.
  ///
  /// In uz, this message translates to:
  /// **'Dori qo\'shish'**
  String get addMedication;

  /// No description provided for @editMedication.
  ///
  /// In uz, this message translates to:
  /// **'Tahrirlash'**
  String get editMedication;

  /// No description provided for @medName.
  ///
  /// In uz, this message translates to:
  /// **'Nomi'**
  String get medName;

  /// No description provided for @medNameHint.
  ///
  /// In uz, this message translates to:
  /// **'Masalan, Paratsetamol'**
  String get medNameHint;

  /// No description provided for @dosage.
  ///
  /// In uz, this message translates to:
  /// **'Dozirovka'**
  String get dosage;

  /// No description provided for @dosageHint.
  ///
  /// In uz, this message translates to:
  /// **'Masalan, 500 mg'**
  String get dosageHint;

  /// No description provided for @schedule.
  ///
  /// In uz, this message translates to:
  /// **'Reja'**
  String get schedule;

  /// No description provided for @daily.
  ///
  /// In uz, this message translates to:
  /// **'Har kuni'**
  String get daily;

  /// No description provided for @customDays.
  ///
  /// In uz, this message translates to:
  /// **'Kunlarni tanlash'**
  String get customDays;

  /// No description provided for @prn.
  ///
  /// In uz, this message translates to:
  /// **'Zarurat bo\'lganda'**
  String get prn;

  /// No description provided for @reminders.
  ///
  /// In uz, this message translates to:
  /// **'Eslatmalar'**
  String get reminders;

  /// No description provided for @remindersDisabled.
  ///
  /// In uz, this message translates to:
  /// **'Eslatmalar o\'chirilgan'**
  String get remindersDisabled;

  /// No description provided for @setupNotifications.
  ///
  /// In uz, this message translates to:
  /// **'Bildirishnomalarni sozlash'**
  String get setupNotifications;

  /// No description provided for @notificationPermissionBanner.
  ///
  /// In uz, this message translates to:
  /// **'Takroriy eslatmalar uchun bildirishnomalarni sozlang'**
  String get notificationPermissionBanner;

  /// No description provided for @todaySchedule.
  ///
  /// In uz, this message translates to:
  /// **'Bugungi reja'**
  String get todaySchedule;

  /// No description provided for @allMedications.
  ///
  /// In uz, this message translates to:
  /// **'Mening dorilarim'**
  String get allMedications;

  /// No description provided for @taken.
  ///
  /// In uz, this message translates to:
  /// **'Qabul qilindi'**
  String get taken;

  /// No description provided for @notTaken.
  ///
  /// In uz, this message translates to:
  /// **'Qabul qilinmadi'**
  String get notTaken;

  /// No description provided for @selectTime.
  ///
  /// In uz, this message translates to:
  /// **'Vaqtni tanlang'**
  String get selectTime;

  /// No description provided for @addTime.
  ///
  /// In uz, this message translates to:
  /// **'Vaqt qo\'shish'**
  String get addTime;

  /// No description provided for @mon.
  ///
  /// In uz, this message translates to:
  /// **'Du'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In uz, this message translates to:
  /// **'Se'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In uz, this message translates to:
  /// **'Chor'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In uz, this message translates to:
  /// **'Pay'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In uz, this message translates to:
  /// **'Ju'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In uz, this message translates to:
  /// **'Shan'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In uz, this message translates to:
  /// **'Yak'**
  String get sun;

  /// No description provided for @confirmDelete.
  ///
  /// In uz, this message translates to:
  /// **'Ushbu ma\'lumotlarni o\'chirishga ishonchingiz komilmi?'**
  String get confirmDelete;

  /// No description provided for @delete.
  ///
  /// In uz, this message translates to:
  /// **'O\'chirish'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get cancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
