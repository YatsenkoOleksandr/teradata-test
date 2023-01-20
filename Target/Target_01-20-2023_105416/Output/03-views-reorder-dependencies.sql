/*** MSC-WARNING - MSCEWI1050 - MISSING DEPENDENT OBJECT "ORG_DEV.TABLE099" ***/

-- View created from a table that does not exist in any file uploaded.
CREATE OR REPLACE VIEW ORG_DEV.PUBLIC.MY_VIEW_12
AS
SELECT
  * FROM
  ORG_DEV.PUBLIC.TABLE099;

  /*** MSC-WARNING - MSCEWI1050 - MISSING DEPENDENT OBJECT "ORG_DEV.SOME_MISSING_OBJECT" ***/

  -- MY VIEW 3
  CREATE OR REPLACE VIEW ORG_DEV.PUBLIC.MY_VIEW_3
  AS
  SELECT
  * FROM
  ORG_DEV.PUBLIC.SOME_MISSING_OBJECT;

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

  /************** ILLUSTRATED DEPENDENCIES *********************/

  -- View created from a table that exists in a different file.
  CREATE OR REPLACE VIEW ORG_DEV.PUBLIC.MY_VIEW_11
  AS
  SELECT
  * FROM
  ORG_DEV.PUBLIC.TABLE1;

  -- MY VIEW 2
  CREATE OR REPLACE VIEW ORG_DEV.PUBLIC.MY_VIEW_2
  AS
  SELECT
  MY_COLUMN FROM
  ORG_DEV.PUBLIC.MY_VIEW_3;

  /****************** VIEW REORDERING **************************/

  -- MY VIEW 1
  CREATE OR REPLACE VIEW ORG_DEV.PUBLIC.MY_VIEW_1
  AS
  SELECT
  MY_COLUMN FROM
  ORG_DEV.PUBLIC.MY_VIEW_2;