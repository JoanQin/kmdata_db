-- Groups Phase
-- first run:  "Seeded department groups sync completed. 0 groups updated and 1398 groups inserted."
-- second run: "Seeded department groups sync completed. 0 groups updated and 0 groups inserted."
-- run 1/24/13:"Seeded department groups sync completed. 0 groups updated and 0 groups inserted."
--PROD FIRST RUN:"Seeded department groups sync completed. 0 groups updated and 1413 groups inserted."
SELECT kmdata.import_seeded_dept_groups();

-- Group Members Phase
-- first run:  "Seeded department group members sync completed. 0 members deleted and 60113 members inserted."
-- second run: "Seeded department group members sync completed. 0 members deleted and 0 members inserted."
-- run 1/24/13:"Seeded department group members sync completed. 12 members deleted and 4 members inserted."
--PROD FIRST RUN:"Seeded department group members sync completed. 0 members deleted and 61463 members inserted."
SELECT kmdata.import_seeded_dept_group_memberships();

