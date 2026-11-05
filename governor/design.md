# Design report

7 silver model(s), 8 KPI(s) to build, 2 KPI(s) declined.

Thread: `bf5dc274-8dad-4a62-9795-952dd2584fc4`

## Silver models

| name | folder | from | key | PII columns |
|---|---|---|---|---|
| stg_customers | staging | raw.olist_customers_dataset | customer_id | customer_id, customer_key |
| stg_orders | staging | raw.olist_orders_dataset | order_id | customer_id |
| stg_order_items | staging | raw.olist_order_items_dataset | order_id, order_item_id | none |
| stg_reviews | staging | raw.olist_order_reviews_dataset | review_id, order_id | none |
| int_orders | intermediate | stg_orders, stg_customers | order_id | customer_key |
| int_order_lines | intermediate | stg_order_items, int_orders | order_id, order_item_id | customer_key |
| int_order_reviews | intermediate | stg_reviews, stg_orders | order_id | none |

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
| conversion_rate | decline |  | No session or visit records exist; orders alone cannot supply the session denominator or attribute purchases to sessions. |
| gross_margin | decline |  | Item prices and freight are available, but no product unit cost or cost-of-goods-sold data is present. Sale price and freight are not substitutes for cost. |

## Gap report

### conversion_rate

- Missing data: Session identifier and session start timestamp, Purchase conversion flag or order-to-session attribution
- Typical sources: Web or app analytics event exports, First-party session tracking
- Next step: Load a session-grain dataset with session start time and a purchase conversion indicator, or events and order attribution sufficient to derive it.

### gross_margin

- Missing data: Product-keyed unit cost in the sales currency
- Typical sources: ERP product costing, Inventory valuation or purchasing system
- Next step: Load product unit costs keyed by product_id, with currency and effective dates if costs vary; retain product_id from raw order items in silver and join the appropriate costs.

## Assumptions

- Valid sales are orders whose normalized status is neither 'canceled' nor 'unavailable'; delivered means status exactly 'delivered'. No payment-based qualification is added.
- customer_unique_id identifies a person across orders; customer_id is only the order-specific customer reference. Person identifiers remain tagged PII in silver and are used internally for aggregation only, never exposed in gold outputs.
- Profile candidate business keys are trusted; unexpected duplicate or null primary keys fail tests rather than being silently discarded. Composite keys receive combination-uniqueness and component-not-null tests.
- Latest review means greatest review_answer_timestamp per order; ties use descending review_id deterministically. All original reviews remain in staging.
- Source timestamps are treated as timezone-unspecified timestamps with no timezone conversion; empty strings become null. Prices and freight are numeric values assumed to share one source currency.
- Delivery timeliness uses calendar-day comparison and excludes delivered orders missing either delivery date from the denominator, as required by the catalogue.
- Net revenue and historical CLV are revenue-based, exclude freight, and use delivered item prices without inventing discounts, refunds, taxes, or costs.
- Item-based catalogue metrics operate on observed order items; itemless orders remain in int_orders for order-level metrics. Historical CLV's single item-grain template can identify first valid purchases only among orders with items; using it assumes each customer's first valid order is represented in order items. Validate this condition before approval; otherwise the CLV template needs an additional order-grain input.
- Retention cohorts use the first observed valid order in the available dataset, not necessarily the customer's lifetime first order. The catalogue's last-observed-month incomplete flag is retained; no completeness beyond the observation period is assumed.
- Only raw tables needed by buildable KPIs are staged; selected orders, customers, items, and reviews retain nonaggregated records. Unused PII, payments, products, sellers, translations, and geolocation are omitted.
- Gold outputs contain aggregates only, with owners assigned by the selected sales, delivery, and customers domains and descriptions taken from the catalogue.

## Validation findings

None: the proposal passed every check.

## Commands

Approve:

```
python -m governor.build approve bf5dc274-8dad-4a62-9795-952dd2584fc4 --by <name>
```

Reject with a note (the plan model proposes once more):

```
python -m governor.build reject bf5dc274-8dad-4a62-9795-952dd2584fc4 --note "<what to change>"
```
