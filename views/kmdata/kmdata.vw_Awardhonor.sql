create or replace view kmdata.vw_awardhonor as 
SELECT a.id, a.resource_id, a.user_id, a.monetary_amount, a.fellow_ind, d.name as follow_val,
	a.institution_id, ins.name as institution_Val, a.monetary_component_ind, c.name as monetary_component_val,
          a.honor_name, a.sponsor, a.subject, h.name as cip_Val, a.honor_type_id, k.type_name as honorName, a.competitiveness, f.name as award_eligibility,
            a.selected, e.name as selection_process,
          a.start_year, a.currency, a.eligibility_other, a.reach_of_award, g.name as award_reach, a.selection_process_other,
          a.end_year, a.type_of_award, b.name as awardType, a.type_of_award_other, a.url,
          a.created_at, a.updated_at
   FROM kmdata.user_honors_awards a
   left join researchinview.riv_award_types b on cast(a.type_of_award as int) = b.id
   left join researchinview.riv_yes_no c on a.monetary_component_ind = c.value
  left join researchinview.riv_yes_no d on a.fellow_ind = d.value
  left join researchinview.riv_award_selection_process e on e.id = cast(a.selected as int)
  left join researchinview.riv_award_eligibility f on f.id = cast(a.competitiveness as int)
  left join researchinview.riv_award_reach g on g.id = cast(a.reach_of_award as int)
  left join researchinview.riv_cip_lookup h on h.value = a.subject
  left JOIN kmdata.institutions ins ON a.institution_id = ins.id
  left join kmdata.honor_types k on k.id = a.honor_type_id