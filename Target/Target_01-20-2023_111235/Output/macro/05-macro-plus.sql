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
CREATE TABLE ORG_DEV.PUBLIC.table_101
(
  column1 BYTEINT,
  -- column2 SMALLINT,
  column3 SMALLINT
);

CREATE OR REPLACE PROCEDURE ORG_DEV.PUBLIC.macro_1 (COLUMN1 FLOAT, COLUMN2 FLOAT, COLUMN3 FLOAT)
RETURNS STRING
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
 	// REGION SnowConvert Helpers Code
	var HANDLE_NOTFOUND;
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
	// END REGION
	
	EXEC(`DELETE FROM
	   ORG_DEV.PUBLIC.table_101
	WHERE
	   column1 = :1
	   AND column2 = :2
	   AND column3 = :3`,[COLUMN1,COLUMN2,COLUMN3]);
 
$$;

-- Simple Macro.
-----------
-- Table Setup.
/*** MSC-WARNING - MSCEWI2015 - SET TABLE FUNCTIONALITY NOT SUPPORTED. TABLE MIGHT HAVE DUPLICATE ROWS ***/
CREATE TABLE ORG_DEV.PUBLIC.TABLE1
(
  column1 VARCHAR(21) /*** MSC-WARNING - MSCEWI1036 - INTERVAL HOUR(2) DATA TYPE CONVERTED TO VARCHAR ***/,
  column2 INTEGER,
  column3 VARCHAR(10)
);

-- Macro. 
  CREATE OR REPLACE PROCEDURE PUBLIC.MacroSample01 (PARAMETER1 FLOAT)
  RETURNS STRING
  LANGUAGE JAVASCRIPT
  EXECUTE AS CALLER
  AS
  $$
 	// REGION SnowConvert Helpers Code
	var HANDLE_NOTFOUND;
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
	var procname = `PUBLIC.MacroSample01`;
	var temptable_prefix, tablelist = [];
	var INSERT_TEMP = function (query,parameters) {
	   if (!temptable_prefix) {
	      var sql_stmt = `select current_session() || '_' || to_varchar(current_timestamp, 'yyyymmddhh24missss')`;
	      var rs = snowflake.createStatement({
	         sqlText : sql_stmt,
	         binds : []
	      }).execute();
	      temptable_prefix = rs.next() && (procname + '_TEMP_' + rs.getColumnValue(1) + '_');
	   }
	   var tablename = temptable_prefix + tablelist.length;
	   tablelist.push(tablename);
	   var sql_stmt = `CREATE OR REPLACE TEMPORARY TABLE ${tablename} AS ${query}`;
	   snowflake.execute({
	      sqlText : sql_stmt,
	      binds : parameters
	   });
	   return tablename;
	};
	// END REGION
	
	INSERT_TEMP(`SELECT
	   *
	FROM
	   ORG_DEV.PUBLIC.TABLE1
	WHERE
	   column1 = :1`,[PARAMETER1]);
	return tablelist;
 
$$;

/************** ERROR HANDLERS *********************/
  -----------
  CREATE OR REPLACE PROCEDURE PUBLIC.ProcedureSample01 (PARAMETER1 FLOAT, SIZE FLOAT)
  RETURNS STRING
  LANGUAGE JAVASCRIPT
  EXECUTE AS CALLER
  AS
  $$
 	// REGION SnowConvert Helpers Code
	var HANDLE_NOTFOUND;
	var EXIT_HANDLER_EX = new Error("EXIT_HANDLER");
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
	// END REGION
	
	try {
	   var MYLOCALVARIABLE1;
	   var exit_handler_1 = function (error) {
	      {
	         EXEC(`CALL PUBLIC.LogErrorMacro('there was an error...')`,[],true);
	      }
	      throw EXIT_HANDLER_EX;
	   };
	   var ERROR_HANDLERS = function (error) {
	      switch(error.state) {
	         //Conversion Warning - handlers for the switch default (SQLWARNING/SQLEXCEPTION/NOT FOUND) can be the following
	         default:exit_handler_1(error);
	      }
	   };
	   INTERVAL_SIZE = SIZE == null && 5 || (SIZE != null && 6 || SIZE);
	   if ((SIZE == null && 200 || (SIZE != null && 1 || SIZE)) > 100) {
	      var sql_stmt = `ROLLBACK`;
	      EXEC(sql_stmt,[]);
	   }
	   EXEC(`SELECT
	   *
	FROM
	   ORG_DEV.PUBLIC.TABLE1
	WHERE
	   column1 = :1`,[PARAMETER1]);
	} catch(e) {
	   if (e != EXIT_HANDLER_EX) throw e;
	}
 
