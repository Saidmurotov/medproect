class DietTable {
  final String id; // №1, №5, etc.
  final List<String> allowedUz;
  final List<String> forbiddenUz;
  final List<String> allowedRu;
  final List<String> forbiddenRu;
  final String descriptionUz;
  final String descriptionRu;

  DietTable({
    required this.id,
    required this.allowedUz,
    required this.forbiddenUz,
    required this.allowedRu,
    required this.forbiddenRu,
    required this.descriptionUz,
    required this.descriptionRu,
  });
}

class DietConstants {
  static final Map<String, String> diseaseToTable = {
    // Jigar
    'Сурункали вирусли В гепатити': '№5',
    'Сурункали вирусли С гепатити': '№5',
    'Аутоиммун гепатит': '№5',
    'Жигар ёғли гепатози': '№5',
    'Алкоголли жигар касаллиги': '№5',
    'Токсик гепатит': '№5',
    'Жигар циррози': '№5',
    'Жигар фибрози': '№5',
    'Жигар етишмовчилиги': '№5а',
    'Холангит': '№5',
    'Холецистит': '№5',
    'Жигар эхинококкози': '№5',
    
    // Oshqozon-ichak
    'Сурункали гастрит': '№1',
    'Ошқозон яра касаллиги': '№1',
    'Ўн икки бармоқ ичак яраси': '№1',
    'Гастродуоденит': '№1',
    'Рефлюкс эзофагит': '№1',
    'Энтерит': '№4',
    'Колит': '№4',
    'Энтероколит': '№4',
    'Крон касаллиги': '№4',
    'Панкреатит': '№5п',
    'Ўт-тош касаллиги': '№5',
    'Қабзият': '№3',
    'Диарея': '№4',
    'Ичак қўзғалувчанлик синдроми': '№3',

    // Endokrin
    '1-тип қандли диабет': '№9',
    '2-тип қандли диабет': '№9',
    'Семириш': '№8',
    'Метаболик синдром': '№8',
    'Гипотиреоз': '№8',
    'Гипертиреоз': '№15',
    'Тиреотоксикоз': '№15',
    'Аутоиммун тиреоидит': '№15',
    'Қандсиз диабет': '№15',
    'Иценко-Кушинг синдроми': '№8',
    'Аддисон касаллиги': '№15',
    'Подагра': '№6',
    'Диабетик нефропатия': '№7',
    'Инсулинорезистентлик': '№9',

    // Yurak-qon tomir
    'Артериал гипертензия': '№10',
    'Гипертоник касаллик': '№10',
    'Ишемик юрак касаллиги': '№10',
    'Стенокардия': '№10',
    'Миокард инфаркти': '№10и',
    'Юрак етишмовчилиги': '№10',
    'Аритмия': '№10',
    'Тахикардия': '№10',
    'Брадикардия': '№10',
    'Атеросклероз': '№10с',
    'Кардиомиопатия': '№10',
    'Миокардит': '№10',
    'Эндокардит': '№10',
    'Перикардит': '№10',
    'Варикоз касаллиги': '№10',
    'Тромбофлебит': '№10',
    'Юрак нуқсонлари': '№10',
    'Гиперлипидемия': '№10с',
    'Инсультдан кейинги ҳолат': '№10',
  };

