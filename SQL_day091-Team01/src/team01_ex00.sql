--delete from currency where rate_to_usd = 0.85;
--delete from currency where rate_to_usd = 0.79;

SELECT
    COALESCE(us.name,'not defined')AS name,
    COALESCE(us.lastname,'not defined') AS lastname,
    bal.type,
    bal.summ AS volume,
    COALESCE(cur.name, 'not defined') AS currency_name,
    COALESCE(cur.rate,1) AS last_rate_to_usd,
    (bal.summ::real * COALESCE(cur.rate,1))AS total_volume_in_usd
FROM 
    (SELECT user_id, type, currency_id, SUM(money) AS summ FROM balance
    GROUP BY user_id, type, currency_id) bal
FULL JOIN  "user" us ON bal.user_id=us.id
FULL JOIN (SELECT id, name, rate_to_usd AS rate 
            FROM currency 
            WHERE (id,updated) in (SELECT id, MAX(updated)
                                    FROM currency
                                    GROUP BY id)) cur ON bal.currency_id=cur.id
ORDER BY name DESC, lastname, bal.type;

