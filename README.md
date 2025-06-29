# Stock Market Real-Time ETL Pipeline

## Overview
This project implements a robust ETL (Extract, Transform, Load) pipeline for processing real-time stock market data. It leverages modern data engineering practices and tools to provide a scalable, maintainable, and efficient solution for stock market data analysis.

## Key Features
- Real-time stock data ingestion from Alpha Vantage API
- Automated data quality checks and validation
- Delta Lake implementation for ACID compliance and data versioning
- Scalable data processing with Apache Spark
- Containerized deployment with Docker
- Workflow orchestration with Prefect
- MinIO (S3-compatible) storage integration
- Modular and extensible architecture

## Architecture
### Data Flow
1. **Data Extraction**: 
   - Fetches real-time intraday stock data from Alpha Vantage API
   - Supports multiple stock symbols (NVDA, TSLA, IBM, AAPL)
   - Configurable data fetch intervals

2. **Data Processing**:
   - Data normalization and cleaning
   - Schema validation and enforcement
   - Data quality checks using Soda Core
   - Delta Lake bronze/silver layer implementation

3. **Data Storage**:
   - MinIO as S3-compatible object storage
   - Delta Lake tables for efficient data management
   - Partitioned storage for optimal query performance

### Technology Stack
- **Python**: Core programming language
- **Apache Spark**: Distributed data processing
- **Delta Lake**: ACID compliant storage layer
- **MinIO**: S3-compatible object storage
- **Prefect**: Workflow orchestration
- **Docker**: Containerization
- **Soda Core**: Data quality validation
- **Alpha Vantage API**: Real-time stock data source

## Project Structure
```
stockETL/
├── config/               # Configuration files
├── data_quality/         # Data quality check definitions
├── delta_tables/         # Delta Lake table creation scripts
├── pipelines/           
│   ├── api_utils/       # API interaction utilities
│   ├── stock_etl.py     # Main ETL pipeline
│   ├── transform.py     # Data transformation logic
│   └── etl_utils.py     # ETL helper functions
└── sample_files/        # Sample data files
```

## Setup and Installation
1. Clone the repository
2. Register for a free API key at [Alpha Vantage](https://www.alphavantage.co/support/#api-key)
3. Create `stockETL/config/config.ini` with your API key:
   ```ini
   [API]
   api_key = your_api_key_here
   ```
4. Build and start the containers:
   ```bash
   make build-nocache
   make up
   ```
5. Initialize the Delta tables:
   ```bash
   make ddl
   ```

## Usage
1. Run the ETL pipeline:
   ```bash
   make stock-etl
   ```

2. Access Spark SQL shell:
   ```bash
   make spark-sql
   ```

3. Start PySpark shell:
   ```bash
   make py-spark-sh
   ```

## Development
### Code Quality
The project maintains high code quality standards through:
- Type checking with MyPy
- Code formatting with Black
- Import sorting with isort
- Linting with flake8
- Unit testing with pytest

Run quality checks:
```bash
make format  # Format code
make type    # Type checking
make lint    # Linting
make pytest  # Run tests
make ci      # Run all checks
```

### Docker Environment
- Local Spark cluster
- MinIO for S3-compatible storage
- PostgreSQL for metadata storage
- Prefect for workflow orchestration

## Data Model
### Bronze Layer
- Raw stock market data
- Partitioned by date
- Includes:
  - Timestamp
  - Symbol
  - OHLCV (Open, High, Low, Close, Volume)
  - Batch ID
  - Partition information

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
- Alpha Vantage for providing the stock market data API
- The Apache Spark and Delta Lake communities
- The Prefect team for workflow orchestration tools
