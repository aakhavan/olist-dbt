# Gap report

KPIs from the catalogue that the approved design declines, and the data that would make them buildable.

## conversion_rate

Reason: No sessions / web analytics data in the raw profile; cannot compute sessions or session-level conversion.

- Missing data: sessions table with one row per site session including session_start timestamp and converted boolean
- Typical sources: Web analytics (Google Analytics 4, Adobe Analytics), tracking pipeline, cookie/session logs, backend visit events
- Next step: Load a sessions (or visits) table with a session_start timestamp and a boolean converted flag (or linkable events that allow deriving converted).

## gross_margin

Reason: No product cost data (product_costs) is available in the raw profile; cannot compute gross margin without unit cost.

- Missing data: product_costs table with product_key and unit_cost
- Typical sources: ERP, PIM, procurement system, vendor price lists
- Next step: Load a product_costs table keyed by product_id (or the product_key used in order_lines) with a numeric unit_cost column.
