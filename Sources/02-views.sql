
/**********
<company="Mobilize.Net">
    Copyright (C) Mobilize.Net info@mobilize.net - All Rights Reserved
    This file is part of the Mobilize Frameworks, which is
    proprietary and confidential.
    NOTICE:  All information contained herein is, and remains
    the property of Mobilize.Net Corporation.
    The intellectual and technical concepts contained herein are
    proprietary to Mobilize.Net Corporation and may be covered
    by U.S. Patents, and are protected by trade secret or copyright law.
    Dissemination of this information or reproduction of this material
    is strictly forbidden unless prior written permission is obtained
    from Mobilize.Net Corporation.
</copyright>
**********/

/*******************************************************/
/************** INTERVAL FUNCTIONS *********************/
/*******************************************************/
---------
REPLACE VIEW PRODUCT_VIEWS.INTERVAL_FUNCTION
AS
SELECT
TO_DATE('2000-01-01') - CAST(731 AS INTERVAL DAY(4)) INT_DAY,
TO_DATE('2000-01-01') - CAST(12 AS INTERVAL MONTH(4)) INT_MONTH,
TO_DATE('2000-01-01') - CAST(2 AS INTERVAL YEAR(4)) INT_YEAR,
TO_DATE('2000-01-01') + INTERVAL '14' DAY INT_DAY_ALT,
TIMESTAMP '2000-01-01 01:01:01.500-01:00' + CAST('10:15' AS INTERVAL HOUR(2) TO MINUTE) INT_HR2MIN,
TIMESTAMP '2000-01-01 01:01:01.500-01:00' + CAST('23:59:59.999999' AS INTERVAL HOUR(2) TO SECOND(6)) INT_HR2SEC,
CAST(TIMESTAMP '2005-02-03 12:12:12.340000' AS PERIOD(TIMESTAMP)),
CAST(TIMESTAMP '2005-02-03 12:12:12.340000' AS PERIOD(DATE));


/**************************************************/
/************** TRUNC & ROUND *********************/
/**************************************************/
---------
REPLACE VIEW PRODUCT_VIEWS.vtruncround
AS
select 
    region, 
    TRUNC(DATEFIRSTPURCHASE, 'MON') TRUNC_DATE,
    TRUNC(DATEFIRSTPURCHASE) TRUNC_DATE_DD,
    ROUND(DATEFIRSTPURCHASE, 'RM') RND_DATE,
    avg(yearlyincome) avg_annual_income,
    TRUNC(AVG(YEARLYINCOME)) TRUNC_INCOME,
    TRUNC(AVG(YEARLYINCOME), 2) TRNC_INCOME_2,
    ROUND(AVG(TOTALCHILDREN),0) RND_AVG_CHILDREN,
    avg(totalchildren) avg_children, 
    ROUND(AVG(AGE)) RND_AVG_AGE,
    avg(age) avg_age 
from PRODUCT_VIEWS.vtargetmail
where datefirstpurchase in ('2011-02-08', '2011-02-09')
group by 
    region, 
    TRUNC(DATEFIRSTPURCHASE, 'MON'),
    TRUNC(DATEFIRSTPURCHASE),
    ROUND(DATEFIRSTPURCHASE, 'RM');


/***************************************************/
/************** RECURSIVE VIEW *********************/
/***************************************************/
---------
REPLACE RECURSIVE VIEW HR_VIEWS.REACHABLE_FROM (DESTINATION, COST, LEGS) AS (
      SELECT 
        ROOT.DESTINATION, 
        ROOT.COST, 
        1 AS LEGS
      FROM 
        HR.FLIGHTS AS ROOT
      WHERE 
        ROOT.SOURCE = 'Paris'
    UNION ALL
      SELECT 
        OUTT.DESTINATION, 
        INN.COST + OUTT.COST, 
        INN.LEGS + 1 AS LEGS
      FROM 
        REACHABLE_FROM AS INN, 
        HR.FLIGHTS AS OUTT
      WHERE 
        INN.DESTINATION = OUTT.SOURCE
        AND INN.LEGS <= 20);        
 -- SELECT * FROM HR_VIEWS.REACHABLE_FROM;




/**********************************************************************************/
/************** CTAS WITH DATA, QUALIFY, FORWARD ALIAS REFERENCE ******************/
/**********************************************************************************/
---------



/******************************************************/
/************** CTAS WITH NO DATA *********************/
/******************************************************/
---------
CREATE TABLE SALES_VIEWS.FACTFINANCE_COPY_WITHOUT_DATA 
AS SALES_VIEWS.FACTFINANCE
WITH NO DATA;


