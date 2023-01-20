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
/************** PROCEDURES *********************/
/***********************************************/


/************** MULTIPLE RESULT SETS *********************/
-----------
CREATE OR REPLACE PROCEDURE ORG_DEV.PUBLIC.DYNAMIC_RESULT_SETS ()
RETURNS STRING
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
 	// REGION SnowConvert Helpers Code
	var HANDLE_NOTFOUND;
	var fetch = (count,rows,stmt) => (count && rows.next() && Array.apply(null,Array(stmt.getColumnCount())).map((_,i) => rows.getColumnValue(i + 1))) || [];
	var _RS, ROW_COUNT, _ROWS, MESSAGE_TEXT, SQLCODE = 0, SQLSTATE = '00000', ERROR_HANDLERS, ACTIVITY_COUNT = 0, INTO, _OUTQUERIES = [], DYNAMIC_RESULTS = 2;
	var formatDate = (arg) => (new Date(arg - (arg.getTimezoneOffset() * 60000))).toISOString().slice(0,-1);
	var fixBind = function (arg) {
	   arg = arg == undefined ? null : arg instanceof Date ? formatDate(arg) : arg;
	   return arg;
	};
	var EXEC = function (stmt,binds,noCatch,catchFunction,opts) {
	   try {
	      binds = binds ? binds.map(fixBind) : binds;
	      _RS = snowflake.createStatement({
	            sqlText : stmt,
	            binds : binds
	         });
	      _ROWS = _RS.execute();
	      ROW_COUNT = _RS.getRowCount();
	      ACTIVITY_COUNT = _RS.getNumRowsAffected();
	      HANDLE_NOTFOUND && HANDLE_NOTFOUND(_RS);
	      if (INTO) return {
	         INTO : function () {
	            return INTO();
	         }
	      };
	      if (_OUTQUERIES.length < DYNAMIC_RESULTS) _OUTQUERIES.push(_ROWS.getQueryId());
	      if (opts && opts.temp) return _ROWS.getQueryId();
	   } catch(error) {
	      MESSAGE_TEXT = error.message;
	      SQLCODE = error.code;
	      SQLSTATE = error.state;
	      var msg = `ERROR CODE: ${SQLCODE} SQLSTATE: ${SQLSTATE} MESSAGE: ${MESSAGE_TEXT}`;
	      if (catchFunction) catchFunction(error);
	      if (!noCatch && ERROR_HANDLERS) ERROR_HANDLERS(error); else throw new Error(msg);
	   }
	};
	var CURSOR = function (stmt,binds,withReturn) {
	   var rs, rows, row_count, opened = false, resultsetTable = '', self = this;
	   this.CURRENT = new Object;
	   this.INTO = function () {
	         return self.res;
	      };
	   this.OPEN = function (usingParams) {
	         try {
	            if (usingParams) binds = usingParams;
	            if (binds instanceof Function) binds = binds();
	            var finalBinds = binds && binds.map(fixBind);
	            var finalStmt = stmt instanceof Function ? stmt() : stmt;
	            if (withReturn) {
	               resultsetTable = EXEC(finalStmt,finalBinds,true,null,{
	                     temp : true
	                  });
	               finalStmt = `SELECT * FROM TABLE(RESULT_SCAN('${resultsetTable}'))`;
	               finalBinds = [];
	            }
	            rs = snowflake.createStatement({
	                  sqlText : finalStmt,
	                  binds : finalBinds
	               });
	            rows = rs.execute();
	            row_count = rs.getRowCount();
	            ACTIVITY_COUNT = rs.getRowCount();
	            opened = true;
	            return this;
	         } catch(error) {
	            ERROR_HANDLERS && ERROR_HANDLERS(error);
	         }
	      };
	   this.NEXT = function () {
	         if (row_count && rows.next()) {
	            this.CURRENT = new Object;
	            for(let i = 1;i <= rs.getColumnCount();i++) {
	               (this.CURRENT)[rs.getColumnName(i)] = rows.getColumnValue(i);
	            }
	            return true;
	         } else return false;
	      };
	   this.FETCH = function () {
	         self.res = [];
	         self.res = fetch(row_count,rows,rs);
	         if (opened) if (self.res.length > 0) {
	            SQLCODE = 0;
	            SQLSTATE = '00000';
	         } else {
	            SQLCODE = 7362;
	            SQLSTATE = '02000';
	            var fetchError = new Error('There are not rows in the response');
	            fetchError.code = SQLCODE;
	            fetchError.state = SQLSTATE;
	            if (ERROR_HANDLERS) ERROR_HANDLERS(fetchError);
	         } else {
	            SQLCODE = 7631;
	            SQLSTATE = '24501';
	         }
	         return self.res && self.res.length > 0;
	      };
	   this.CLOSE = function () {
	         if (withReturn && _OUTQUERIES.includes(resultsetTable)) {
	            _OUTQUERIES.splice(_OUTQUERIES.indexOf(resultsetTable),1);
	         }
	         rs = rows = row_count = undefined;
	         opened = false;
	         resultsetTable = '';
	      };
	};
	let PROCRESULTS = (...OUTPARAMS) => JSON.stringify([...OUTPARAMS,[..._OUTQUERIES]]);
	// END REGION
	
	var SQL_CMD = ` `;
	var SQL_CMD_1 = ` `;
	var RESULTSET = new CURSOR(() => FIRSTSTATEMENT,[],true);
	var RESULTSET1 = new CURSOR(() => FIRSTSTATEMENT1,[],true);
	//------ MAIN --------
	SQL_CMD = `SELECT
	   * FROM
	   HR.PUBLIC.EMPLOYEE`;
	SQL_CMD_1 = `SELECT
	   * FROM
	   HR.PUBLIC.EMPLOYEE_PHONE_INFO`;
	//------ CURSORS --------
	var FIRSTSTATEMENT = SQL_CMD;
	RESULTSET.OPEN();
	var FIRSTSTATEMENT1 = SQL_CMD_1;
	RESULTSET1.OPEN();
	return PROCRESULTS();
 
