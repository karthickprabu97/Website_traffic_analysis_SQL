
-- 1. Give a breakdown by UTM source, campaign and referring domain if possible

SELECT 
     utm_source,
     utm_campaign,
     http_referer,
     COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at < '2012-04-12'
GROUP BY
 	1,2,3
ORDER BY 
 	COUNT(DISTINCT website_session_id) DESC;
    

-- 2. Could you please calculate the conversion rate (CVR) from session to order? 
-- Based on what we're paying for clicks,  we’ll need a CVR of at least 4% to make the numbers work.

SELECT
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS cvr
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id

WHERE 
	website_sessions.utm_source = 'gsearch' AND
    website_sessions.utm_campaign = 'nonbrand' AND
    website_sessions.created_at < '2012-04-14'
;


-- 3. Can you pull gsearch nonbrand trended session volume, by week, 
-- to see if the bid changes have caused volume to drop at all?

SELECT 
	-- WEEK(created_at) AS wk_created,
    MIN(DATE(created_at)) AS start_of_wk,
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE
	utm_source = 'gsearch' AND
    utm_campaign = 'nonbrand' AND
    created_at < '2012-05-10'
GROUP BY
	WEEK(created_at)


-- 4.  Could you pull conversion rates from session to order, by device type? 

SELECT
	website_sessions.device_type,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS conversions,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS cnv_ratio
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE 
	website_sessions.created_at < '2012-05-11' AND
    utm_source = 'gsearch' AND
    utm_campaign = 'nonbrand'
GROUP BY
		website_sessions.device_type


-- 5. Could you pull weekly trends for both desktop and mobile so we can see the impact on volume?

SELECT
	-- WEEK(created_at) AS wk,
    MIN(DATE(created_at)) AS start_of_wk,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS desktop_sns,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sns
FROM website_sessions
WHERE 
	website_sessions.created_at < '2012-06-09' AND
    utm_source = 'gsearch' AND
    utm_campaign = 'nonbrand'
    
GROUP BY
	WEEK(created_at)


	



