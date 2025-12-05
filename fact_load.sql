WITH fact_source AS (
SELECT
ROW_NUMBER() OVER() AS trip_key,
CAST(FORMAT_DATE('%Y%m%d',DATE(s.tpep_pickup_datetime)) AS INT64) AS date_key,
pu.location_key AS pickup_location_key,
do.location_key AS dropoff_location_key,
v.vendor_key AS vendor_key,
p.payment_type_key AS payment_type_key,
r.ratecode_key AS ratecode_key,
s.passenger_count,
CAST(s.trip_distance AS NUMERIC) AS trip_distance,
CAST(s.fare_amount AS NUMERIC) AS fare_amount,
CAST(s.extra AS NUMERIC) AS extra,
CAST(s.mta_tax AS NUMERIC) AS mta_tax,
CAST(s.tolls_amount AS NUMERIC) AS tolls_amount,
CAST(s.improvement_surcharge AS NUMERIC) AS improvement_surcharge,
CAST(s.congestion_surcharge AS NUMERIC) AS congestion_surcharge,
CAST(s.airport_fee AS NUMERIC) AS airport_fee,
CAST(s.tip_amount AS NUMERIC) AS tip_amount,
CAST(s.total_amount AS NUMERIC) AS total_amount,
TIMESTAMP_DIFF(s.tpep_dropoff_datetime,s.tpep_pickup_datetime,MINUTE) AS trip_duration_minutes,
CAST(
IFNULL(s.fare_amount,0)+
IFNULL(s.extra,0)+
IFNULL(s.mta_tax,0)+
IFNULL(s.tolls_amount,0)+
IFNULL(s.improvement_surcharge,0)+
IFNULL(s.congestion_surcharge,0)+
IFNULL(s.airport_fee,0)+
IFNULL(s.cbd_congestion_fee,0)
AS NUMERIC
) AS total_fees_before_tip,
CASE WHEN s.fare_amount IS NULL OR s.fare_amount=0 THEN NULL
ELSE CAST((s.tip_amount/s.fare_amount)*100 AS NUMERIC)
END AS tip_percent,
CASE WHEN s.trip_distance IS NULL OR s.trip_distance=0 THEN NULL
ELSE CAST(s.fare_amount/s.trip_distance AS NUMERIC)
END AS fare_per_mile
FROM `nyc_taxi_datawarehouse.stg_yellow_raw` s
LEFT JOIN `nyc_taxi_datawarehouse.dim_vendor` v
ON s.VendorID=v.vendor_id
LEFT JOIN `nyc_taxi_datawarehouse.dim_payment_type` p
ON s.payment_type=p.payment_type_id
LEFT JOIN `nyc_taxi_datawarehouse.dim_ratecode` r
ON s.RatecodeID=r.ratecode_id
LEFT JOIN `nyc_taxi_datawarehouse.dim_location` pu
ON s.PULocationID=pu.locationID
LEFT JOIN `nyc_taxi_datawarehouse.dim_location` do
ON s.DOLocationID=do.locationID
)

INSERT INTO `nyc_taxi_datawarehouse.fact_trip`
(trip_key,date_key,pickup_location_key,dropoff_location_key,vendor_key,payment_type_key,ratecode_key,passenger_count,trip_distance,fare_amount,extra,mta_tax,tolls_amount,improvement_surcharge,congestion_surcharge,airport_fee,tip_amount,total_amount,trip_duration_minutes,total_fees_before_tip,tip_percent,fare_per_mile)
SELECT
trip_key,
date_key,
pickup_location_key,
dropoff_location_key,
vendor_key,
payment_type_key,
ratecode_key,
passenger_count,
trip_distance,
fare_amount,
extra,
mta_tax,
tolls_amount,
improvement_surcharge,
congestion_surcharge,
airport_fee,
tip_amount,
total_amount,
trip_duration_minutes,
total_fees_before_tip,
tip_percent,
fare_per_mile
FROM fact_source;
