# Design report

12 silver model(s), 8 KPI(s) to build, 2 KPI(s) declined.

Thread: `c07cf5d1-7061-4d85-8ce4-0382a6b79820`

## Silver models

| name | folder | from | key | PII columns |
|---|---|---|---|---|
| stg_customers | staging | raw.olist_customers_dataset | customer_id | customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state |
| stg_orders | staging | raw.olist_orders_dataset | order_id | customer_id |
| stg_order_items | staging | raw.olist_order_items_dataset | order_id, order_item_id | none |
| stg_order_reviews | staging | raw.olist_order_reviews_dataset | review_id | none |
| stg_order_payments | staging | raw.olist_order_payments_dataset | order_id, payment_sequential | none |
| stg_products | staging | raw.olist_products_dataset | product_id | none |
| stg_sellers | staging | raw.olist_sellers_dataset | seller_id | seller_zip_code_prefix, seller_city |
| stg_product_category_name_translation | staging | raw.product_category_name_translation | product_category_name | none |
| stg_geolocation | staging | raw.olist_geolocation_dataset | geolocation_zip_code_prefix | geolocation_lat, geolocation_lng |
| int_orders | intermediate | stg_orders, stg_customers | order_id | customer_key |
| int_order_lines | intermediate | stg_order_items, int_orders, stg_products | order_id, order_item_id | customer_key |
| int_order_reviews | intermediate | stg_order_reviews, int_orders | order_id | none |

## KPIs

| id | decision | domain | mapping or reason |
|---|---|---|---|
| gmv | build | sales | order_lines → int_order_lines; purchased_at → purchased_at; item_price → item_price; freight → freight; valid_order → order_status NOT IN ('canceled', 'unavailable') |
| net_revenue | build | sales | order_lines → int_order_lines; purchased_at → purchased_at; item_price → item_price; delivered_order → order_status = 'delivered' |
| aov | build | sales | order_lines → int_order_lines; order_id → order_id; purchased_at → purchased_at; item_price → item_price; valid_order → order_status NOT IN ('canceled', 'unavailable') |
| on_time_delivery_rate | build | delivery | orders → int_orders; purchased_at → purchased_at; delivered_at → delivered_at; estimated_at → estimated_at; delivered_order → order_status = 'delivered' |
| avg_review_score | build | customers | order_reviews → int_order_reviews; purchased_at → purchased_at; review_score → review_score |
| repeat_purchase_rate | build | customers | orders → int_orders; order_id → order_id; customer_key → customer_key; valid_order → order_status NOT IN ('canceled', 'unavailable') |
| cohort_retention | build | customers | orders → int_orders; customer_key → customer_key; purchased_at → purchased_at; valid_order → order_status NOT IN ('canceled', 'unavailable') |
| historical_clv | build | customers | order_lines → int_order_lines; customer_key → customer_key; purchased_at → purchased_at; item_price → item_price; valid_order → order_status NOT IN ('canceled', 'unavailable'); delivered_order → order_status = 'delivered' |
| conversion_rate | decline |  | No sessions/visits data is present in the raw tables; KPI requires session-level data. |
| gross_margin | decline |  | No product cost or COGS data available to compute margin; KPI requires unit cost per product. |

## Gap report

### conversion_rate

- Missing data: sessions table (session id, session_start timestamp, converted boolean)
- Typical sources: web analytics (GA4 export), Snowplow, Segment or other event tracking capturing sessions/visits
- Next step: Ingest session or event-level visit data including session_start and a converted flag or joinable purchase events so sessions can be counted and labelled as converted.

### gross_margin

- Missing data: product_costs table with product_id (or product_key) and unit_cost
- Typical sources: ERP, PIM, procurement system, or accounting exports containing product unit costs
- Next step: Load product-level cost data (product_id -> unit_cost) so cost of goods sold can be computed and joined to order lines.

## Assumptions

- Person-level customer key = stg_customers.customer_unique_id; int_orders.customer_key surfaces that value and is the person-level identifier used by customer KPIs.
- An order counts as a valid sale when order_status NOT IN ('canceled', 'unavailable'). This is used for valid_order filters across KPIs.
- A delivered order is order_status = 'delivered'.
- int_orders.delivered_at uses stg_orders.order_delivered_customer_date (customer delivery timestamp) as the delivered timestamp for delivery KPIs.
- int_order_reviews contains one row per order by selecting the stg_order_reviews row with the greatest review_answer_timestamp for that order_id (latest review/answer).
- int_order_lines is one row per original order item (grain order_id + order_item_id) and is built by joining stg_order_items to int_orders on order_id to bring in purchase timestamp, order_status, and customer_key.
- PII columns are flagged in silver; customer_key in intermediate models remains marked PII and should be masked/excluded in gold per blueprint rules.
- Where multiple raw candidate keys exist, staging primary keys use stable business keys (e.g., order_id for orders, product_id for products, order_id+order_item_id for order items).

## Validation findings

None: the proposal passed every check.

## Commands

Approve:

```
python -m governor.build approve c07cf5d1-7061-4d85-8ce4-0382a6b79820 --by <name>
```

Reject with a note (the plan model proposes once more):

```
python -m governor.build reject c07cf5d1-7061-4d85-8ce4-0382a6b79820 --note "<what to change>"
```