$$;

/************** ABORT STATEMENTS *********************/
  -----------
  CREATE OR REPLACE PROCEDURE PUBLIC.ProcedureSample02 (PARAMETER1 FLOAT, SIZE FLOAT)
  RETURNS STRING
  LANGUAGE JAVASCRIPT
  EXECUTE AS CALLER
  AS
  $$
 	// REGION SnowConvert Helpers Code
	var HANDLE_NOTFOUND;
	var fetch = (count,rows,stmt) => (count && rows.next() && Array.apply(null,Array(stmt.getColumnCount())).map((_,i) => rows.getColumnValue(i + 1))) || [];
	var BetweenFunc = function (expression,startExpr,endExpr) {
	   if ([expression,startExpr,endExpr].some((arg) => arg == null)) {
	      return false;
	   }
	   return expression >= startExpr && expression <= endExpr;
	};
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
	var INTO = () => fetch(ROW_COUNT,_ROWS,_RS);
	// END REGION
	
	if (EXEC(`(
	   SELECT
	      column1
	   FROM
	      PUBLIC.TABLE1
	)`,[]).INTO().includes(PARAMETER1)) {
	   var sql_stmt = `ROLLBACK`;
	   EXEC(sql_stmt,[]);
	   //** MSC-ERROR - MSCEWI1021 - ROLLBACK RETURN MESSAGE NOT SUPPORTED **
	   //`Parameter1 is invalid because it is already inside the column`
	}
	if ([1,3,5,7,9,11].includes(PARAMETER1)) {
	   var sql_stmt = `ROLLBACK`;
	   EXEC(sql_stmt,[]);
	   //** MSC-ERROR - MSCEWI1021 - ROLLBACK RETURN MESSAGE NOT SUPPORTED **
	   //`Parameter1 is invalid`
	}
	if (BetweenFunc(PARAMETER1,1,100)) {
	   var sql_stmt = `ROLLBACK`;
	   EXEC(sql_stmt,[]);
	   //** MSC-ERROR - MSCEWI1021 - ROLLBACK RETURN MESSAGE NOT SUPPORTED **
	   //`Parameter1 is invalid because ....`
	}
	EXEC(`SELECT
	   *
	FROM
	   ORG_DEV.PUBLIC.TABLE1
	WHERE
	   column1 = :1`,[PARAMETER1]);
 
$$;

/************** FOR CURSOR LOOP *********************/
  -----------
  CREATE OR REPLACE PROCEDURE PUBLIC.ProcedureSample03 (PARAMETER1 FLOAT, SIZE FLOAT)
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
	   column1,
	   column2,
	   column3
	FROM
	   ORG_DEV.PUBLIC.TABLE1`,[],false).OPEN();CUSGCLASS.NEXT();) {
	   let FUSGCLASS = CUSGCLASS.CURRENT;
	   {
	      var columnByteInt;
	      var columnInteger;
	      var columnVarchar;
	      columnByteInt = FUSGCLASS.COLUMN1 + 1;
	      columnInteger = FUSGCLASS.COLUMN2 + 1;
	      // ** MSC-WARNING - MSCEWI1038 - THIS STATEMENT MAY BE A DYNAMIC SQL THAT COULD NOT BE RECOGNIZED AND CONVERTED **
	      columnVarchar = `${FUSGCLASS.COLUMN3}HELLO WORLD`;
	      EXEC(`INSERT INTO PUBLIC.TABLE1
	VALUES (:columnByteInt, :columnInteger, :columnVarchar)`,[]);
	   }
	}
	CUSGCLASS.CLOSE();
 
$$;