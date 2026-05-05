// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'DGI Health';

  @override
  String get registration => 'Регистрация';

  @override
  String get firstName => 'Ваше имя';

  @override
  String get lastName => 'Ваша фамилия';

  @override
  String get age => 'Ваш возраст';

  @override
  String get gender => 'Ваш пол';

  @override
  String get male => 'Мужчина';

  @override
  String get female => 'Женщина';

  @override
  String get height => 'Ваш рост (см)';

  @override
  String get weight => 'Ваш вес (кг)';

  @override
  String get continueBtn => 'Продолжить';

  @override
  String get welcome => 'Привет';

  @override
  String get bmiTitle => 'Индекс массы тела (ИМТ)';

  @override
  String get bmiNormal => 'Нормальный вес';

  @override
  String get bmiUnderweight => 'Дефицит веса';

  @override
  String get bmiOverweight => 'Избыточный вес';

  @override
  String get bmiObese => 'Ожирение';

  @override
  String get bmiHelperNormal => 'Вы в норме — продолжайте!';

  @override
  String get bmiHelperUnderweight => 'Немного ниже нормы';

  @override
  String get bmiHelperOverweight => 'Немного выше нормы';

  @override
  String get bmiHelperObese => 'Рекомендуется обратиться к врачу';

  @override
  String get bmiRecommendation =>
      'Рекомендация: ходьба 20–30 минут в день полезна.';

  @override
  String get symptoms => 'Симптомы';

  @override
  String get symptomsQuestion => 'Что вы чувствуете сегодня?';

  @override
  String get save => 'Сохранить';

  @override
  String get home => 'Главная';

  @override
  String get profile => 'Профиль';

  @override
  String get monthlySummary => 'Месячный отчет';

  @override
  String get addSymptom => 'Добавить симптом';

  @override
  String get nausea => 'Тошнота';

  @override
  String get constipation => 'Запор';

  @override
  String get diarrhea => 'Диарея';

  @override
  String get belching => 'Отрыжка';

  @override
  String get headache => 'Головная боль';

  @override
  String get stomachache => 'Боль в животе';

  @override
  String get dizziness => 'Головокружение';

  @override
  String get fever => 'Температура';

  @override
  String get painLevel => 'Уровень боли';

  @override
  String symptomsCount(Object count) {
    return '$count симптомов';
  }

  @override
  String get averagePain => 'Средняя боль';

  @override
  String get bmiChange => 'Изменение ИМТ';

  @override
  String get weightChange => 'Изменение веса';

  @override
  String get login => 'Вход';

  @override
  String get register => 'Регистрация';

  @override
  String get personalInfo => 'Персональные данные';

  @override
  String get bodyIndicators => 'Показатели тела';

  @override
  String get accountInfo => 'Данные аккаунта';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get additionalNote => 'Дополнительный комментарий';

  @override
  String get noteHint => 'Другие симптомы или комментарии...';

  @override
  String get symptomSelectError => 'Пожалуйста, выберите хотя бы один симптом';

  @override
  String get saveSuccess => 'Успешно сохранено!';

  @override
  String get improvements => 'Улучшения';

  @override
  String get symptomsDecreased => 'Симптомы уменьшились';

  @override
  String get weightDecreased => 'Вес уменьшился';

  @override
  String get bmiImproved => 'ИМТ улучшился';

  @override
  String get medicalDisclaimer =>
      'Эта информация носит ознакомительный характер. Рекомендуем проконсультироваться с врачом.';

  @override
  String get goodProgress => 'хорошо';

  @override
  String get yourBmiLabel => 'Ваш ИМТ';

  @override
  String get trackHealth => 'Шаг к здоровой жизни';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get errorEmailInUse => 'Этот email уже используется';

  @override
  String get errorWeakPassword => 'Слишком слабый пароль (минимум 6 символов)';

  @override
  String get errorNetwork => 'Нет соединения с интернетом';

  @override
  String get errorInvalidEmail => 'Неверный формат email';

  @override
  String get errorUnknown => 'Произошла ошибка';

  @override
  String get errorInvalidCredentials => 'Неверный email или пароль';

  @override
  String get errorEmptyFields => 'Пожалуйста, заполните все поля';

  @override
  String get fieldRequired => 'Пожалуйста, введите данные';

  @override
  String get adviceHeadache => 'Пейте больше воды и отдохните 15–20 минут';

  @override
  String get adviceStomachache => 'Ешьте легкую пищу и пейте теплый чай';

  @override
  String get adviceDizziness => 'Снизьте активность и больше спите';

  @override
  String get adviceNausea =>
      'Избегайте тяжелой пищи и ешьте небольшими порциями';

  @override
  String get adviceFever => 'Пейте жидкость и следите за температурой тела';

  @override
  String get adviceConstipation => 'Увеличьте потребление клетчатки и воды';

  @override
  String get adviceDiarrhea => 'Пейте больше воды и избегайте жирной пищи';

  @override
  String get adviceBelching =>
      'Избегайте газированных напитков и ешьте медленнее';

  @override
  String get emergencyWarning => '⚠️ Рекомендация: Обратитесь к врачу.';

  @override
  String get symptomAdviceTitle => 'Совет по здоровью';

  @override
  String get emergencyTitle => 'ПРЕДУПРЕЖДЕНИЕ';

  @override
  String get adviceTitle => 'МЕДИЦИНСКАЯ РЕКОМЕНДАЦИЯ';

  @override
  String get emailValid => 'Email верный';

  @override
  String get emailInvalid => 'Неверный формат email';

  @override
  String get passwordWeak => 'Слабый';

  @override
  String get passwordMedium => 'Средний';

  @override
  String get passwordStrong => 'Сильный';

  @override
  String get noAccount => 'Нет аккаунта?  ';

  @override
  String get medications => 'Лекарства';

  @override
  String get addMedication => 'Добавить лекарство';

  @override
  String get editMedication => 'Редактировать';

  @override
  String get medName => 'Название';

  @override
  String get medNameHint => 'Напр., Парацетамол';

  @override
  String get dosage => 'Дозировка';

  @override
  String get dosageHint => 'Напр., 500 мг';

  @override
  String get schedule => 'Расписание';

  @override
  String get daily => 'Ежедневно';

  @override
  String get customDays => 'Выбрать дни';

  @override
  String get prn => 'По необходимости';

  @override
  String get reminders => 'Напоминания';

  @override
  String get remindersDisabled => 'Напоминания выключены';

  @override
  String get setupNotifications => 'Настроить уведомления';

  @override
  String get notificationPermissionBanner =>
      'Повторные напоминания доступны после настройки уведомлений';

  @override
  String get todaySchedule => 'Расписание на сегодня';

  @override
  String get allMedications => 'Мои лекарства';

  @override
  String get taken => 'Принято';

  @override
  String get notTaken => 'Не принято';

  @override
  String get selectTime => 'Выберите время';

  @override
  String get addTime => 'Добавить время';

  @override
  String get mon => 'Пн';

  @override
  String get tue => 'Вт';

  @override
  String get wed => 'Ср';

  @override
  String get thu => 'Чт';

  @override
  String get fri => 'Пт';

  @override
  String get sat => 'Сб';

  @override
  String get sun => 'Вс';

  @override
  String get confirmDelete => 'Вы уверены, что хотите удалить эти данные?';

  @override
  String get delete => 'Удалить';

  @override
  String get cancel => 'Отмена';

  @override
  String get loginSubtitle => 'Шаг к здоровой жизни';

  @override
  String get errorUserNotFound => 'Пользователь не найден';

  @override
  String get errorWrongPassword => 'Неверный пароль';

  @override
  String get errorTooManyRequests => 'Слишком много попыток. Попробуйте позже';

  @override
  String get breathlessnessSymptom => 'Одышка';

  @override
  String get chestPainSymptom => 'Боль в груди';

  @override
  String get offlineBanner => 'Автономный режим';

  @override
  String get emergencyAdvice => 'СРОЧНАЯ ПОМОЩЬ';

  @override
  String get generalAdvice => 'СОВЕТ';

  @override
  String get emergencyMsg =>
      'ВНИМАНИЕ: Срочное состояние! Немедленно позвоните 103 или обратитесь в ближайшую больницу.';

  @override
  String highPainMsg(Object level) {
    return 'Уровень боли очень высокий ($level/10). Пожалуйста, свяжитесь с врачом.';
  }

  @override
  String get seriousSymptomsMsg =>
      '⚠️ Обнаружено несколько серьезных симптомов. Рекомендуется обратиться к врачу.';

  @override
  String get monitorHealthMsg =>
      'Продолжайте следить за своим состоянием. Если симптомы усилятся, обратитесь к врачу.';

  @override
  String get generalAdviceHeadache =>
      'Постарайтесь отдохнуть в тихой и темной комнате. Пейте больше воды.';

  @override
  String get generalAdviceStomachache =>
      'Ешьте легкую пищу и пейте теплый чай.';

  @override
  String get generalAdviceDizziness => 'Снизьте активность и больше отдыхайте.';

  @override
  String get generalAdviceNausea =>
      'Избегайте тяжелой пищи и ешьте небольшими порциями.';

  @override
  String get generalAdviceFever =>
      'Пейте больше жидкости и отдыхайте. Следите за температурой тела.';

  @override
  String get generalAdviceConstipation =>
      'Увеличьте потребление клетчатки и воды.';

  @override
  String get generalAdviceDiarrhea =>
      'Ешьте легкую пищу и поддерживайте водный баланс.';

  @override
  String get generalAdviceBelching =>
      'Избегайте газированных напитков и ешьте медленнее.';

  @override
  String get foodCamera => 'Калории';
}
