CREATE EXTERNAL TABLE `turing-position-478717-g7.nyc_taxi_datawarehouse.stg_yellow_raw`
OPTIONS (
format='PARQUET',
uris=[
'gs://cis9940assignment1/yellow_tripdata_2025-01.parquet',
'gs://cis9940assignment1/yellow_tripdata_2025-02.parquet'
]
);

CREATE TABLE `turing-position-478717-g7.nyc_taxi_datawarehouse.dim_vendor` (
vendor_key INT64,
vendor_id INT64,
vendor_company STRING
);

CREATE TABLE `turing-position-478717-g7.nyc_taxi_datawarehouse.dim_payment_type` (
payment_type_key INT64,
payment_type_id INT64,
payment_type_description STRING
);

CREATE TABLE `turing-position-478717-g7.nyc_taxi_datawarehouse.dim_ratecode` (
ratecode_key INT64,
ratecode_id INT64,
ratecode_description STRING
);

CREATE TABLE `turing-position-478717-g7.nyc_taxi_datawarehouse.dim_location` (
location_key INT64,
locationID INT64,
borough STRING,
zone STRING,
service_zone STRING
);

CREATE TABLE `turing-position-478717-g7.nyc_taxi_datawarehouse.dim_date` (
date_key INT64,
pickup_date DATE,
pickup_year INT64,
pickup_month INT64,
pickup_day INT64,
pickup_hour INT64,
dropoff_date DATE,
dropoff_year INT64,
dropoff_month INT64,
dropoff_day INT64,
dropoff_hour INT64
);

CREATE TABLE `turing-position-478717-g7.nyc_taxi_datawarehouse.fact_trip` (
trip_key INT64,
date_key INT64,
pickup_location_key INT64,
dropoff_location_key INT64,
vendor_key INT64,
payment_type_key INT64,
ratecode_key INT64,
passenger_count INT64,
trip_distance NUMERIC,
fare_amount NUMERIC,
extra NUMERIC,
mta_tax NUMERIC,
tolls_amount NUMERIC,
improvement_surcharge NUMERIC,
congestion_surcharge NUMERIC,
airport_fee NUMERIC,
tip_amount NUMERIC,
total_amount NUMERIC,
trip_duration_minutes NUMERIC,
total_fees_before_tip NUMERIC,
tip_percent NUMERIC,
fare_per_mile NUMERIC
);
