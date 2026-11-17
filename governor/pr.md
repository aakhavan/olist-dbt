# governor: build c07cf5d1

## Summary

governor built this dbt project from the raw schema: 12 silver models, 8 KPIs and 2 gaps. Build thread `c07cf5d1-7061-4d85-8ce4-0382a6b79820`, branch `governor/build-c07cf5d1`.

- Design approved by: **Amir Akhavan**
- dbt tests passed: 28 (silver 21, gold 7)
- SQL repairs: 0
- Column descriptions: 100% (87 of 87 columns; review them in the yml files)

## Silver models

- `stg_customers` (staging)
- `stg_orders` (staging)
- `stg_order_items` (staging)
- `stg_order_reviews` (staging)
- `stg_order_payments` (staging)
- `stg_products` (staging)
- `stg_sellers` (staging)
- `stg_product_category_name_translation` (staging)
- `stg_geolocation` (staging)
- `int_orders` (intermediate)
- `int_order_lines` (intermediate)
- `int_order_reviews` (intermediate)

## KPIs

| KPI | model | domain | owner | source tier | source |
|---|---|---|---|---|---|
| gmv | `kpi_gmv` | sales | Amir Akhavan (analytics) | platform | https://www.sec.gov/Archives/edgar/data/1594805/000159480526000007/shop-20251231.htm |
| net_revenue | `kpi_net_revenue` | sales | Amir Akhavan (analytics) | accounting | https://www.ifrs.org/content/dam/ifrs/meetings/2014/july/trg-rev/rev-rec/ap2-gross-net-amounts-billed.pdf |
| aov | `kpi_aov` | sales | Amir Akhavan (analytics) | platform | https://changelog.shopify.com/posts/your-average-order-value-now-has-a-new-definition-in-shopify |
| on_time_delivery_rate | `kpi_on_time_delivery_rate` | delivery | Amir Akhavan (operations) | platform | https://marketplacelearn.walmart.com/guides/Policies%20&%20standards/Performance/Seller-performance-standards |
| avg_review_score | `kpi_avg_review_score` | customers | Amir Akhavan (customer experience) | platform | https://aboutamazon.com/news/retail/amazon-customer-reviews-star-ratings |
| repeat_purchase_rate | `kpi_repeat_purchase_rate` | customers | Amir Akhavan (analytics) | platform | https://help.shopify.com/manual/reports-and-analytics/shopify-reports/report-types/customers-reports?r=ecm-bfs |
| cohort_retention | `kpi_cohort_retention` | customers | Amir Akhavan (analytics) | platform | https://support.google.com/analytics/answer/9670133?hl=en |
| historical_clv | `kpi_historical_clv` | customers | Amir Akhavan (analytics) | platform | https://help.shopify.com/manual/reports-and-analytics/shopify-reports/report-types/customers-reports?r=ecm-bfs |

## Gap report

- **conversion_rate**: No sessions/visits data is present in the raw tables; KPI requires session-level data.
  - missing: sessions table (session id, session_start timestamp, converted boolean)
  - typical sources: web analytics (GA4 export), Snowplow, Segment or other event tracking capturing sessions/visits
  - next step: Ingest session or event-level visit data including session_start and a converted flag or joinable purchase events so sessions can be counted and labelled as converted.
- **gross_margin**: No product cost or COGS data available to compute margin; KPI requires unit cost per product.
  - missing: product_costs table with product_id (or product_key) and unit_cost
  - typical sources: ERP, PIM, procurement system, or accounting exports containing product unit costs
  - next step: Load product-level cost data (product_id -> unit_cost) so cost of goods sold can be computed and joined to order lines.

## Tests

dbt build ran every test in the dev schema: 28 passed (21 silver, 7 gold).

## Blueprint findings

No findings.

## Model cost

4 model calls, cost $0.0292.
- `openai/gpt-5-mini`: 4 calls, 14218 in / 12812 out tokens, $0.0292

## Reviewer checklist

- [ ] The silver models read the right raw tables and keys (`governor/design.md`).
- [ ] Every KPI mapping in `governor/approved.yaml` matches the business meaning.
- [ ] The declined KPIs and their next steps in `governor/gaps.md` are right.
- [ ] No PII column reaches a gold model untagged; blueprint findings are acceptable.
- [ ] The dbt tests cover the keys and the KPI grain.
- [ ] After merging, run `python -m governor.build certify --target <dir> --by <name>`.
