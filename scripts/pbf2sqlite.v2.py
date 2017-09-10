#      Make sure pbf-parser is found:
import sys
sys.path.append('pbf-parser')

import os
import sqlite3
import sys
import time
import OSMpbfParser

cnt_node     =     0
cnt_way      =     0
cnt_relation =     0
cnt_         = 10000

def callback_node(node):

    global cnt_node
    cnt_node += 1
    if cnt_node % cnt_ == 0:
       print("Nodes: " + str(cnt_node))

    cur.execute(
      'insert into nod ' +
      '(id, lat, lon) values (?, ?, ?)' , 
      (node.NodeID, node.Lat, node.Lon))

    for k in node.Tags.keys():

        cur.execute(
          'insert into tag ' +
          '(nod_id, key, val) values (?, ?, ?)',
          (node.NodeID, k, node.Tags[k]))


def callback_way(way):

    global cnt_way
    cnt_way += 1
    if cnt_way % cnt_ == 0:
       print("Ways: " + str(cnt_way))

    order_ = 0
    for nd in way.Nds:

        cur.execute(
          'insert into nod_way '    +
          '(way_id, nod_id, order_)'+
          'values (?, ?, ?)',
          (way.WayID, nd, order_))

        order_ += 1


    for k in way.Tags.keys():
        cur.execute(
         'insert into tag (way_id, key, val) values (?, ?, ?)',
        (way.WayID, k, way.Tags[k]))


def callback_relation(relation):

    global cnt_relation
    cnt_relation += 1
    if cnt_relation % cnt_ == 0:
       print("Relations: " + str(cnt_relation))

    order_ = 0
    for m in relation.Members:

        if    m.type == 'node':

              cur.execute("""
                 insert into rel_mem (
                   rel_of,
                   order_,
                   nod_id,
                   rol
                 ) values (?, ?, ?, ?) """,

                 (relation.RelID, order_, m.ref, m.role))


#v1              cur.execute("""
#v1    
#v1                insert into nod_rel (
#v1                  nod_id,
#v1                  rel_of,
#v1                  rol
#v1                )
#v1                values (?, ?, ?) """,
#v1                
#v1                (m.ref, relation.RelID, m.role))

        elif  m.type == 'way':

              cur.execute("""
                 insert into rel_mem (
                   rel_of,
                   order_,
                   way_id,
                   rol
                 ) values (?, ?, ?, ?) """,

                 (relation.RelID, order_, m.ref, m.role))

#v.1          cur.execute("""
#v.1          
#v.1            insert into way_rel (
#v.1              way_id,
#v.1              rel_of,
#v.1              rol
#v.1            )
#v.1            values (?, ?, ?) """,
#v.1          
#v.1          (m.ref, relation.RelID, m.role))

        elif  m.type == 'relation': 

              cur.execute("""
                 insert into rel_mem (
                   rel_of,
                   order_,
                   rel_id,
                   rol
                 ) values (?, ?, ?, ?) """,

                 (relation.RelID, order_, m.ref, m.role))

#v.1           cur.execute("""
#v.1           
#v.1              insert into rel_rel (
#v.1                rel_id,
#v.1                rel_of,
#v.1                rol
#v.1              )
#v.1              values (?, ?, ?)""",
#v.1           (m.ref, relation.RelID, m.role))

        else: print("unexpected type: " + m.type)

        order_ += 1


    for k in relation.Tags.keys():

        cur.execute("""
        
            insert into tag (
              rel_id,
              key,
              val
            ) values (?, ?, ?)""",
            (relation.RelID, k, relation.Tags[k]))

