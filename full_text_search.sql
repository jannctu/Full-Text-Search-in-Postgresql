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


    SELECT COUNT(*) AS rescnt
        FROM items
        WHERE plainto_tsquery('sketch') @@ tsv