  static final Map<String, DietTable> dietTables = {
    '№1': DietTable(
      id: '№1',
      descriptionUz: 'Ошқозон ва ичак яра касалликларида тавсия этилади.',
      descriptionRu: 'Рекомендуется при язвенной болезни желудка и кишечника.',
      allowedUz: ['Suyuq sho‘rvalar', 'Bo‘tqalar', 'Bug‘da pishgan kotlet', 'Pyure', 'Omlet'],
      forbiddenUz: ['Qovurilgan ovqat', 'Achchiq taom', 'Gazli ichimlik', 'Kofe', 'Moyli go\'sht'],
      allowedRu: ['Слизистые супы', 'Каши', 'Паровые котлеты', 'Пюре', 'Омлет'],
      forbiddenRu: ['Жареное', 'Острое', 'Газировка', 'Кофе', 'Жирное мясо'],
    ),
    '№3': DietTable(
      id: '№3',
      descriptionUz: 'Қабзиятда клетчаткага бой овқатлар тавсия қилинади.',
      descriptionRu: 'При запорах рекомендуется пища, богатая клетчаткой.',
      allowedUz: ['Sabzavotlar', 'Meva', 'Qora non', 'Kefir'],
      forbiddenUz: ['Oq non', 'Guruchli bo\'tqa', 'Qattiq choy'],
      allowedRu: ['Овощи', 'Фрукты', 'Черный хлеб', 'Кефир'],
      forbiddenRu: ['Белый хлеб', 'Рисовая каша', 'Крепкий чай'],
    ),
    '№4': DietTable(
      id: '№4',
      descriptionUz: 'Ичак касалликлаri ва диареяда енгил ҳазм бўладиган овқат.',
      descriptionRu: 'Легкоусвояемая пища при заболеваниях кишечника и диарее.',
      allowedUz: ['Guruchli suv', 'Qotirilgan non', 'Yog\'siz go\'sht buloni'],
      forbiddenUz: ['Sut', 'Yangi mevalar', 'Dukkaklilar'],
      allowedRu: ['Рисовый отвар', 'Сухари', 'Нежирный мясной бульон'],
      forbiddenRu: ['Молоко', 'Свежие фрукты', 'Бобовые'],
    ),
    '№5': DietTable(
      id: '№5',
      descriptionUz: 'Жигар ва ўт йўллари касалликларида.',
      descriptionRu: 'При заболеваниях печени и желчевыводящих путей.',
      allowedUz: ['Yog‘siz go‘sht', 'Baliq', 'Sabzavotlar', 'Bo‘tqalar', 'Sut mahsulotlari'],
      forbiddenUz: ['Yog‘li ovqat', 'Alkogol', 'Dudlangan mahsulotlar', 'Mayonez', 'Tuxum sarig\'i'],
      allowedRu: ['Нежирное мясо', 'Рыба', 'Овощи', 'Каши', 'Молочные продукты'],
      forbiddenRu: ['Жирное', 'Алкоголь', 'Копчёности', 'Майонез', 'Желток'],
    ),
    '№8': DietTable(
      id: '№8',
      descriptionUz: 'Семиришда калория чекланган парҳез.',
      descriptionRu: 'Низкокалорийная диета при ожирении.',
      allowedUz: ['Sabzavotlar', 'Kefir', 'Olma', 'Yog‘siz go‘sht'],
      forbiddenUz: ['Fastfud', 'Shirinliklar', 'Gazli ichimlik', 'Shakar'],
      allowedRu: ['Овощи', 'Кефир', 'Яблоки', 'Нежирное мясо'],
      forbiddenRu: ['Фастфуд', 'Сладости', 'Газировка', 'Сахар'],
    ),
    '№9': DietTable(
      id: '№9',
      descriptionUz: 'Қандли диабет учун углевод назорати.',
      descriptionRu: 'Контроль углеводов при сахарном диабете.',
      allowedUz: ['Sabzavotlar', 'Grechka', 'Yog‘siz go‘sht', 'Qora non'],
      forbiddenUz: ['Shakar', 'Tort', 'Konfet', 'Shirin ichimliklar', 'Oq non'],
      allowedRu: ['Овощи', 'Гречка', 'Нежирное мясо', 'Чёрный хлеб'],
      forbiddenRu: ['Сахар', 'Торты', 'Конфеты', 'Сладкие напитки', 'Белый хлеб'],
    ),
    '№10': DietTable(
      id: '№10',
      descriptionUz: 'Юрак-қон томир касалликларида.',
      descriptionRu: 'При сердечно-сосудистых заболеваниях.',
      allowedUz: ['Sabzavotlar', 'Baliq', 'Banan', 'Grechka'],
      forbiddenUz: ['Tuz', 'Qovurilgan ovqat', 'Alkogol', 'Qattiq kofe'],
      allowedRu: ['Овощи', 'Рыба', 'Банан', 'Гречка'],
      forbiddenRu: ['Соль', 'Жареное', 'Алкоголь', 'Крепкий кофе'],
    ),
    '№15': DietTable(
      id: '№15',
      descriptionUz: 'Умумий соғлом овқатланиш столи.',
      descriptionRu: 'Общий стол здорового питания.',
      allowedUz: ['Barcha sog\'lom taomlar'],
      forbiddenUz: ['Haddan tashqari yog\'li va shirin taomlar'],
      allowedRu: ['Все здоровые продукты'],
      forbiddenRu: ['Чрезмерно жирная и сладкая пища'],
    ),
  };
}