$$;

/************** FOR CURSOR FOR STATEMENTS *********************/
-----------
CREATE OR REPLACE PROCEDURE ORG_DEV.PUBLIC.FOR_STATEMENT ()
RETURNS STRING
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
 	// REGION SnowConvert Helpers Code
	var HANDLE_NOTFOUND;
	var fetch = (count,rows,stmt) => (count && rows.next() && Array.apply(null,Array(stmt.getColumnCount())).map((_,i) => rows.getColumnValue(i + 1))) || [];
	var _RS, ROW_COUNT, _ROWS, MESSAGE_TEXT, SQLCODE = 0, SQLSTATE = '00000', ERROR_HANDLERS, ACTIVITY_COUNT = 0, INTO, _OUTQUERIES = [], DYNAMIC_RESULTS = -1;
	var formatDate = (arg) => (new Date(arg - (arg.getTimezoneOffset() * 60000))).toISOString().slice(0,-1);
	var fixBind = function (arg) {
	   arg = arg == undefined ? null : arg instanceof Date ? formatDate(arg) : arg;
	   return arg;
	};
	var EXEC = function (stmt,binds,noCatch,catchFunction,opts) {
	   try {
	      binds = binds ? binds.map(fixBind) : binds;
	      _RS = snowflake.createStatement({
	            sqlText : stmt,
	            binds : binds
	         });
	      _ROWS = _RS.execute();
	      ROW_COUNT = _RS.getRowCount();
	      ACTIVITY_COUNT = _RS.getNumRowsAffected();
	      HANDLE_NOTFOUND && HANDLE_NOTFOUND(_RS);
	      if (INTO) return {
	         INTO : function () {
	            return INTO();
	         }
	      };
	      if (_OUTQUERIES.length < DYNAMIC_RESULTS) _OUTQUERIES.push(_ROWS.getQueryId());
	      if (opts && opts.temp) return _ROWS.getQueryId();
	   } catch(error) {
	      MESSAGE_TEXT = error.message;
	      SQLCODE = error.code;
	      SQLSTATE = error.state;
	      var msg = `ERROR CODE: ${SQLCODE} SQLSTATE: ${SQLSTATE} MESSAGE: ${MESSAGE_TEXT}`;
	      if (catchFunction) catchFunction(error);
	      if (!noCatch && ERROR_HANDLERS) ERROR_HANDLERS(error); else throw new Error(msg);
	   }
	};
	var CURSOR = function (stmt,binds,withReturn) {
	   var rs, rows, row_count, opened = false, resultsetTable = '', self = this;
	   this.CURRENT = new Object;
	   this.INTO = function () {
	         return self.res;
	      };
	   this.OPEN = function (usingParams) {
	         try {
	            if (usingParams) binds = usingParams;
	            if (binds instanceof Function) binds = binds();
	            var finalBinds = binds && binds.map(fixBind);
	            var finalStmt = stmt instanceof Function ? stmt() : stmt;
	            if (withReturn) {
	               resultsetTable = EXEC(finalStmt,finalBinds,true,null,{
	                     temp : true
	                  });
	               finalStmt = `SELECT * FROM TABLE(RESULT_SCAN('${resultsetTable}'))`;
	               finalBinds = [];
	            }
	            rs = snowflake.createStatement({
	                  sqlText : finalStmt,
	                  binds : finalBinds
	               });
	            rows = rs.execute();
	            row_count = rs.getRowCount();
	            ACTIVITY_COUNT = rs.getRowCount();
	            opened = true;
	            return this;
	         } catch(error) {
	            ERROR_HANDLERS && ERROR_HANDLERS(error);
	         }
	      };
	   this.NEXT = function () {
	         if (row_count && rows.next()) {
	            this.CURRENT = new Object;
	            for(let i = 1;i <= rs.getColumnCount();i++) {
	               (this.CURRENT)[rs.getColumnName(i)] = rows.getColumnValue(i);
	            }
	            return true;
	         } else return false;
	      };
	   this.FETCH = function () {
	         self.res = [];
	         self.res = fetch(row_count,rows,rs);
	         if (opened) if (self.res.length > 0) {
	            SQLCODE = 0;
	            SQLSTATE = '00000';
	         } else {
	            SQLCODE = 7362;
	            SQLSTATE = '02000';
	            var fetchError = new Error('There are not rows in the response');
	            fetchError.code = SQLCODE;
	            fetchError.state = SQLSTATE;
	            if (ERROR_HANDLERS) ERROR_HANDLERS(fetchError);
	         } else {
	            SQLCODE = 7631;
	            SQLSTATE = '24501';
	         }
	         return self.res && self.res.length > 0;
	      };
	   this.CLOSE = function () {
	         if (withReturn && _OUTQUERIES.includes(resultsetTable)) {
	            _OUTQUERIES.splice(_OUTQUERIES.indexOf(resultsetTable),1);
	         }
	         rs = rows = row_count = undefined;
	         opened = false;
	         resultsetTable = '';
	      };
	};
	// END REGION
	
	for(var CUSGCLASS = new CURSOR(`SELECT
	   COL0,
	   TRIM(COL1) AS COL1ALIAS,
	   TRIM(COL2),
	   COL3
	FROM
	   ORG_DEV.PUBLIC.Some_Other_Table`,[],false).OPEN();CUSGCLASS.NEXT();) {
	   let FUSGCLASS = CUSGCLASS.CURRENT;
	   lvSeqNo = lvSeqNo + 1;
	   hola = FUSGCLASS.COL1ALIAS + 1;
	   HOLA2 = FUSGCLASS.COL3 + 123;
	}
	CUSGCLASS.CLOSE();
 
