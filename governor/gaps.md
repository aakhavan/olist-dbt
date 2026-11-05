# Gap report

KPIs from the catalogue that the approved design declines, and the data that would make them buildable.

## conversion_rate

Reason: No session or visit records exist; orders alone cannot supply the session denominator or attribute purchases to sessions.

- Missing data: Session identifier and session start timestamp, Purchase conversion flag or order-to-session attribution
- Typical sources: Web or app analytics event exports, First-party session tracking
- Next step: Load a session-grain dataset with session start time and a purchase conversion indicator, or events and order attribution sufficient to derive it.

## gross_margin

Reason: Item prices and freight are available, but no product unit cost or cost-of-goods-sold data is present. Sale price and freight are not substitutes for cost.

- Missing data: Product-keyed unit cost in the sales currency
- Typical sources: ERP product costing, Inventory valuation or purchasing system
- Next step: Load product unit costs keyed by product_id, with currency and effective dates if costs vary; retain product_id from raw order items in silver and join the appropriate costs.
