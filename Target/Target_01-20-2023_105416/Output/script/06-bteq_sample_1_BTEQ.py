#*** Generated code is based on the SnowConvert Python Helpers version 2.0.6 ***
 
import os
import sys
import snowconvert.helpers
from snowconvert.helpers import Export
from snowconvert.helpers import exec
con = None
def main():
  snowconvert.helpers.configure_log()
  con = snowconvert.helpers.log_on()
  # <company="Mobilize.Net">
  #     Copyright (C) Mobilize.Net info@mobilize.net - All Rights Reserved
  #     This file is part of the Mobilize Frameworks, which is
  #     proprietary and confidential.
  #     NOTICE:  All information contained herein is, and remains
  #     the property of Mobilize.Net Corporation.
  #     The intellectual and technical concepts contained herein are
  #     proprietary to Mobilize.Net Corporation and may be covered
  #     by U.S. Patents, and are protected by trade secret or copyright law.
  #     Dissemination of this information or reproduction of this material
  #     is strictly forbidden unless prior written permission is obtained
  #     from Mobilize.Net Corporation.
  # </copyright>
  # Error handlers.
  snowconvert.helpers.set_error_level([3807], 0)

  if snowconvert.helpers.error_level > 0:
    ABEND()
    return
  # Setup.
  exec("""
    drop table PUBLIC.TABLE1
    """)
  exec("""
    drop table PUBLIC.TABLE2
    """)
  exec("""
    drop table PUBLIC.TABLE3
    """)
  snowconvert.helpers.set_error_level([3807], 8)

  if snowconvert.helpers.error_level > 0:
    ABEND()
    return
  snowconvert.helpers.set_error_level([3807], 0)

  if snowconvert.helpers.error_level > 0:
    LABEL_1()
    return
  # Building the table.
  exec("""
    CREATE TABLE PUBLIC.TABLE1 (
      column1 BYTEINT,
      column2 INTEGER,
      column3 VARCHAR(10)
    )
    """)
  LABEL_1()
  snowconvert.helpers.quit_application()
# Populating the table.
def LABEL_1():
  exec("""
    INSERT INTO PUBLIC.TABLE1
    VALUES (1, 1, '22')
    """)
  exec("""
    INSERT INTO PUBLIC.TABLE1
    VALUES (2, 2, '33')
    """)
  exec("""
    INSERT INTO PUBLIC.TABLE1
    VALUES (3, 3, '44')
    """)

  if snowconvert.helpers.error_level > 0:
    ABEND()
    return
  LABEL_2()
def LABEL_2():
  exec("""
    SELECT
      *
    FROM
      PUBLIC.TABLE1
    """)
  GOODEND()
# Finish.
def GOODEND():
  snowconvert.helpers.quit_application()
  ABEND()
def ABEND():
  snowconvert.helpers.quit_application(snowconvert.helpers.error_code)

if __name__ == "__main__":
  main()