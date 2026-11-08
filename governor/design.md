# Design report

11 silver model(s), 8 KPI(s) to build, 2 KPI(s) declined.

Thread: `189ba982-d3e8-43a0-aa43-e854363f9986`

## Silver models

| name | folder | from | key | PII columns |
|---|---|---|---|---|
| stg_customers | staging | raw.olist_customers_dataset | customer_id | customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state |
| stg_orders | staging | raw.olist_orders_dataset | order_id | customer_id |
| stg_order_items | staging | raw.olist_order_items_dataset | order_id, order_item_id | none |
| stg_order_payments | staging | raw.olist_order_payments_dataset | order_id, payment_sequential | none |
| stg_order_reviews | staging | raw.olist_order_reviews_dataset | review_id, order_id | review_comment_title, review_comment_message |
| stg_products | staging | raw.olist_products_dataset | product_id | none |
| stg_sellers | staging | raw.olist_sellers_dataset | seller_id | seller_zip_code_prefix, seller_city |
| stg_product_category_name_translation | staging | raw.product_category_name_translation | product_category_name | none |
| int_orders | intermediate | stg_orders, stg_customers | order_id | customer_id, customer_key |
| int_order_lines | intermediate | stg_order_items, int_orders | order_id, order_item_id | customer_key |
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
| conversion_rate | decline |  | No sessions / web analytics data in the raw profile; cannot compute sessions or session-level conversion. |
| gross_margin | decline |  | No product cost data (product_costs) is available in the raw profile; cannot compute gross margin without unit cost. |

## Gap report

### conversion_rate

- Missing data: sessions table with one row per site session including session_start timestamp and converted boolean
- Typical sources: Web analytics (Google Analytics 4, Adobe Analytics), tracking pipeline, cookie/session logs, backend visit events
- Next step: Load a sessions (or visits) table with a session_start timestamp and a boolean converted flag (or linkable events that allow deriving converted).

### gross_margin

- Missing data: product_costs table with product_key and unit_cost
- Typical sources: ERP, PIM, procurement system, vendor price lists
- Next step: Load a product_costs table keyed by product_id (or the product_key used in order_lines) with a numeric unit_cost column.

## Assumptions

- Person-level customer key = stg_customers.customer_unique_id and is the canonical 'customer_key' used by customer-facing KPIs.
- A valid order = order_status NOT IN ('canceled', 'unavailable'). This matches approved mappings.
- A delivered order = order_status = 'delivered'. This matches approved mappings.
- int_order_reviews picks the latest review per order by review_answer_timestamp (ties resolved arbitrarily by order in SQL window).
- int_orders is built by joining stg_orders to stg_customers on customer_id to obtain customer_unique_id; stg_orders.order_id is the order grain.
- PII columns (customer_id, customer_unique_id, zip/city) are tagged in silver; gold models must mask or exclude them per blueprint rules.
- Source_table names must match the raw profile table names exactly (e.g. 'olist_orders_dataset'), not schema-qualified strings used previously.

## Validation findings

None: the proposal passed every check.

## Commands

Approve:

```
python -m governor.build approve 189ba982-d3e8-43a0-aa43-e854363f9986 --by <name>
```

Reject with a note (the plan model proposes once more):

```
python -m governor.build reject 189ba982-d3e8-43a0-aa43-e854363f9986 --note "<what to change>"
```