$$;

/************** DYNAMIC SQL, ACTIVITY_COUNT, CURSOR FOR, IF/THEN, Variable *********************/
-----------
CREATE OR REPLACE PROCEDURE "SNOWCONVERT".PUBLIC."CURSORS"
("V_TARGETTABLE" STRING
  )
RETURNS STRING
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
 	// REGION SnowConvert Helpers Code
	var HANDLE_NOTFOUND;
	var fetch = (count,rows,stmt) => (count && rows.next() && Array.apply(null,Array(stmt.getColumnCount())).map((_,i) => rows.getColumnValue(i + 1))) || [];
	var _RS, ROW_COUNT, _ROWS, MESSAGE_TEXT, SQLCODE = 0, SQLSTATE = '00000', ERROR_HANDLERS, ACTIVITY_COUNT = 0, INTO, _OUTQUERIES = [], DYNAMIC_RESULTS = 1;
	var formatDate = (arg) => (new Date(arg - (arg.getTimezoneOffset() * 60000))).toISOString().slice(0,-1);
	var fixBind = function (arg) {
	   arg = arg == undefined ? null : arg instanceof Date ? formatDate(arg) : arg;
	   return arg;
	};
	var EXEC = function (stmt,binds,noCatch,catchFunction,opts) {
	   try {
	      binds = binds ? binds.map(fixBind) : binds;
	      _RS = snowflake.createStatement({
	            sqlText : stmt,
	            binds : binds
	         });
	      _ROWS = _RS.execute();
	      ROW_COUNT = _RS.getRowCount();
	      ACTIVITY_COUNT = _RS.getNumRowsAffected();
	      HANDLE_NOTFOUND && HANDLE_NOTFOUND(_RS);
	      if (INTO) return {
	         INTO : function () {
	            return INTO();
	         }
	      };
	      if (_OUTQUERIES.length < DYNAMIC_RESULTS) _OUTQUERIES.push(_ROWS.getQueryId());
	      if (opts && opts.temp) return _ROWS.getQueryId();
	   } catch(error) {
	      MESSAGE_TEXT = error.message;
	      SQLCODE = error.code;
	      SQLSTATE = error.state;
	      var msg = `ERROR CODE: ${SQLCODE} SQLSTATE: ${SQLSTATE} MESSAGE: ${MESSAGE_TEXT}`;
	      if (catchFunction) catchFunction(error);
	      if (!noCatch && ERROR_HANDLERS) ERROR_HANDLERS(error); else throw new Error(msg);
	   }
	};
	var CURSOR = function (stmt,binds,withReturn) {
	   var rs, rows, row_count, opened = false, resultsetTable = '', self = this;
	   this.CURRENT = new Object;
	   this.INTO = function () {
	         return self.res;
	      };
	   this.OPEN = function (usingParams) {
	         try {
	            if (usingParams) binds = usingParams;
	            if (binds instanceof Function) binds = binds();
	            var finalBinds = binds && binds.map(fixBind);
	            var finalStmt = stmt instanceof Function ? stmt() : stmt;
	            if (withReturn) {
	               resultsetTable = EXEC(finalStmt,finalBinds,true,null,{
	                     temp : true
	                  });
	               finalStmt = `SELECT * FROM TABLE(RESULT_SCAN('${resultsetTable}'))`;
	               finalBinds = [];
	            }
	            rs = snowflake.createStatement({
	                  sqlText : finalStmt,
	                  binds : finalBinds
	               });
	            rows = rs.execute();
	            row_count = rs.getRowCount();
	            ACTIVITY_COUNT = rs.getRowCount();
	            opened = true;
	            return this;
	         } catch(error) {
	            ERROR_HANDLERS && ERROR_HANDLERS(error);
	         }
	      };
	   this.NEXT = function () {
	         if (row_count && rows.next()) {
	            this.CURRENT = new Object;
	            for(let i = 1;i <= rs.getColumnCount();i++) {
	               (this.CURRENT)[rs.getColumnName(i)] = rows.getColumnValue(i);
	            }
	            return true;
	         } else return false;
	      };
	   this.FETCH = function () {
	         self.res = [];
	         self.res = fetch(row_count,rows,rs);
	         if (opened) if (self.res.length > 0) {
	            SQLCODE = 0;
	            SQLSTATE = '00000';
	         } else {
	            SQLCODE = 7362;
	            SQLSTATE = '02000';
	            var fetchError = new Error('There are not rows in the response');
	            fetchError.code = SQLCODE;
	            fetchError.state = SQLSTATE;
	            if (ERROR_HANDLERS) ERROR_HANDLERS(fetchError);
	         } else {
	            SQLCODE = 7631;
	            SQLSTATE = '24501';
	         }
	         return self.res && self.res.length > 0;
	      };
	   this.CLOSE = function () {
	         if (withReturn && _OUTQUERIES.includes(resultsetTable)) {
	            _OUTQUERIES.splice(_OUTQUERIES.indexOf(resultsetTable),1);
	         }
	         rs = rows = row_count = undefined;
	         opened = false;
	         resultsetTable = '';
	      };
	};
	let PROCRESULTS = (...OUTPARAMS) => JSON.stringify([...OUTPARAMS,[..._OUTQUERIES]]);
	// END REGION
	
	var V_EMP_ID;
	var V_EMP_NAME;
	var V_MYSQLCODE;
	var V_MYSQLSTATE;
	var V_CNT;
	var V_KEEPCOUNT;
	var V_ACT_CNT;
	var CUR1 = new CURSOR(`SELECT
	   'EMPLOYEE' as id_el,
	   EMP_NAME as id_la
	FROM
	   HR.PUBLIC.EMPLOYEE`,[],false);
	var sql_stmt = `DELETE FROM
	   ORG_DEV.PUBLIC.ACT_COUNT;`;
	EXEC(sql_stmt,[]);
	V_ACT_CNT = ACTIVITY_COUNT;
	var sql_stmt = `INSERT INTO ORG_DEV.PUBLIC.ACT_COUNT
	VALUES (${V_ACT_CNT},'FIRST')`;
	EXEC(sql_stmt,[]);
	var sql_stmt = `DROP TABLE HR.PUBLIC.EMPLOYEE_DUPE;`;
	EXEC(sql_stmt,[]);
	var sql_stmt = `CREATE TABLE HR.PUBLIC.EMPLOYEE_DUPE AS (
	   SELECT
	      * FROM
	      HR.PUBLIC.EMPLOYEE
	);`;
	EXEC(sql_stmt,[]);
	var sql_stmt = `UPDATE HR.PUBLIC.EMPLOYEE_DUPE
	   SET EMP_NAME = 'BOB' WHERE EMP_ID <=2;`;
	EXEC(sql_stmt,[]);
	V_ACT_CNT = V_ACT_CNT + ACTIVITY_COUNT;
	var sql_stmt = `INSERT INTO ORG_DEV.PUBLIC.ACT_COUNT
	VALUES (${V_ACT_CNT},'SECOND')`;
	EXEC(sql_stmt,[]);
	var sql_stmt = `DELETE FROM
	   HR.PUBLIC.EMPLOYEE_DUPE
	   WHERE EMP_ID = 4;`;
	EXEC(sql_stmt,[]);
	V_ACT_CNT = V_ACT_CNT + ACTIVITY_COUNT;
	var sql_stmt = `INSERT INTO ORG_DEV.PUBLIC.ACT_COUNT
	VALUES (${V_ACT_CNT},'THIRD')`;
	EXEC(sql_stmt,[]);
	CUR1.OPEN();
	V_KEEPCOUNT = V_ACT_CNT - 1;
	V_CNT = 1;
	while ( V_CNT < V_KEEPCOUNT ) {
	   CUR1.FETCH() && ([V_EMP_ID,V_EMP_NAME] = CUR1.INTO());
	   var sql_stmt = `ALTER TABLE PUBLIC.${V_TARGETTABLE}
	ADD AT_${V_EMP_NAME} VARCHAR(85)`;
	   EXEC(sql_stmt,[]);
	   var sql_stmt = `UPDATE PUBLIC.${V_TARGETTABLE}
	   SET AT_${V_EMP_NAME} = (
	         SELECT
	            EMP_NAME FROM
	            HR.PUBLIC.EMPLOYEE
	         WHERE EMP_ID = ${V_CNT})`;
	   EXEC(sql_stmt,[]);
	   V_CNT = V_CNT + 1;
	}
	return PROCRESULTS();
 
