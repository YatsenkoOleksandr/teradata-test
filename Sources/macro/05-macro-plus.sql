
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

/***********************************************/
/****************** MACROS *********************/
/***********************************************/

-- Parameters vs column declarations in a Macro / Procedure.
-----------
CREATE TABLE ORG_DEV.table_101
(
  column1 BYTEINT,
  -- column2 SMALLINT,
  column3 SMALLINT
)
 
REPLACE MACRO ORG_DEV.macro_1 (
  column1 BYTEINT NOT NULL,
  column2 SMALLINT NOT NULL,
  column3 SMALLINT NOT NULL)
AS
(
  DELETE FROM ORG_DEV.table_101
  WHERE column1 = :column1
  AND column2 = :column2
  AND column3 = :column3;
);

-- Simple Macro.
-----------
-- Table Setup.
CREATE SET TABLE ORG_DEV.TABLE1 ,NO FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO
     (
         column1 INTERVAL HOUR(2),
         column2 INTEGER,
         column3 VARCHAR(10)
     );

-- Macro. 
REPLACE MACRO MacroSample01 (
parameter1 BYTEINT NOT NULL)
AS (
   SELECT * FROM ORG_DEV.TABLE1 WHERE column1 = parameter1;
);

/************** ERROR HANDLERS *********************/
-----------
REPLACE PROCEDURE ProcedureSample01(parameter1 INTEGER, SIZE INTEGER)
BEGIN
DECLARE  myLocalVariable1 INTEGER;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
             CALL LogErrorMacro('there was an error...');
        END;

SET INTERVAL_SIZE = CASE 
              WHEN SIZE  IS NULL THEN 5 
              WHEN SIZE  IS NOT NULL THEN 6 
              ELSE SIZE 
            END;

IF ((CASE 
        WHEN SIZE  IS NULL THEN 200
        WHEN SIZE  IS NOT NULL THEN 1 
        ELSE SIZE 
    END) > 100) THEN
        ABORT;
END IF;

SELECT * FROM ORG_DEV.TABLE1 WHERE column1 = :parameter1;

END;


/************** ABORT STATEMENTS *********************/
-----------
REPLACE PROCEDURE ProcedureSample02(parameter1 INTEGER, SIZE INTEGER)
BEGIN

ABORT 'Parameter1 is invalid because it is already inside the column' 
WHERE parameter1 IN (SELECT column1 FROM TABLE1);

ABORT 'Parameter1 is invalid' 
WHERE parameter1 IN (1,3,5,7,9,11);


ABORT 'Parameter1 is invalid because ....' 
WHERE parameter1 BETWEEN 1 AND 100;

SELECT * FROM ORG_DEV.TABLE1 WHERE column1 = :parameter1;

END;


/************** FOR CURSOR LOOP *********************/
-----------
REPLACE PROCEDURE ProcedureSample03(parameter1 INTEGER, SIZE INTEGER)
BEGIN

FOR fUsgClass AS cUsgClass CURSOR FOR
    SELECT 
        column1,
        column2,
        column3
    FROM ORG_DEV.TABLE1
DO
    BEGIN
        DECLARE columnByteInt INTEGER;
        DECLARE columnInteger INTEGER;
        DECLARE columnVarchar varchar(1000);
        SET columnByteInt = fUsgClass.column1 + 1;
        SET columnInteger = fUsgClass.column2 + 1;
        SET columnVarchar = fUsgClass.column3 || 'HELLO WORLD';
        INSERT INTO TABLE1 VALUES(:columnByteInt, :columnInteger, :columnVarchar);
    END;
END FOR;

END;
