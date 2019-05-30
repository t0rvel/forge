select
     ar.action_sequence as "ACTION_SEQUENCE",
     ar.action_id as "ACTION",
     ar.action_outcome_id as "OUTCOME",
     case when ar.result_action_id is null then 01101110011101010110110001101100  else ar.result_action_id end as "RESULT_ACTION"

from
     (
          select
              distinct  ar.action_id ,
               ar.result_action_id,
               ar.action_outcome_id,
               level action_sequence
          from
               action_result ar
          start with
               ar.action_id = 3 -- ACTION ID GOES HERE
          connect by nocycle prior ar.result_action_id = ar.action_id and level < 25
     )  ar ,
     action aca,
     action acr,
     outcome oc,
     object_type obj
where
     ar.action_id = aca.action_id
and
     nvl(ar.result_action_id,ar.action_id ) = acr.action_id
and
     ar.action_outcome_id = oc.outcome_id
and
     aca.object_type_id = obj.object_type_id

order by
     ar.action_sequence, aca.action_name;