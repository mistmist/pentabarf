
-- view for event_persons
CREATE OR REPLACE VIEW view_event_person AS
  SELECT event_person.event_person_id,
         event_person.event_id,
         event_person.person_id,
         event_person.event_role_id,
         event_person.event_role_state_id,
         event_person.remark,
         event_person.rank,
         event.title,
         event.subtitle,
         event.event_state_id,
         conference.conference_id,
         conference.acronym,
         view_person.name,
         view_event_state.language_id,
         view_event_state.language_tag,
         view_event_state.tag AS event_state_tag,
         view_event_state.name AS event_state,
         view_event_state_progress.tag AS event_state_progress_tag,
         view_event_state_progress.name AS event_state_progress,
         view_event_role.tag AS event_role_tag,
         view_event_role.name AS event_role,
         view_event_role_state.tag AS event_role_state_tag,
         view_event_role_state.name AS event_role_state
    FROM event_person
         INNER JOIN event USING (event_id)
         INNER JOIN conference USING (conference_id)
         INNER JOIN view_person USING (person_id)
         INNER JOIN view_event_state USING (event_state_id)
         INNER JOIN view_event_state_progress ON (
               view_event_state_progress.event_state_progress_id = event.event_state_progress_id AND
               view_event_state_progress.language_id = view_event_state.language_id)
         INNER JOIN view_event_role ON (
               view_event_role.event_role_id = event_person.event_role_id AND
               view_event_state.language_id = view_event_role.language_id)
         LEFT OUTER JOIN view_event_role_state ON (
               event_person.event_role_state_id = view_event_role_state.event_role_state_id AND
               view_event_state.language_id = view_event_role_state.language_id);
