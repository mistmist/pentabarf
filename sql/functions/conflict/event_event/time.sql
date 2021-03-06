
-- returns events with conflicting timeslots
CREATE OR REPLACE FUNCTION conflict.conflict_event_event_time(integer) RETURNS SETOF conflict.conflict_event_event AS $$
  DECLARE
    cur_conference_id ALIAS FOR $1;
    cur_event RECORD;
    cur_event2 RECORD;
    conflicting_event conflict.conflict_event_event%ROWTYPE;
  BEGIN
-- Loop through all events
    FOR cur_event IN
      SELECT event_id, start_time, duration, conference_day_id, conference_room_id
        FROM event
        WHERE event.conference_id = cur_conference_id AND
              event.event_state = 'accepted' AND
              event.event_state_progress <> 'canceled' AND
              event.conference_day_id IS NOT NULL AND
              event.start_time IS NOT NULL
    LOOP
      FOR cur_event2 IN
        SELECT event_id
          FROM event
          WHERE event.conference_day_id IS NOT NULL AND
                event.start_time IS NOT NULL AND
                event.conference_day_id = cur_event.conference_day_id AND
                event.event_state = 'accepted' AND
                event.event_state_progress <> 'canceled' AND
                event.event_id <> cur_event.event_id AND
                event.conference_id = cur_conference_id AND
                event.conference_room_id = cur_event.conference_room_id AND
                (( event.start_time >= cur_event.start_time AND
                   event.start_time < cur_event.start_time + cur_event.duration ) OR
                 ( event.start_time + event.duration > cur_event.start_time AND
                   event.start_time + event.duration <= cur_event.start_time + cur_event.duration ))
      LOOP
        conflicting_event.event_id1 := cur_event.event_id;
        conflicting_event.event_id2 := cur_event2.event_id;
        RETURN NEXT conflicting_event;
      END LOOP;
    END LOOP;
    RETURN;
  END;
$$ LANGUAGE 'plpgsql' RETURNS NULL ON NULL INPUT;

