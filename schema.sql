DROP TABLE IF EXISTS items;
CREATE TABLE items (id SERIAL, doc TEXT, tsv TSVECTOR);
CREATE TRIGGER tsvupdate BEFORE INSERT OR UPDATE ON items FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv, 'pg_catalog.english', doc);
CREATE INDEX fts_idx ON items USING GIN(tsv);