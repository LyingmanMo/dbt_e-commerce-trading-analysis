# E-commerce Trading Analysis (Jaffle Shop)

This project is based on the **Jaffle Shop** case study, using **dbt** and **Snowflake** to analyze e-commerce data.

## Project Overview

This project aims to transform raw e-commerce data into actionable insights, applying dbt best practices like **modular SQL**, **incremental models**, and **testing**. The focus is on building a robust analytics pipeline, with deployment in **one trunk** (no separate QA step).

## Key Components

- **Refactoring for Modularity**: SQL queries broken down into reusable parts.
- **Analyses**: Business-specific insights derived from the data.
- **Seeds**: Static data for consistency (e.g., currency rates).
- **Testing**: Includes standard tests (`unique`, `not_null`) and custom logic checks.
- **Materialization**: Optimized with **incremental models** and **snapshots**.
- **Macros**: Custom macros for auditing and consistency.
- **Packages**: Utilized **dbt utils**, **expectations**, and **audit helper**.

## Deployment

This project uses a **one trunk** deployment model. No QA branch or environment is involved.

## How to Run

1. **Clone the Repo**:
    ```bash
    git clone https://github.com/LyingmanMo/dbt_e-commerce-trading-analysis.git
    cd ecommerce-trading-analysis
    ```

2. **Install Dependencies**:
    ```bash
    dbt deps
    ```

3. **Run the Models**:
    ```bash
    dbt run
    ```

4. **Run Tests**:
    ```bash
    dbt test
    ```

5. **Snapshot & Freshness Testing**:
    ```bash
    dbt snapshot
    dbt source freshness
    ```

## Structure

- **models/**: Staging and fact models.
- **macros/**: Reusable logic for transformations.
- **seeds/**: Static datasets.
- **snapshots/**: Historical data tracking.

## Future Enhancements

- Add **Customer Lifetime Value (CLV)** metric.
- Further **incremental model** optimization.
