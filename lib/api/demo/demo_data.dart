import 'package:diary_app/models/index.dart';

/// Данные демо-режима: 9 «Б» класс, пятидневка.

const demoClassId = 91;

const demoUser = FullUser(
  firstName: 'Алексей',
  lastName: 'Миронов',
  nickname: 'alexey',
  userId: 1,
  role: 'STUDENT',
  classId: demoClassId,
  login: 'demo@diary-school.ru',
  schoolId: 47,
);

const classmates = [
  SmallUser(firstName: 'Анна', lastName: 'Смирнова', login: 'anna', userId: 2, role: 'STUDENT'),
  SmallUser(firstName: 'Максим', lastName: 'Козлов', login: 'max', userId: 3, role: 'STUDENT'),
  SmallUser(firstName: 'Дарья', lastName: 'Волкова', login: 'dasha', userId: 4, role: 'STUDENT'),
  SmallUser(firstName: 'Егор', lastName: 'Новиков', login: 'egor', userId: 5, role: 'STUDENT'),
];

/// Звонки: начало и конец каждого урока.
const _bells = [
  ('08:30', '09:15'),
  ('09:25', '10:10'),
  ('10:25', '11:10'),
  ('11:30', '12:15'),
  ('12:30', '13:15'),
  ('13:25', '14:10'),
];

class _Subject {
  const _Subject(this.id, this.name, this.office, this.tasks);

  final int id;
  final String name;
  final String office;
  final List<String> tasks;
}

const _algebra = _Subject(1, 'Алгебра', 'каб. 301', [
  '№ 312, 315, 318',
  'Повторить формулы сокращённого умножения, № 241 (а, в)',
  'Контрольные вопросы на стр. 94, № 356',
]);
const _geometry = _Subject(2, 'Геометрия', 'каб. 301', [
  '№ 567, 569; выучить теорему Пифагора',
  'Задачи 3–5 из карточки',
  '§ 12, вопросы 1–6 устно, № 612',
]);
const _russian = _Subject(3, 'Русский язык', 'каб. 214', [
  'Упр. 245, выучить правило на стр. 112',
  'Упр. 251: списать, расставить знаки препинания',
  'Подготовиться к словарному диктанту, стр. 140–141',
]);
const _literature = _Subject(4, 'Литература', 'каб. 214', [
  'Прочитать «Капитанскую дочку», главы 5–7',
  'Выучить наизусть «Я памятник себе воздвиг нерукотворный…»',
  'Письменно ответить на вопрос 4 на стр. 186',
]);
const _english = _Subject(5, 'Английский язык', 'каб. 108', [
  'Workbook p. 34, ex. 2–4; выучить слова Unit 3',
  'Student’s Book p. 41, ex. 6 письменно',
  'Рассказ о своём хобби, 10–12 предложений',
]);
const _history = _Subject(6, 'История', 'каб. 207', [
  '§ 14, письменно ответить на вопросы 1–4',
  '§ 15, заполнить таблицу «Реформы Александра II»',
  'Подготовить сообщение о Крымской войне',
]);
const _society = _Subject(7, 'Обществознание', 'каб. 207', [
  '§ 6, эссе по одной из цитат',
  '§ 7, вопросы в рубрике «Проверим себя»',
]);
const _physics = _Subject(8, 'Физика', 'каб. 312', [
  '§ 22, упр. 18 (1–3)',
  '§ 23, оформить вывод к лабораторной работе № 4',
  'Задачи 1–4 из сборника Лукашика, стр. 52',
]);
const _chemistry = _Subject(9, 'Химия', 'каб. 315', [
  '§ 9, задачи 2 и 3 после параграфа',
  'Уравнения реакций из упр. 5 на стр. 48',
  'Выучить таблицу растворимости, первые две строки',
]);
const _biology = _Subject(10, 'Биология', 'каб. 210', [
  '§ 17, сообщение о строении клетки',
  '§ 18, зарисовать схему митоза',
  'Вопросы 1–5 на стр. 76',
]);
const _geography = _Subject(11, 'География', 'каб. 205', [
  '§ 11, контурная карта, стр. 8',
  '§ 12, выучить крупнейшие города Поволжья',
]);
const _informatics = _Subject(12, 'Информатика', 'каб. 401', [
  'Решить задачи 3–5 на Python из презентации',
  'Программа поиска максимума в списке',
]);
const _pe = _Subject(13, 'Физкультура', 'спортзал', []);
const _obzr = _Subject(14, 'ОБЗР', 'каб. 112', [
  '§ 4, вопросы после параграфа',
  'Памятка «Действия при пожаре»',
]);
const _statistics = _Subject(15, 'Вероятность и статистика', 'каб. 301', [
  '№ 145, 147, 150',
  'Диаграмма по данным из упр. 152',
]);