$$;

CALL ORG_DEV.PUBLIC.CURSORS('EMPLOYEE_DUPE');

SELECT
	* FROM
	HR.PUBLIC.EMPLOYEE_DUPE;

/************** WHILE LOOP, DYNAMIC SQL, SYSTEM TABLE QUERIES, UPDATE RESTRUCTURE, IF/THEN *********************/
	-----------
	CREATE OR REPLACE PROCEDURE ORG_DEV.PUBLIC.CREATE_INSERTS
	(DB_NAME STRING, TBL_NAME STRING
-- ,OUT SSQQLL VARCHAR(10000)
	)
	RETURNS STRING
	LANGUAGE JAVASCRIPT
	EXECUTE AS CALLER
	AS
	$$
 	// REGION SnowConvert Helpers Code
	var HANDLE_NOTFOUND;
	var fetch = (count,rows,stmt) => (count && rows.next() && Array.apply(null,Array(stmt.getColumnCount())).map((_,i) => rows.getColumnValue(i + 1))) || [];
	var _RS, ROW_COUNT, _ROWS, MESSAGE_TEXT, SQLCODE = 0, SQLSTATE = '00000', ERROR_HANDLERS, ACTIVITY_COUNT = 0, INTO, _OUTQUERIES = [], DYNAMIC_RESULTS = 1;
	var formatDate = (arg) => (new Date(arg - (arg.getTimezoneOffset() * 60000))).toISOString().slice(0,-1);
	var fixBind = function (arg) {
	   arg = arg == undefined ? null : arg instanceof Date ? formatDate(arg) : arg;
	   return arg;
	};
	var EXEC = function (stmt,binds,noCatch,catchFunction,opts) {
	   try {
	      binds = binds ? binds.map(fixBind) : binds;
	      _RS = snowflake.createStatement({
	            sqlText : stmt,
	            binds : binds
	         });
	      _ROWS = _RS.execute();
	      ROW_COUNT = _RS.getRowCount();
	      ACTIVITY_COUNT = _RS.getNumRowsAffected();
	      HANDLE_NOTFOUND && HANDLE_NOTFOUND(_RS);
	      if (INTO) return {
	         INTO : function () {
	            return INTO();
	         }
	      };
	      if (_OUTQUERIES.length < DYNAMIC_RESULTS) _OUTQUERIES.push(_ROWS.getQueryId());
	      if (opts && opts.temp) return _ROWS.getQueryId();
	   } catch(error) {
	      MESSAGE_TEXT = error.message;
	      SQLCODE = error.code;
	      SQLSTATE = error.state;
	      var msg = `ERROR CODE: ${SQLCODE} SQLSTATE: ${SQLSTATE} MESSAGE: ${MESSAGE_TEXT}`;
	      if (catchFunction) catchFunction(error);
	      if (!noCatch && ERROR_HANDLERS) ERROR_HANDLERS(error); else throw new Error(msg);
	   }
	};
	var CURSOR = function (stmt,binds,withReturn) {
	   var rs, rows, row_count, opened = false, resultsetTable = '', self = this;
	   this.CURRENT = new Object;
	   this.INTO = function () {
	         return self.res;
	      };
	   this.OPEN = function (usingParams) {
	         try {
	            if (usingParams) binds = usingParams;
	            if (binds instanceof Function) binds = binds();
	            var finalBinds = binds && binds.map(fixBind);
	            var finalStmt = stmt instanceof Function ? stmt() : stmt;
	            if (withReturn) {
	               resultsetTable = EXEC(finalStmt,finalBinds,true,null,{
	                     temp : true
	                  });
	               finalStmt = `SELECT * FROM TABLE(RESULT_SCAN('${resultsetTable}'))`;
	               finalBinds = [];
	            }
	            rs = snowflake.createStatement({
	                  sqlText : finalStmt,
	                  binds : finalBinds
	               });
	            rows = rs.execute();
	            row_count = rs.getRowCount();
	            ACTIVITY_COUNT = rs.getRowCount();
	            opened = true;
	            return this;
	         } catch(error) {
	            ERROR_HANDLERS && ERROR_HANDLERS(error);
	         }
	      };
	   this.NEXT = function () {
	         if (row_count && rows.next()) {
	            this.CURRENT = new Object;
	            for(let i = 1;i <= rs.getColumnCount();i++) {
	               (this.CURRENT)[rs.getColumnName(i)] = rows.getColumnValue(i);
	            }
	            return true;
	         } else return false;
	      };
	   this.FETCH = function () {
	         self.res = [];
	         self.res = fetch(row_count,rows,rs);
	         if (opened) if (self.res.length > 0) {
	            SQLCODE = 0;
	            SQLSTATE = '00000';
	         } else {
	            SQLCODE = 7362;
	            SQLSTATE = '02000';
	            var fetchError = new Error('There are not rows in the response');
	            fetchError.code = SQLCODE;
	            fetchError.state = SQLSTATE;
	            if (ERROR_HANDLERS) ERROR_HANDLERS(fetchError);
	         } else {
	            SQLCODE = 7631;
	            SQLSTATE = '24501';
	         }
	         return self.res && self.res.length > 0;
	      };
	   this.CLOSE = function () {
	         if (withReturn && _OUTQUERIES.includes(resultsetTable)) {
	            _OUTQUERIES.splice(_OUTQUERIES.indexOf(resultsetTable),1);
	         }
	         rs = rows = row_count = undefined;
	         opened = false;
	         resultsetTable = '';
	      };
	};
	let PROCRESULTS = (...OUTPARAMS) => JSON.stringify([...OUTPARAMS,[..._OUTQUERIES]]);
	// END REGION
	
	var COL_NAME;
	var SUFFIX;
	var PREFIX;
	var MIDDLE;
	var PRE_STMT;
	var COL_TYPE;
	var PREV_COL_TYPE;
	var COL_LIST;
	var SQL_STMT;
	var SQL_CMD;
	var COL_COUNT;
	var NUM_COLS;
	var COL_LEN;
	var BIG_OBJ;
	var RESULTSET = new CURSOR(() => FIRSTSTATEMENT,[],true);
	var CUR2 = new CURSOR(`SELECT
	   COUNT(COLUMN_NAME)
	FROM
	   INFORMATION_SCHEMA.COLUMNS
	WHERE
	   TABLE_SCHEMA = :1
	   AND TABLE_NAME = :2
	GROUP BY
	   TABLE_SCHEMA,
	   TABLE_NAME
	ORDER BY
	   TABLE_NAME`,() => [DB_NAME,TBL_NAME],false);
	var CUR3 = new CURSOR(`SELECT
	   TRIM(UPPER(COLUMN_NAME))
	FROM
	   INFORMATION_SCHEMA.COLUMNS
	WHERE
	   TABLE_SCHEMA = :1
	   AND TABLE_NAME = :2
	ORDER BY
	   TABLE_SCHEMA,
	   TABLE_NAME,
	   COLUMN_NAME`,() => [DB_NAME,TBL_NAME],false);
	var CUR4 = new CURSOR(`SELECT
	   CASE
	      WHEN DATA_TYPE IN ('I', 'DA')
	         THEN 20
	      ELSE CHARACTER_MAXIMUM_LENGTH
	   END
	FROM
	   INFORMATION_SCHEMA.COLUMNS
	WHERE
	   TABLE_SCHEMA = :1
	   AND TABLE_NAME = :2
	ORDER BY
	   TABLE_SCHEMA,
	   TABLE_NAME,
	   COLUMN_NAME`,() => [DB_NAME,TBL_NAME],false);
	var CUR5 = new CURSOR(`SELECT
	   DATA_TYPE AS COLUMNTYPE
	FROM
	   INFORMATION_SCHEMA.COLUMNS
	WHERE
	   TABLE_SCHEMA = :1
	   AND TABLE_NAME = :2
	ORDER BY
	   TABLE_SCHEMA,
	   TABLE_NAME,
	   COLUMN_NAME`,() => [DB_NAME,TBL_NAME],false);
	var sql_stmt = `UPDATE PRODUCT.PUBLIC.DIMACCOUNT AS MOD_TBL
	   SET
	      MOD_TBL.ACCOUNTTYPE = 'Revenue' WHERE MOD_TBL.ACCOUNTKEY = 61;`;
	EXEC(sql_stmt,[]);
	var sql_stmt = `UPDATE PRODUCT.PUBLIC.DIMACCOUNT AS MOD_TBL
	   SET
	      MOD_TBL.ACCOUNTTYPE = 'Expenditures' WHERE MOD_TBL.ACCOUNTKEY = 61;`;
	EXEC(sql_stmt,[]);
	CUR2.OPEN();
	CUR3.OPEN();
	CUR4.OPEN();
	CUR5.OPEN();
	CUR2.FETCH() && ([NUM_COLS] = CUR2.INTO());
	CUR3.FETCH() && ([COL_NAME] = CUR3.INTO());
	CUR4.FETCH() && ([COL_LEN] = CUR4.INTO());
	CUR5.FETCH() && ([COL_TYPE] = CUR5.INTO());
	COL_COUNT = 2;
	COL_LIST = ``;
	SQL_STMT = ``;
	BIG_OBJ = 1;
	while ( BIG_OBJ != 0 ) {
	   if (COL_TYPE == `BO`) {
	      COL_COUNT = COL_COUNT + 1;
	      CUR3.FETCH() && ([COL_NAME] = CUR3.INTO());
	      CUR4.FETCH() && ([COL_LEN] = CUR4.INTO());
	      PREV_COL_TYPE = COL_TYPE;
	      CUR5.FETCH() && ([COL_TYPE] = CUR5.INTO());
	   } else {
	      BIG_OBJ = 0;
	   }
	}
	if ([`CLASS`,`DATE`,`CLASS`].includes(COL_NAME)) {
	   // ** MSC-WARNING - MSCEWI1038 - THIS STATEMENT MAY BE A DYNAMIC SQL THAT COULD NOT BE RECOGNIZED AND CONVERTED **
	   COL_NAME = `"${COL_NAME}"`;
	}
	// ** MSC-WARNING - MSCEWI1038 - THIS STATEMENT MAY BE A DYNAMIC SQL THAT COULD NOT BE RECOGNIZED AND CONVERTED **
	PREFIX = `SELECT 'INSERT INTO ${DB_NAME}.${TBL_NAME}(${COL_NAME}`;
	// ** MSC-WARNING - MSCEWI1038 - THIS STATEMENT MAY BE A DYNAMIC SQL THAT COULD NOT BE RECOGNIZED AND CONVERTED **
	PRE_STMT = `${`CAST(OREPLACE(TRIM(COALESCE(CAST("${COL_NAME}" AS VARCHAR(${COL_LEN})), '')), '''', '''''') AS VARCHAR(${COL_LEN}` + 5}))`;
	while ( COL_COUNT <= NUM_COLS ) {
	   CUR3.FETCH() && ([COL_NAME] = CUR3.INTO());
	   if ([`CLASS`,`DATE`,`CLASS`].includes(COL_NAME)) {
	      // ** MSC-WARNING - MSCEWI1038 - THIS STATEMENT MAY BE A DYNAMIC SQL THAT COULD NOT BE RECOGNIZED AND CONVERTED **
	      COL_NAME = `"${COL_NAME}"`;
	   }
	   CUR4.FETCH() && ([COL_LEN] = CUR4.INTO());
	   PREV_COL_TYPE = COL_TYPE;
	   CUR5.FETCH() && ([COL_TYPE] = CUR5.INTO());
	   if (COL_TYPE != `BO`) {
	      // ** MSC-WARNING - MSCEWI1038 - THIS STATEMENT MAY BE A DYNAMIC SQL THAT COULD NOT BE RECOGNIZED AND CONVERTED **
	      COL_LIST = `${COL_LIST}, ${COL_NAME}`;
	      if (PREV_COL_TYPE == `PD`) {
	         // ** MSC-WARNING - MSCEWI1038 - THIS STATEMENT MAY BE A DYNAMIC SQL THAT COULD NOT BE RECOGNIZED AND CONVERTED **
	         SQL_STMT = `${SQL_STMT} || ', `;
	      } else {
	         // ** MSC-WARNING - MSCEWI1038 - THIS STATEMENT MAY BE A DYNAMIC SQL THAT COULD NOT BE RECOGNIZED AND CONVERTED **
	         SQL_STMT = `${SQL_STMT} || ''', `;
	      }
	      if (COL_TYPE == `PD`) {
	         // ** MSC-WARNING - MSCEWI1038 - THIS STATEMENT MAY BE A DYNAMIC SQL THAT COULD NOT BE RECOGNIZED AND CONVERTED **
	         SQL_STMT = `${SQL_STMT}PERIOD (DATE''' || CAST(BEGIN(${COL_NAME}) AS VARCHAR(10)) || ''', DATE ''' || CAST(END(${COL_NAME})AS VARCHAR(10)) || ''')'`;
	      } else {
	         // ** MSC-WARNING - MSCEWI1038 - THIS STATEMENT MAY BE A DYNAMIC SQL THAT COULD NOT BE RECOGNIZED AND CONVERTED **
	         SQL_STMT = `${`${SQL_STMT}''' || CAST(OREPLACE(TRIM(COALESCE(CAST("${COL_NAME}" AS VARCHAR(${COL_LEN})), '')), '''', '''''') AS VARCHAR(${COL_LEN}` + 5}))`;
	      }
	   }
	   COL_COUNT = COL_COUNT + 1;
	}
	// ** MSC-WARNING - MSCEWI1038 - THIS STATEMENT MAY BE A DYNAMIC SQL THAT COULD NOT BE RECOGNIZED AND CONVERTED **
	SUFFIX = ` || ''');' "--"  FROM ${DB_NAME}.${TBL_NAME};`;
	MIDDLE = `) VALUES(''' || `;
	// ** MSC-WARNING - MSCEWI1038 - THIS STATEMENT MAY BE A DYNAMIC SQL THAT COULD NOT BE RECOGNIZED AND CONVERTED **
	SQL_CMD = `${PREFIX}${COL_LIST}${MIDDLE}${PRE_STMT}${SQL_STMT}${SUFFIX}`;
	//		SET SSQQLL = SQL_CMD;	
	var FIRSTSTATEMENT = SQL_CMD;
	RESULTSET.OPEN();
	return PROCRESULTS();
 
$$;