# governor: build bf5dc274

## Summary

governor built this dbt project from the raw schema: 7 silver models, 8 KPIs and 2 gaps. Build thread `bf5dc274-8dad-4a62-9795-952dd2584fc4`, branch `governor/build-bf5dc274`.

- Design approved by: **(not recorded)**
- dbt tests passed: 18 (silver 11, gold 7)
- SQL repairs: 0

## Silver models

- `stg_customers` (staging)
- `stg_orders` (staging)
- `stg_order_items` (staging)
- `stg_reviews` (staging)
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

- **conversion_rate**: No session or visit records exist; orders alone cannot supply the session denominator or attribute purchases to sessions.
  - missing: Session identifier and session start timestamp, Purchase conversion flag or order-to-session attribution
  - typical sources: Web or app analytics event exports, First-party session tracking
  - next step: Load a session-grain dataset with session start time and a purchase conversion indicator, or events and order attribution sufficient to derive it.
- **gross_margin**: Item prices and freight are available, but no product unit cost or cost-of-goods-sold data is present. Sale price and freight are not substitutes for cost.
  - missing: Product-keyed unit cost in the sales currency
  - typical sources: ERP product costing, Inventory valuation or purchasing system
  - next step: Load product unit costs keyed by product_id, with currency and effective dates if costs vary; retain product_id from raw order items in silver and join the appropriate costs.

## Tests

dbt build ran every test in the dev schema: 18 passed (11 silver, 7 gold).

## Blueprint findings

No findings.

## Model cost

4 model calls, cost $0.0480.
- `openai/gpt-6.1-sol`: 1 calls, 6611 in / 2512 out tokens, $0.0416
- `openai/gpt-5-mini`: 3 calls, 1759 in / 2983 out tokens, $0.0064

## Reviewer checklist

- [ ] The silver models read the right raw tables and keys (`governor/design.md`).
- [ ] Every KPI mapping in `governor/approved.yaml` matches the business meaning.
- [ ] The declined KPIs and their next steps in `governor/gaps.md` are right.
- [ ] No PII column reaches a gold model untagged; blueprint findings are acceptable.
- [ ] The dbt tests cover the keys and the KPI grain.
- [ ] After merging, run `python -m governor.build certify --target <dir> --by <name>`.
