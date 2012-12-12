select * from kmdata.user_preferred_names where first_name = 'John' and last_name = 'Wilkins';

DELETE FROM kmdata.user_preferred_names
WHERE id IN (
   SELECT upn_o.id
   FROM kmdata.user_preferred_names upn_o
   --WHERE upn_o.user_id = 726544
   WHERE upn_o.id != (SELECT MIN(id) FROM user_preferred_names upn_i WHERE upn_i.user_id = upn_o.user_id)
);

SELECT COUNT(*) FROM kmdata.user_preferred_names; -- pre: 7671, post: 1914

-- prod pre: 5925, post: 2960