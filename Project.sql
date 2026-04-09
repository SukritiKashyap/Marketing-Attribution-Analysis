use customer;
SELECT * from customer_journey
CREATE TABLE marketing_attribution_data AS
SELECT DISTINCT
    UserID AS user_id,
    Timestamp AS timestamp,
    ReferralSource AS channel,

    CASE 
        WHEN Purchased = 1 THEN 'conversion'
        ELSE 'click'
    END AS event_type,

    CASE 
        WHEN Purchased = 1 THEN FLOOR(RAND()*4000 + 1000)
        ELSE 0
    END AS revenue

FROM customer_journey
WHERE UserID IS NOT NULL;

SELECT COUNT(DISTINCT user_id) FROM marketing_attribution_data;
SELECT COUNT(*) 
FROM marketing_attribution_data
WHERE event_type = 'conversion';

SELECT user_id, COUNT(*) AS steps
FROM marketing_attribution_data
GROUP BY user_id
ORDER BY steps DESC;

-- first touch attribution

WITH first_touch AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY timestamp) AS rn
    FROM marketing_attribution_data
)
SELECT 
    channel,
    COUNT(*) AS conversions
FROM first_touch
WHERE rn = 1
AND user_id IN (
    SELECT user_id 
    FROM marketing_attribution_data 
    WHERE event_type = 'conversion'
)
GROUP BY channel
ORDER BY conversions DESC;

-- last touch attribution

WITH last_touch AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY timestamp DESC) AS rn
    FROM marketing_attribution_data
)
SELECT 
    channel,
    COUNT(*) AS conversions
FROM last_touch
WHERE rn = 1
AND event_type = 'conversion'
GROUP BY channel
ORDER BY conversions DESC;

-- Linear attribution

WITH touchpoints AS (
    SELECT 
        user_id,
        channel,
        COUNT(*) OVER (PARTITION BY user_id) AS total_steps
    FROM marketing_attribution_data
    WHERE user_id IN (
        SELECT user_id 
        FROM marketing_attribution_data 
        WHERE event_type = 'conversion'
    )
)
SELECT 
    channel,
    SUM(1.0 / total_steps) AS attributed_conversions
FROM touchpoints
GROUP BY channel
ORDER BY attributed_conversions DESC;

-- Conversion Funnel

SELECT 
    COUNT(*) AS total_events,
    SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS clicks,
    SUM(CASE WHEN event_type = 'conversion' THEN 1 ELSE 0 END) AS conversions
FROM marketing_attribution_data;

-- Conversion Rate

SELECT 
    ROUND(
        SUM(CASE WHEN event_type = 'conversion' THEN 1 ELSE 0 END) * 1.0 
        / COUNT(*), 4
    ) AS conversion_rate
FROM marketing_attribution_data;

-- Channel Performane

SELECT 
    channel,
    COUNT(*) AS total_events,
    SUM(CASE WHEN event_type = 'conversion' THEN 1 ELSE 0 END) AS conversions,
    SUM(revenue) AS total_revenue
FROM marketing_attribution_data
GROUP BY channel
ORDER BY conversions DESC;

-- Top Conversion Paths

SELECT 
    user_id,
    GROUP_CONCAT(channel ORDER BY timestamp SEPARATOR ' → ') AS path
FROM marketing_attribution_data
WHERE user_id IN (
    SELECT user_id 
    FROM marketing_attribution_data 
    WHERE event_type = 'conversion'
)
GROUP BY user_id;

-- Average Touchpoints Before Conversion

SELECT 
    AVG(step_count) AS avg_touchpoints
FROM (
    SELECT 
        user_id,
        COUNT(*) AS step_count
    FROM marketing_attribution_data
    WHERE user_id IN (
        SELECT user_id 
        FROM marketing_attribution_data 
        WHERE event_type = 'conversion'
    )
    GROUP BY user_id
) t;

-- ROI by Channel

SELECT 
    channel,
    SUM(revenue) AS total_revenue,
    COUNT(*) * 50 AS estimated_cost,
    (SUM(revenue) - COUNT(*) * 50) / (COUNT(*) * 50) AS roi
FROM marketing_attribution_data
GROUP BY channel
ORDER BY roi DESC;
