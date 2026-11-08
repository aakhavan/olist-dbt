# governor: build 189ba982

## Summary

governor built this dbt project from the raw schema: 11 silver models, 8 KPIs and 2 gaps. Build thread `189ba982-d3e8-43a0-aa43-e854363f9986`, branch `governor/build-189ba982`.

- Design approved by: **Amir Akhavan**
- dbt tests passed: 25 (silver 18, gold 7)
- SQL repairs: 0
- Column descriptions: 100% (90 of 90 columns; review them in the yml files)

## Silver models

- `stg_customers` (staging)
- `stg_orders` (staging)
- `stg_order_items` (staging)
- `stg_order_payments` (staging)
- `stg_order_reviews` (staging)
- `stg_products` (staging)
- `stg_sellers` (staging)
- `stg_product_category_name_translation` (staging)
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

- **conversion_rate**: No sessions / web analytics data in the raw profile; cannot compute sessions or session-level conversion.
  - missing: sessions table with one row per site session including session_start timestamp and converted boolean
  - typical sources: Web analytics (Google Analytics 4, Adobe Analytics), tracking pipeline, cookie/session logs, backend visit events
  - next step: Load a sessions (or visits) table with a session_start timestamp and a boolean converted flag (or linkable events that allow deriving converted).
- **gross_margin**: No product cost data (product_costs) is available in the raw profile; cannot compute gross margin without unit cost.
  - missing: product_costs table with product_key and unit_cost
  - typical sources: ERP, PIM, procurement system, vendor price lists
  - next step: Load a product_costs table keyed by product_id (or the product_key used in order_lines) with a numeric unit_cost column.

## Tests

dbt build ran every test in the dev schema: 25 passed (18 silver, 7 gold).

## Blueprint findings

No findings.

## Model cost

5 model calls, cost $0.0445.
- `openai/gpt-5-mini`: 5 calls, 31544 in / 19573 out tokens, $0.0445

## Reviewer checklist

- [ ] The silver models read the right raw tables and keys (`governor/design.md`).
- [ ] Every KPI mapping in `governor/approved.yaml` matches the business meaning.
- [ ] The declined KPIs and their next steps in `governor/gaps.md` are right.
- [ ] No PII column reaches a gold model untagged; blueprint findings are acceptable.
- [ ] The dbt tests cover the keys and the KPI grain.
- [ ] After merging, run `python -m governor.build certify --target <dir> --by <name>`.