/*****************************************************************************************************/
/************** INTERVAL, PERIOD TYPES, SELECT * LOCKING ROW FOR ACCESS, QUALIFY *********************/
/*****************************************************************************************************/
---------
REPLACE VIEW PRODUCT_VIEWS.INTERVAL_DATA_TYPE_V
AS 
LOCKING ROW FOR ACCESS
SELECT * FROM PRODUCT_VIEWS.INTERVAL_DATA_TYPE;

---------
REPLACE VIEW HR_VIEWS.PERIOD_OVERLAP_LDIFF
AS 
LOCKING ROW FOR ACCESS
SELECT 'OVERLAP' FUNC, FIRST_NAME, LAST_NAME
FROM HR_VIEWS.EMPLOYEE_PERIOD
WHERE JOB_DURATION OVERLAPS
PERIOD(DATE '2009-01-01', DATE '2010-09-24')
UNION ALL
SELECT 'LDIFF' FUNC, FIRST_NAME, LAST_NAME
FROM HR_VIEWS.EMPLOYEE_PERIOD
WHERE INTERVAL(JOB_DURATION LDIFF PERIOD(DATE '2009-01-01', DATE '2010-09-24')) MONTH > 3
UNION ALL
SELECT 'RDIFF' FUNC, FIRST_NAME, LAST_NAME
FROM HR_VIEWS.EMPLOYEE_PERIOD
WHERE JOB_DURATION RDIFF PERIOD(DATE '2009-01-01', DATE '2010-09-24') IS NOT NULL;


---------
REPLACE VIEW PRODUCT_VIEWS.INTERVAL_DATA
AS
SELECT 
TO_DATE('2000-01-01') + INTERVAL_YEAR_TYPE INTERVAL_YEAR, 
TO_DATE('2000-01-01') + INTERVAL_MONTH_TYPE INTERVAL_MONTH,
TO_DATE('2000-01-01') + INTERVAL_YEAR2MONTH_TYPE INTERVAL_YR2MON,
TIMESTAMP '2000-01-01 01:01:01.500-01:00' + INTERVAL_DAY_TYPE INTERVAL_DAY,
TIMESTAMP '2000-01-01 01:01:01.500-01:00' + INTERVAL_DAY2HOUR_TYPE INTERVAL_DAY2HR,
TIMESTAMP '2000-01-01 01:01:01.500-01:00' + INTERVAL_DAY2MINUTE_TYPE INTERVAL_DAY2MIN,
TIMESTAMP '2000-01-01 01:01:01.500-01:00' + INTERVAL_DAY2SECOND_TYPE INTERVAL_DAY2SEC,
TIMESTAMP '2000-01-01 01:01:01.500-01:00' + INTERVAL_HOUR_TYPE INTERVAL_HR,
TIMESTAMP '2000-01-01 01:01:01.500-01:00' + INTERVAL_HOUR2MINUTE_TYPE INTERVAL_HR2MIN,
TIMESTAMP '2000-01-01 01:01:01.500-01:00' + INTERVAL_HOUR2SECOND_TYPE INTERVAL_HR2SEC,
TIMESTAMP '2000-01-01 01:01:01.500-01:00' + INTERVAL_MINUTE_TYPE INTERVAL_MIN,
TIMESTAMP '2000-01-01 01:01:01.500-01:00' + INTERVAL_MINUTE2SECOND_TYPE INTERVAL_MIN2SEC,
TIMESTAMP '2000-01-01 01:01:01.500-01:00' + INTERVAL_SECOND_TYPE INTERVAL_SEC
FROM
PRODUCT_VIEWS.INTERVAL_DATA_TYPE_V;

---------
REPLACE VIEW PRODUCT_VIEWS.PERIOD_INTERVAL_BEGIN
AS
SELECT
  PEP.PERSON_ID,
  CAST(BEGIN(PEP.EMPLOYMENT_PERIOD) AS TIMESTAMP)    AS BEGINEMPLOYMENT,
  PL.LOGIN_DTM,
  INTERVAL(
    PERIOD(
      CAST(BEGIN(PEP.EMPLOYMENT_PERIOD) AS TIMESTAMP),
      PL.LOGIN_DTM
    )
  ) HOUR(4) AS HOURSBEFOREFIRSTLOGIN
FROM SNOWCONVERT.PERSON_EMPLOYMENT_PERIOD    AS PEP
JOIN SNOWCONVERT.PERSON_LOGIN                AS PL
  ON PEP.PERSON_ID = PL.PERSON_ID
QUALIFY RANK() OVER (
  PARTITION BY PL.PERSON_ID
  ORDER BY PL.LOGIN_DTM
) = 1;
