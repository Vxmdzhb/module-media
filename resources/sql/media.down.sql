-- Teardown for the Media module (tools/module.php purge media).
-- Destructive: removes its pages and drops the media table. Reinstall the
-- schema (tools/install.php) to restore. On-disk files under the configured
-- media upload dir are NOT removed here — clear them manually if required.

DELETE FROM `page` WHERE `module` = 'media';

DROP TABLE IF EXISTS `media`;

-- A nav entry whose page is gone is dangling: delete its id-allocator row,
-- which cascades to the entry (navbar_entry.id references navbar_entry_ids).
-- Allocator rows with no entry at all are removed too.
DELETE nid FROM `navbar_entry_ids` nid
  JOIN `navbar_entry` ne ON ne.id = nid.id
  LEFT JOIN `navbar_internal` ni ON ni.id = ne.id
  LEFT JOIN `navbar_external` nx ON nx.id = ne.id
 WHERE ni.id IS NULL AND nx.id IS NULL;
DELETE nid FROM `navbar_entry_ids` nid
  LEFT JOIN `navbar_entry` ne ON ne.id = nid.id
 WHERE ne.id IS NULL;
