--Задача 1

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    department VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);

CREATE TABLE promo_campaigns(
    campaign_id SERIAL PRIMARY KEY,
    campaign_name VARCHAR(255) NOT NULL,
    channel VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TYPE event_type_enum AS ENUM ('view', 'click', 'action');
CREATE TABLE promo_events(
    event_id SERIAL PRIMARY KEY,
    campaign_id INT NOT NULL,
    user_id INT NOT NULL,
    event_type event_type_enum NOT NULL,
    event_dt TIMESTAMP NOT NULL,

    FOREIGN KEY (campaign_id) REFERENCES promo_campaigns(campaign_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

--Генерируем данные для БД

-- 1. Добавляем 15 сотрудников из разных городов и департаментов
INSERT INTO users (department, city) VALUES
    ('Аналитика',   'Москва'),
    ('IT',          'Санкт-Петербург'),
    ('Маркетинг',   'Москва'),
    ('Продажи',     'Москва'),
    ('HR',          'Казань'),
    ('Финансы',     'Москва'),
    ('Логистика',   'Екатеринбург'),
    ('IT',          'Москва'),
    ('Дизайн',      'Санкт-Петербург'),
    ('Поддержка',   'Новосибирск'),
    ('Юристы',      'Москва'),
    ('Аналитика',   'Санкт-Петербург'),
    ('Маркетинг',   'Казань'),
    ('Продажи',     'Екатеринбург'),
    ('HR',          'Москва');

-- 2. Добавляем 5 рекламных кампаний
INSERT INTO promo_campaigns (campaign_name, channel, start_date, end_date) VALUES
    ('Федеральная осенняя распродажа', 'Telegram', '2026-09-01', '2026-09-30'),
    ('Email-дайджест для партнеров',  'Email',    '2026-09-05', '2026-09-20'),
    ('Таргет в соцсетях B2B',          'VK',       '2026-09-10', '2026-09-25'),
    ('Push: Персональные скидки',      'Push',     '2026-09-15', '2026-09-22'),
    ('SMS-реактивация базы',           'SMS',      '2026-09-18', '2026-09-28');

-- 3. Добавляем логи событий воронки (view -> click -> action)
INSERT INTO promo_events (campaign_id, user_id, event_type, event_dt) VALUES
    (1, 1,  'view',   '2026-09-01 10:00:00'),
    (1, 1,  'click',  '2026-09-01 10:02:00'),
    (1, 1,  'click',  '2026-09-01 10:03:00'), -- Дублирующий клик
    (1, 1,  'action', '2026-09-01 10:15:00'),
    (1, 2,  'view',   '2026-09-01 11:00:00'),
    (1, 2,  'click',  '2026-09-01 11:05:00'),
    (1, 3,  'view',   '2026-09-01 11:30:00'),
    (1, 3,  'click',  '2026-09-01 11:32:00'),
    (1, 3,  'action', '2026-09-01 11:45:00'),
    (1, 4,  'view',   '2026-09-01 12:00:00'),
    (1, 4,  'click',  '2026-09-01 12:10:00'),
    (1, 5,  'view',   '2026-09-01 13:00:00'),
    (1, 5,  'click',  '2026-09-01 13:04:00'),
    (1, 5,  'action', '2026-09-01 13:20:00'),
    (1, 6,  'view',   '2026-09-01 14:00:00'),
    (1, 6,  'click',  '2026-09-01 14:01:00'),
    (1, 7,  'view',   '2026-09-01 15:00:00'),
    (1, 7,  'click',  '2026-09-01 15:06:00'),
    (1, 7,  'action', '2026-09-01 15:30:00'),
    (1, 9,  'view',   '2026-09-01 16:00:00'),
    (1, 10, 'view',   '2026-09-01 16:30:00'),
    (2, 1,  'view',   '2026-09-06 09:00:00'),
    (2, 1,  'click',  '2026-09-06 09:02:00'),
    (2, 8,  'view',   '2026-09-06 09:15:00'),
    (2, 8,  'click',  '2026-09-06 09:20:00'),
    (2, 13, 'view',   '2026-09-06 10:00:00'),
    (2, 13, 'click',  '2026-09-06 10:05:00'),
    (2, 13, 'action', '2026-09-06 10:25:00'),
    (3, 11, 'view',   '2026-09-11 11:00:00'),
    (3, 11, 'click',  '2026-09-11 11:02:00'),
    (3, 14, 'view',   '2026-09-11 12:00:00'),
    (3, 14, 'click',  '2026-09-11 12:15:00'),
    (3, 14, 'action', '2026-09-11 12:40:00'),
    (4, 2,  'view',   '2026-09-16 14:00:00'),
    (4, 3,  'view',   '2026-09-16 14:05:00'),
    (4, 5,  'view',   '2026-09-16 14:10:00'),
    (5, 12, 'view',   '2026-09-19 10:00:00'),
    (5, 12, 'click',  '2026-09-19 10:05:00'),
    (5, 8,  'view',   '2026-09-19 10:10:00'),
    (5, 8,  'click',  '2026-09-19 10:12:00'),
    (5, 9,  'view',   '2026-09-19 11:00:00'),
    (5, 9,  'click',  '2026-09-19 11:03:00'),
    (5, 15, 'view',   '2026-09-19 12:00:00'),
    (5, 15, 'click',  '2026-09-19 12:05:00'),
    (5, 15, 'action', '2026-09-19 12:20:00');

--Задание 1.1

SELECT pc.campaign_id, pc.campaign_name,
       COUNT(DISTINCT CASE WHEN pe.event_type = 'view' THEN pe.user_id END) AS unique_viewers,
       COUNT(DISTINCT CASE WHEN pe.event_type = 'click' THEN pe.user_id END) AS unique_clickers,
       ROUND(
               COUNT(DISTINCT CASE WHEN pe.event_type = 'click' THEN pe.user_id END) * 100.0 /
               NULLIF(COUNT(DISTINCT CASE WHEN pe.event_type = 'view' THEN pe.user_id END), 0),
               2
       ) AS conversion_rate_pct
FROM promo_campaigns AS pc
         LEFT JOIN promo_events AS pe ON pc.campaign_id = pe.campaign_id
GROUP BY
    pc.campaign_id,
    pc.campaign_name
ORDER BY
    conversion_rate_pct DESC NULLS LAST;

--Задание 1.2

SELECT
    pc.campaign_id,
    pc.campaign_name,
    COUNT(DISTINCT CASE WHEN pe.event_type = 'view' THEN pe.user_id END) AS unique_viewers,
    COUNT(DISTINCT CASE WHEN pe.event_type = 'click' THEN pe.user_id END) AS unique_clickers,
    ROUND(
            COUNT(DISTINCT CASE WHEN pe.event_type = 'click' THEN pe.user_id END) * 100.0 /
            NULLIF(COUNT(DISTINCT CASE WHEN pe.event_type = 'view' THEN pe.user_id END), 0),
            2
    ) AS conversion_rate_pct
FROM promo_campaigns pc
         LEFT JOIN promo_events pe ON pc.campaign_id = pe.campaign_id
         LEFT JOIN users u ON pe.user_id = u.user_id
GROUP BY
    pc.campaign_id,
    pc.campaign_name
HAVING
    COUNT(DISTINCT CASE WHEN pe.event_type = 'click' THEN u.department END) > 5
ORDER BY
    conversion_rate_pct DESC NULLS LAST;

--Задание 1.3
 /* 1) "Клик раньше просмотра" или "клик без просмотра": в реальных логах часто из-за сбоев трекеров или
блокировщиков рекламы событие view не долетает до базы, а click записывается. Если у кампании 0 просмотров и 1 клик,
формула конверсии либо упадет, либо даст бессмысленные цифры
    2) Статистическая надежность: стоит проверить кампании с микровыборками, где конверсия может быть формально равна 100%
при 1–2 просмотрах, либо превышать 100%, если просмотры потерялись при логировании
 */
