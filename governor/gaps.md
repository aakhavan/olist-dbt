# Gap report

KPIs from the catalogue that the approved design declines, and the data that would make them buildable.

## conversion_rate

Reason: No sessions/visits data is present in the raw tables; KPI requires session-level data.

- Missing data: sessions table (session id, session_start timestamp, converted boolean)
- Typical sources: web analytics (GA4 export), Snowplow, Segment or other event tracking capturing sessions/visits
- Next step: Ingest session or event-level visit data including session_start and a converted flag or joinable purchase events so sessions can be counted and labelled as converted.

## gross_margin

Reason: No product cost or COGS data available to compute margin; KPI requires unit cost per product.

- Missing data: product_costs table with product_id (or product_key) and unit_cost
- Typical sources: ERP, PIM, procurement system, or accounting exports containing product unit costs
- Next step: Load product-level cost data (product_id -> unit_cost) so cost of goods sold can be computed and joined to order lines.
