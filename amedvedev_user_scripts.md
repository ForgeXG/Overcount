# Арсений Медведев - "Overcount — математическая игра"
# Пользовательские сценарии

### Группа: 10 - И - 2
### Электронная почта: arsmedvedeffc@gmail.com
### VK: www.vk.com/forgexv


### [ Сценарий 1 - Установка и запуск игры ]

1. Пользователь загружает Overcount с itch.io
2. Пользователь запускает .exe файл
3. Пользователь видит заставку
4. Пользователю показывается меню с различными опциями
5. Пользователь нажимает кнопку обучения: см. далее Сценарий 2
6. Пользователь нажимает кнопку кампании: см. далее Сценарий 3
7. Пользователь нажимает кнопку настроек: см. далее Сценарий 4
8. Пользователь нажимает кнопку выхода

### [ Сценарий 2 - Обучение ]

1. Загружается первый уровень (далее — 1-1)
2. На 1-1 пользователь знакомится с управлением игры через текст на экране
3. Также в 1-1 пользователь знакомится с UI игры во время прохождения
4. UI игры состоит из нескольких элементов:
5. Шкалы: здоровья, перезарядки, энергии и очков, заработанных на этом уровне
6. Доп. информация: числовые данные такие как FPS (кадры в секунду) и время, затраченное на уровень (для скоростного прохождения)
7. Меню паузы: настройки звуков и музыки, возможность выйти или перезапустить уровень
8. В результате тестирования несколькими участниками выяснилось, что среднее время прохождения 1-1 — около 10 минут
9. Следовательно, большинство уровней будут схожими по длине.
10. Однако, если проходить любой уровень на скорость, зная весь маршрут, в среднем время сокращается до 3 минут
11. На уровне появляются следующие базовые механики:
12. Основное движение (WASD)
13. Бег с 3 стадиями скорости (Shift + A/D)
14. Бег по стене / прыжки от стен (Shift + A/D + W)
15. Замки, которые взламываются решением примера и восстаналивают здоровье в зависимости от скорости решения: см. далее Сценарий 5
16. Монетки, которые можно собирать для получения очков
17. Первый враг — "1", который просто скользит в сторону игрока и уничтожается одним ударом
18. Порталы
19. Двоичные блоки, через которые можно или нельзя проходить (0 или 1)
20. Чекпоинты

### [ Сценарий 3 - Кампания ]

1. Кампания представляет собой карту наподобие метро, со станциями-уровнями, которые постепенно открываются.
2. В большинстве уровней есть следующий геймплейный цикл:
3. Пользователь знакомится с новой игровой и/или математической идеей/объектом в простейшей форме, например:
4. Чисто математические: степени, корни, быстрое умножение
5. Чисто игровые: переключатель ON/OFF для двоичных блоков, пила, порталы
6. Смешанные: параболическое оружие, стреляющее по соответствующей траектории и настраиваемое мышью
7. Пользователь использует многократно эту механику, чтобы добраться до конца уровня, но по пути ему иногда встречаются новые враги.
8. Когда пользователь доходит до последнего примера и решает его, активируется таймер (везде разное время, но в среднем 4 минуты)
9. Таймер сигнализирует о том, что нужно бежать в самое начало уровня, при этом путь (а также музыка) обратно изменяется.
10. Если пользователь вовремя доберётся обратно до начала уровня, уровень считается пройденным.
11. Уровни всегда можно проходить сколько угодно раз для повторения и оттачивания механик.
12. Но есть и другие типы уровней:
13. Автоскроллеры: камера движется сама по себе, а не за игроком, следовательно игра намеренно становится сложнее, однако такие уровни проходятся быстрее.
14. Босс-битвы: игроку на специальной арене даётся один сильный враг — одно из основных понятий математики (0, X, e, и т.д.).

### [ Сценарий 4 - Настройки ]

1. В настройках предоставляются следующие опции:
2. Изменение цвета своего персонажа
3. Сохранение/загрузка/сброс данных сохранения
4. Громкость музыки
5. Громкость звуковых эффектов
6. Уровни сложности (Лёгкий/Обычный/Сложный/Экстремальный)
7. Полный сброс

### [ Сценарий 5 - Математическая составляющая ]

1. Пользователь изучает новую тему, используя таблички и замки на уровнях:
2. Пример темы — быстрое умножение
3. На первой табличке пользователь видит самый простой пример быстрого умножения — умножение на 10, или дописывание нуля.
4. Встречается первый замок с соответствующим примером (допустим, 67 * 10).
5. Когда пользователь отвечает верно, открывается проход дальше.
6. Далее пользователь постепенно решает более сложные примеры (умножение на 9, 11, 5, 101 и т.д.), перед этим читая объяснение на табличках
7. От скорости решения примеров зависит восстановление здоровья.
8. Пользователь может хорошо играть в платформеры и не получать много урона, а может хорошо решать выражения и быстро восстанавливаться (или оба)
9. Также все враги как-то связаны с математикой (пример самых простых врагов — цифры от 1 до 9, 0 — босс)

### [ Сценарий 6 - Боссы ]

1. На некоторых уровнях, как было сказано ранее, есть битвы с боссами.
2. На примере одного босса "Х" будет показана связь атак с идеями из математики:
3. У "Х" выделяется 4 вида атак:
4. Линейные: 1 прямая или 4 прямые
5. Полиномы: парабола или кубическая парабола
6. Фигуры: архимедова спираль или окружность
7. Тригонометрия: синус или тангенс
8. Также все атаки можно предвидеть, так как они в виде коротких уравнений показываются над боссом
9. Постепенно атаки становятся сложнее вместе с музыкой, которая становится агрессивнее.

### [ Сценарий 7 - Итоговый процесс обучения ]

1. Пользователь в игровой форме изучает математику:
2. Пользователь сражается с различными врагами.
3. Пользователь применяет различное оружие.
4. Пользователь практикует определённую тему с помощью решения примеров.
5. Пользователь закрепляет тему в конце уровня, в финальном примере и пытается достичь начала уровня как можно быстрее.
6. Пользователь заканчивает уровень.
7. Пользователь заканчивает раздел (например, арифметика), сражаясь с боссом этого раздела (в арифметике — "0")