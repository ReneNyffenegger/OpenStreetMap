--
--     https://de.wikipedia.org/wiki/Gemeindenummer
--
.mode  column
.header on
.width 11 35 4

select
  rel_id,
  nam.val name,
  bfs.val bfs_no
from
  tag    bfs                join
  tag    nam using (rel_id)
where
  nam.key = 'name'                 and
  bfs.key = 'swisstopo:BFS_NUMMER' and
  bfs.val in (
    5391,
    5394,
    6391,    -- Not found, should be »Kommunanz Reckingen-Gluringen/Grafschaft«
    9040,
    9050,    -- Not found: Zürichsee
      9051,  
      9052,
      9053,
    9073,
    9089,
    9148,
      9149,
      9150,
    9151,
      9152,
      9153,
      9154,
      9155,
    9157,
    9163,
    9172,
      9173,
      9174,
    9175,
      9176,
      9177,
      9178,
    9179,
      9180,
      9181,
      9182,
      9183,
      9184,
    9216,
    9239,
    9267,
      9268,
      9269,
    9270,
    9276,
    9294,
      9295,
      9296,
    9326,
      9327,
      9328,
      9329,
    9710,
    9711,
    9751,
    9757,
      9758,
      9759,
      9760,
    7111,
    7101,
    7301, 7302, -- Campione, Land / Lake
    -- Liechtensetin
    7001,
    7002,
    7003,
    7004,
    7005,
    7006,
    7007,
    7008,
    7009,
    7010,
    7011  
);
