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
       print "Nodes: " + str(cnt_node)

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
       print "Ways: " + str(cnt_way)

#   cur.execute(
#      'insert into way(id) values (?)',
#      (way.WayID, ))


    order_ = 0
    for nd in way.Nds:

        cur.execute(
#         'insert into node_in_way ' +
          'insert into nod_way ' +
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
       print "Relations: " + str(cnt_relation)

#   cur.execute(
#     'insert into relation(id) values (?)',
#     (relation.RelID, ))

    for m in relation.Members:

        if    m.type == 'node':

              cur.execute("""
    
                insert into nod_rel (
                  nod_id,
                  rel_of,
                  rol
                )
                values (?, ?, ?) """,
                
                (relation.RelID, m.ref, m.role))

        elif  m.type == 'way':

              cur.execute("""
              
                insert into way_rel (
                  way_id,
                  rel_of,
                  rol
                )
                values (?, ?, ?) """,
              
              (relation.RelID, m.ref, m.role))

        elif  m.type == 'relation': 

              cur.execute("""
              
                 insert into rel_rel (
                   rel_id,
                   rel_of,
                   rol
                 )
                 values (?, ?, ?)""",
              (relation.RelID, m.ref, m.role))

        else: print "unexpected type: " + m.type


    for k in relation.Tags.keys():

        cur.execute("""
        
            insert into tag (
              rel_id,
              key,
              val
            ) values (?, ?, ?)""",
            (relation.RelID, k, relation.Tags[k]))

def create_schema():
    
    cur.execute("""
        create table nod (
          id  integer primary key,
          lat real not null,
          lon real not null
        )""")
      

#   cur.execute("""
#   
#       create table way(
#         id integer primary key
#       )""")


#   cur.execute("""
#
#       create table relation(
#         id integer primary key
#       )""")


#   cur.execute("""
#   
#       create table node_in_way (
#         way_id  integer not null 
#            --   references way
#            --   deferrable initially deferred,
#         node_id integer not null
#            --   references node
#            --   deferrable initially deferred,
#         order_  integer not null
#       )""")

    cur.execute("""
        create table nod_way (
          way_id  integer not null,
             --   references way
             --   deferrable initially deferred,
          nod_id  integer not null,
             --   references node
             --   deferrable initially deferred,
          order_  integer not null
        )""")


#   cur.execute("""
#   
#       create table member_in_relation(
#         id_of_relation integer not null
#                        references relation
#                        deferrable initially deferred,
#         node_id        integer null 
#                        references node
#                        deferrable initially deferred,
#         way_id         integer null
#                        references way
#                        deferrable initially deferred,
#         relation_id    integer null 
#                        references relation
#                        deferrable initially deferred,
#         role           text
#       )""")


    cur.execute("""
        create table nod_rel (
          nod_id         integer not null,
                 --      references relation
                 --      deferrable initially deferred,
          rel_of         integer null,
                 --      references node
                 --      deferrable initially deferred,
--        way_id         integer null
--                       references way
--                       deferrable initially deferred,
--        relation_id    integer null 
--                       references relation
--                       deferrable initially deferred,
          rol            text
        )""")


    cur.execute("""
        create table way_rel (
          way_id         integer not null,
                 --      references relation
                 --      deferrable initially deferred,
          rel_of         integer null,
                 --      references node
                 --      deferrable initially deferred,
--        way_id         integer null
--                       references way
--                       deferrable initially deferred,
--        relation_id    integer null 
--                       references relation
--                       deferrable initially deferred,
          rol            text
        )""")

    cur.execute("""
        create table rel_rel (
          rel_id         integer not null,
                 --      references relation
                 --      deferrable initially deferred,
          rel_of         integer null,
                 --      references node
                 --      deferrable initially deferred,
--        way_id         integer null
--                       references way
--                       deferrable initially deferred,
--        relation_id    integer null 
--                       references relation
--                       deferrable initially deferred,
          rol            text
        )""")


    cur.execute("""
    
        create table tag(
          nod_id      integer null,
--                    references node
--                    deferrable initially deferred,
          way_id      integer null,
--                    references way
--                    deferrable initially deferred,
          rel_id      integer null,
--                    references relation
--                    deferrable initially deferred,
          key         text not null,
          val         text not null
        )""")


def execute_sql(stmt):

    t_ = time.time()

    cur.execute(stmt)
    
    print "{:d} seconds for {:s}".format(
          int(time.time() - t_), stmt)

#   -----------------------------------------

if len(sys.argv) != 3:
   print "pbf2sqlite.py pbf-file sqlite-db-file"
   sys.exit(0)

# First argument is *.pbf file name
pbf_filename = sys.argv[1]

# second argument is *.db file name
db_filename  = sys.argv[2]

# delete db if exists
if os.path.isfile(db_filename):
   os.remove(db_filename)

db  = sqlite3.connect(db_filename)
db.text_factory = str

# Makes inserts slower, so comment it:
# db.execute('pragma foreign_keys=on')

cur = db.cursor()

create_schema()

t_ = time.time()
OSMpbfParser.go(
  pbf_filename,
  callback_node,
  callback_way,
  callback_relation)

print "pbf file loaded, took {:d} seconds".format(int (time.time() -t_))


t_ = time.time()
db.commit()
print "commited, took {:d} seconds".format(int (time.time() -t_))

# execute_sql('create index nod_way_ix_way_id  on nod_ay (way_id)')
# 
# execute_sql('create index nod_way_ix_nod_id on nod_way (nod_id)')
# 
# execute_sql('create index tag_ix_val        on tag      (val)'  )
# 
# execute_sql('create index tag_ix_key_val    on tag (key, val)'  )
# 
# execute_sql('create index tag_ix_nod_id     on tag (nod_id)'    )
# 
# execute_sql('create index tag_ix_way_id     on tag (way_id)'    )
# 
# execute_sql('create index tag_ix_rel_id     on tag (rel_id)'    )
# 
# execute_sql('create index nod_rel_ix_nod_id on nod_rel(nod_id)' )
# 
# execute_sql('create index way_rel_ix_nod_id on way_rel(way_id)' )
# 
# execute_sql('create index rel_rel_ex_rel_id on rel_rel(rel_id)' )
