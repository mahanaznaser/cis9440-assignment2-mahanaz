INSERT INTO `nyc_taxi_datawarehouse.fact_trip`
(trip_key,date_key,pickup_location_key,dropoff_location_key,vendor_key,payment_type_key,ratecode_key,passenger_count,trip_distance,fare_amount,extra,mta_tax,tolls_amount,improvement_surcharge,congestion_surcharge,airport_fee,tip_amount,total_amount,trip_duration_minutes,total_fees_before_tip,tip_percent,fare_per_mile)
SELECT
ROW_NUMBER() OVER() AS trip_key,
CAST(FORMAT_DATE('%Y%m%d',DATE(s.tpep_pickup_datetime)) AS INT64) AS date_key,
pu.location_key,
do.location_key,
v.vendor_key,
p.payment_type_key,
r.ratecode_key,
s.passenger_count,
CAST(s.trip_distance AS NUMERIC),
CAST(s.fare_amount AS NUMERIC),
CAST(s.extra AS NUMERIC),
CAST(s.mta_tax AS NUMERIC),
CAST(s.tolls_amount AS NUMERIC),
CAST(s.improvement_surcharge AS NUMERIC),
CAST(s.congestion_surcharge AS NUMERIC),
CAST(s.airport_fee AS NUMERIC),
CAST(s.tip_amount AS NUMERIC),
CAST(s.total_amount AS NUMERIC),
TIMESTAMP_DIFF(s.tpep_dropoff_datetime,s.tpep_pickup_datetime,MINUTE),
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
LEFT JOIN `nyc_taxi_datawarehouse.dim_vendor` v ON s.VendorID=v.vendor_id
LEFT JOIN `nyc_taxi_datawarehouse.dim_payment_type` p ON s.payment_type=p.payment_type_id
LEFT JOIN `nyc_taxi_datawarehouse.dim_ratecode` r ON s.RatecodeID=r.ratecode_id
LEFT JOIN `nyc_taxi_datawarehouse.dim_location` pu ON s.PULocationID=pu.locationID
LEFT JOIN `nyc_taxi_datawarehouse.dim_location` do ON s.DOLocationID=do.locationID;
