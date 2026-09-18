-- Apply only the needle durability adjustment to an existing catalogue.
-- Idempotent; does not rebuild recipes or touch character progress.
UPDATE cnr_station_tool AS t
JOIN cnr_station AS s ON s.station_id = t.station_id
SET t.breakage_chance = 3.0
WHERE t.tool_tag = 'cnr_t_aguja'
  AND s.tag IN ('cnrTailorsTable', 'cnrSewingTable');