const _week = [
  [_russian, _algebra, _english, _history, _physics, _literature],
  [_geometry, _chemistry, _russian, _biology, _pe, _informatics],
  [_algebra, _english, _literature, _geography, _society, _obzr],
  [_physics, _russian, _algebra, _history, _biology, _statistics],
  [_geometry, _english, _chemistry, _literature, _pe, _russian],
];

final List<Timetable> demoTimetables = [
  for (var day = 1; day <= 7; day++)
    Timetable(weekOfDay: day, lessons: [
      if (day <= _week.length)
        for (final (i, subject) in _week[day - 1].indexed)
          Lesson(
            lessonId: day * 10 + i,
            classId: demoClassId,
            weekOfDay: day,
            index: i + 1,
            office: subject.office,
            timeBegin: _bells[i].$1,
            timeEnd: _bells[i].$2,
            subjectId: subject.id,
            teacherId: 100 + subject.id,
            subject: Subject(subjectId: subject.id, discipline: subject.name),
          ),
    ]),
];

final _subjects = {
  for (final day in _week)
    for (final subject in day) subject.id: subject,
};

/// Государственные праздники, когда школа не работает (месяц, день).
const _holidays = {
  (1, 1): 'Новогодние каникулы',
  (1, 2): 'Новогодние каникулы',
  (1, 3): 'Новогодние каникулы',
  (1, 4): 'Новогодние каникулы',
  (1, 5): 'Новогодние каникулы',
  (1, 6): 'Новогодние каникулы',
  (1, 7): 'Рождество Христово',
  (1, 8): 'Новогодние каникулы',
  (2, 23): 'День защитника Отечества',
  (3, 8): 'Международный женский день',
  (5, 1): 'Праздник Весны и Труда',
  (5, 9): 'День Победы',
  (6, 12): 'День России',
  (11, 4): 'День народного единства',
};

String? holidayOn(DateTime date) => _holidays[(date.month, date.day)];

const _notes = [
  'Будет самостоятельная по этой теме, лучше повторить',
  'Тетради сдаём на проверку в начале урока',
  'Можно сдать до пятницы',
  'Ещё выучить определения из конспекта',
];

/// Типографика: не переносим «140–141» по тире и не отрываем номер
/// от «стр.», «№», «§».
String _noBreak(String text) => text
    .replaceAllMapped(RegExp(r'(\w)–(\w)'), (m) => '${m[1]}\u2060–\u2060${m[2]}')
    .replaceAllMapped(
      RegExp(r'(стр\.|упр\.|гл\.|№|§|p\.|ex\.) '),
      (m) => '${m[1]}\u00A0',
    );

/// Детерминированный «случайный» номер, чтобы задания не менялись
/// между запусками.
int _seed(DateTime date, int salt) =>
    (date.year * 372 + date.month * 31 + date.day) * 31 + salt;

/// Общие задания на урок: из электронного дневника (бот Тоби)
/// и заметки одноклассников.
List<Homework> sharedHomeworks(DateTime date, String dateKey, Lesson lesson) {
  final subject = _subjects[lesson.subjectId];
  if (subject == null || subject.tasks.isEmpty) return const [];
  final seed = _seed(date, lesson.subjectId);
  final id = seed * 10;
  final classmate = classmates[seed % classmates.length];
  return [
    Homework(
      homeworkId: id,
      source: Homework.sourceBot,
      isPublic: true,
      date: dateKey,
      lessonId: lesson.lessonId,
      taskId: id,
      task: Task(taskId: id, text: _noBreak(subject.tasks[seed % subject.tasks.length])),
    ),
    if (seed % 3 != 0)
      Homework(
        homeworkId: id + 1,
        authorId: classmate.userId,
        author: classmate,
        source: 'USER',
        isPublic: true,
        date: dateKey,
        lessonId: lesson.lessonId,
        taskId: id + 1,
        task: Task(taskId: id + 1, text: _notes[seed % _notes.length]),
      ),
  ];
}