# moved to pm def create_schema():
# moved to pm     
# moved to pm     cur.execute("""
# moved to pm         create table nod (
# moved to pm           id  integer primary key,
# moved to pm           lat real not null,
# moved to pm           lon real not null
# moved to pm         )""")
# moved to pm 
# moved to pm     cur.execute("""
# moved to pm         create table nod_way (
# moved to pm           way_id         integer not null,
# moved to pm           nod_id         integer not null,
# moved to pm           order_         integer not null
# moved to pm         )""")
# moved to pm 
# moved to pm     cur.execute("""
# moved to pm         create table rel_mem (
# moved to pm           rel_of         integer not null,
# moved to pm           order_         integer not null,
# moved to pm           way_id         integer,
# moved to pm           nod_id         integer,
# moved to pm           rel_id         integer,
# moved to pm           rol            text
# moved to pm        )""")
# moved to pm 
# moved to pm 
# moved to pm #v.1    cur.execute("""
# moved to pm #v.1        create table nod_rel (
# moved to pm #v.1          nod_id         integer not null,
# moved to pm #v.1          rel_of         integer null,
# moved to pm #v.1          rol            text
# moved to pm #v.1        )""")
# moved to pm #v.1
# moved to pm #v.1
# moved to pm #v.1    cur.execute("""
# moved to pm #v.1        create table way_rel (
# moved to pm #v.1          way_id         integer not null,
# moved to pm #v.1          rel_of         integer null,
# moved to pm #v.1          rol            text
# moved to pm #v.1        )""")
# moved to pm #v.1
# moved to pm #v.1    cur.execute("""
# moved to pm #v.1        create table rel_rel (
# moved to pm #v.1          rel_id         integer not null,
# moved to pm #v.1          rel_of         integer null,
# moved to pm #v.1          rol            text
# moved to pm #v.1        )""")
# moved to pm 
# moved to pm 
# moved to pm     cur.execute("""
# moved to pm     
# moved to pm         create table tag(
# moved to pm           nod_id      integer null,
# moved to pm           way_id      integer null,
# moved to pm           rel_id      integer null,
# moved to pm           key         text not null,
# moved to pm           val         text not null
# moved to pm         )""")


def execute_sql(stmt):

    t_ = time.time()

    cur.execute(stmt)
    
    print("{:d} seconds for {:s}".format(
          int(time.time() - t_), stmt))

#   -----------------------------------------

if len(sys.argv) != 3:
   print("pbf2sqlite.py pbf-file sqlite-db-file")
   sys.exit(0)

# First argument is *.pbf file name
pbf_filename = sys.argv[1]

# second argument is *.db file name
db_filename  = sys.argv[2]

# moved to pm # delete db if exists
# moved to pm if os.path.isfile(db_filename):
# moved to pm    os.remove(db_filename)

db  = sqlite3.connect(db_filename)
db.text_factory = str

# Makes inserts slower, so comment it:
# db.execute('pragma foreign_keys=on')

cur = db.cursor()

# moved to pm create_schema()

t_ = time.time()
OSMpbfParser.go(
  pbf_filename,
  callback_node,
  callback_way,
  callback_relation)

print("pbf file loaded, took {:d} seconds".format(int (time.time() -t_)))


t_ = time.time()
db.commit()
print("commited, took {:d} seconds".format(int (time.time() -t_)))

# execute_sql('create index nod_way_ix_way_id  on nod_ay (way_id)')
# 
# execute_sql('create index nod_way_ix_nod_id on nod_way (nod_id)')

# print("!!!!! !!!!!!!!!!!!!!!!!!!!!!!! !!!!!")
# print("!!!!! Use pm to create indexes !!!!!")
# print("!!!!! !!!!!!!!!!!!!!!!!!!!!!!! !!!!!")
# moved to pm execute_sql('create index nod_way_ix_way_id on nod_way (way_id)'   )
# moved to pm 
# moved to pm execute_sql('create index tag_ix_val        on tag     (     val)' )
# moved to pm execute_sql('create index tag_ix_key_val    on tag     (key, val)' )
# moved to pm 
# moved to pm execute_sql('create index tag_ix_nod_id     on tag     (nod_id)'   )
# moved to pm execute_sql('create index tag_ix_way_id     on tag     (way_id)'   )
# moved to pm execute_sql('create index tag_ix_rel_id     on tag     (rel_id)'   )

# 
# execute_sql('create index nod_rel_ix_nod_id on nod_rel(nod_id)' )
# 
# execute_sql('create index way_rel_ix_nod_id on way_rel(way_id)' )
# 
# execute_sql('create index rel_rel_ex_rel_id on rel_rel(rel_id)' )

# 2017-09-05: moved to pm execute_sql('analyze' )
