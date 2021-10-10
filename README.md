# Full-Text Seach in Postgresql 

This project demonstrates a **full-text search (FTS)** feature in Postgresql. 

`Postgresql` comes with `tsquery` and `tsvector` to build fast and efficient full-text functionality. 

I used `Docker` to run the `postgresql` and `pgadmin` environment. If you have `Postgresql` environment running on your machine, you may skip the docker part. 

## Postgresql FTS in Action 
1. Clone this repository 
2. Create your `.env` file 
```
DB_USER=YOUR_DB_USER
DB_PASSWORD=YOUR_DB_PASS
DB_NAME=YOUR_DB_NAME
PGADMIN_EMAIL=youremail@gmail.com
PGADMIN_PASSWORD=YOUR_PG_pass
```
3. Run your `Postgresql` environment using `Docker`
```
docker-compose up -d 
```

4. Login to PgAdmin.  Go to `localhost:5050`
5. Connect to your `Postgresql` server. 
6. Create Table & Index 
```sql
DROP TABLE IF EXISTS items;
CREATE TABLE items (id SERIAL, doc TEXT, tsv TSVECTOR);
CREATE TRIGGER tsvupdate BEFORE INSERT OR UPDATE ON items FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tsv, 'pg_catalog.english', doc);
CREATE INDEX fts_idx ON items USING GIN(tsv);
```
7. Populate your table
```sql
INSERT INTO items (doc) VALUES('Sketching the trees');
INSERT INTO items (doc) VALUES ('Girl on a train');
INSERT INTO items (doc) VALUES ('A sketch is a rapidly executed freehand drawing that is not usually intended as a finished work. ');
INSERT INTO items (doc) VALUES ('Try these sketching tips to improve your drawing and pencil sketching and get inspired by a roundup of pencil sketches.');
INSERT INTO items (doc) VALUES ('Sketching is a natural way for people to explain and understand complex ideas and to per form visual and spatial reasoning.');
```
8. Full-text Searching query
```sql
WITH q AS (SELECT plainto_tsquery('sketch') AS query),
    ranked AS (
    SELECT id, doc, ts_rank(tsv, query) AS rank
        FROM items, q
        WHERE q.query @@ tsv
        ORDER BY rank DESC
        LIMIT 2 OFFSET 1
    )
    SELECT id, ts_headline(doc, q.query, 'MaxWords=75,MinWords=25,ShortWord=3,MaxFragments=3,FragmentDelimiter="||||"')
    FROM ranked, q
    ORDER BY ranked DESC
```

```sql
    SELECT COUNT(*) AS rescnt
        FROM items
        WHERE plainto_tsquery('sketch') @@ tsv
```

## Notes 
This `Postgresql` FTS may not sufficient for an enterprise system with heavy searching in Text. For more advanced FTS, you may consider to implement FTS in a dedicated search database, such as [Elasticsearch](https://github.com/jannctu/Fast-Searching-using-Flask-and-Elasticsearch). 
