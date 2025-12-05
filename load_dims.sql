INSERT INTO `nyc_taxi_datawarehouse.dim_date`
(date_key,pickup_date,pickup_year,pickup_month,pickup_day,pickup_hour,dropoff_date,dropoff_year,dropoff_month,dropoff_day,dropoff_hour)
SELECT
CAST(FORMAT_DATE('%Y%m%d',DATE(tpep_pickup_datetime)) AS INT64),
DATE(tpep_pickup_datetime),
EXTRACT(YEAR FROM tpep_pickup_datetime),
EXTRACT(MONTH FROM tpep_pickup_datetime),
EXTRACT(DAY FROM tpep_pickup_datetime),
EXTRACT(HOUR FROM tpep_pickup_datetime),
DATE(tpep_dropoff_datetime),
EXTRACT(YEAR FROM tpep_dropoff_datetime),
EXTRACT(MONTH FROM tpep_dropoff_datetime),
EXTRACT(DAY FROM tpep_dropoff_datetime),
EXTRACT(HOUR FROM tpep_dropoff_datetime)
FROM `nyc_taxi_datawarehouse.stg_yellow_raw`;

LOAD DATA INTO `turing-position-478717-g7.nyc_taxi_datawarehouse.dim_location`
FROM FILES (
uris=['gs://cis9940assignment1/taxi_zone_lookup.csv'],
format='CSV'
);

INSERT INTO `turing-position-478717-g7.nyc_taxi_datawarehouse.dim_vendor`
(vendor_key,vendor_id,vendor_company)
VALUES
(1,1,'Creative Mobile Technologies, LLC'),
(2,2,'Curb Mobility, LLC'),
(6,6,'Myle Technologies Inc'),
(7,7,'Helix');

INSERT INTO `turing-position-478717-g7.nyc_taxi_datawarehouse.dim_payment_type`
(payment_type_key,payment_type_id,payment_type_description)
VALUES
(0,0,'Flex Fare trip'),
(1,1,'Credit card'),
(2,2,'Cash'),
(3,3,'No charge'),
(4,4,'Dispute'),
(5,5,'Unknown'),
(6,6,'Voided trip');

INSERT INTO `turing-position-478717-g7.nyc_taxi_datawarehouse.dim_ratecode`
(ratecode_key,ratecode_id,ratecode_description)
VALUES
(1,1,'Standard rate'),
(2,2,'JFK'),
(3,3,'Newark'),
(4,4,'Nassau or Westchester'),
(5,5,'Negotiated fare'),
(6,6,'Group ride'),
(99,99,'Null/unknown');
