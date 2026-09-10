import json

def S(v): return {"type":"cexostring","value":v}
def R(v): return {"type":"resref","value":v}
def D(v): return {"type":"dword","value":v}
def B(v): return {"type":"byte","value":v}
def T(v): return {"type":"cexolocstring","value":{"0":v}}
def L(v): return {"type":"list","value":v}

def link(idx, active="", param=None):
    d={"__struct_id":0,"Active":R(active),"Index":D(idx),"IsChild":B(0),"LinkComment":S("")}
    if param is not None:
        d["ConditionParams"]=L([{"__struct_id":0,"Key":S("idx"),"Value":S(str(param))}])
    return d

def entry(text):
    return {"__struct_id":0,"Animation":D(0),"AnimLoop":B(1),"Comment":S(""),
            "Delay":D(4294967295),"Quest":S(""),"Script":R(""),"Sound":R(""),
            "Text":T(text),"RepliesList":L([])}

# The button labels are tokens because a <cRGB> colour code is raw bytes the
# engine will not read inside dialogue text: it takes them for a token it does
# not know and prints UNRECOGNIZED TOKEN. The colour is applied by NWScript with
# ColorToken() when it fills each token instead. Tried in game: writing them
# into the .dlg leaves the menu unreadable.
#
# ONE TOKEN PER REPLY, even where two of them read the same.
#
# This did NOT fix the blank labels, and the reason it was written is wrong.
# Custom tokens are expanded by the client, not by the server, so a label comes
# out empty when the client is missing the value -- not when two replies share a
# number. Thirteen unique button tokens ask the client for more than the eight
# shared ones they replaced. Read D5 in documentation/oficios/cnr/open-issues.md
# before changing anything here: it carries the corrected counts and says plainly
# what is still only a hypothesis. The way out is NWNX_Dialog_SetCurrentNodeText,
# which needs a condition script on every reply, and eleven of these thirteen
# have none today.
BOTONES = []
TOKEN_BOTON = 5020

def verde(t):
    n = TOKEN_BOTON + len(BOTONES)
    BOTONES.append(t)
    return "<CUSTOM%d>" % n

def reply(text, script, links, param=None):
    r={"__struct_id":0,"Animation":D(0),"AnimLoop":B(1),"Comment":S(""),
       "Delay":D(4294967295),"Quest":S(""),"Script":R(script),"Sound":R(""),
       "Text":T(text),"EntriesList":L(links)}
    if param is not None:
        r["ActionParams"]=L([{"__struct_id":0,"Key":S("idx"),"Value":S(str(param))}])
    return r

# 0 root | 1 categories | 2 products | 3 detail | 4 variants
E=[entry("<CUSTOM5010>\n<CUSTOM5011>\n\nSelecciona una accion."),
   entry("<CUSTOM5010>\n<CUSTOM5011>\n\nSelecciona una categoria."),
   entry("<CUSTOM5010>\n<CUSTOM5011>\n\nSelecciona un producto.  DC = dificultad"),
   entry("<CUSTOM5012>"),
   entry("<CUSTOM5010>\n<CUSTOM5011>\n\nSelecciona que quieres fabricar")]

Rp=[]
def add(text, script, links, param=None):
    Rp.append(reply(text, script, links, param)); return len(Rp)-1

# State-conditional links: the engine picks the screen from where the menu is.
def destinos():
    return [link(4,"cnr_c_var"), link(3,"cnr_c_det"),
            link(2,"cnr_c_prod"), link(1,"cnr_c_cat")]

# Back climbs one rung and the engine has to honour the one the script worked
# out, so the link is conditional instead of always pointing at the categories.
def subir():
    return [link(2,"cnr_c_prod"), link(1,"cnr_c_cat"), link(0,"cnr_c_start")]

r_crear = add(verde("Crear nueva produccion"),             "cnr_a_browse", [link(1,"cnr_c_cat"), link(0,"cnr_c_start")])
r_porid = add(verde("Crear por ID (escribe el ID antes)"), "cnr_a_byid",   [link(4,"cnr_c_var"), link(3,"cnr_c_det"), link(0,"cnr_c_start")])
r_inv0  = add(verde("Abrir inventario"),                   "cnr_a_inv",    [])
r_fin0  = add(verde("Terminar"),                           "",             [])

# A single set of 5 slots: the destination is decided by the state, not by the
# reply.
slots=[add("<CUSTOM%d>"%(5000+i), "cnr_a_pick", destinos(), i) for i in range(5)]

r_next  = add(verde("[Pagina siguiente]"), "cnr_a_page", destinos(),  1)
r_prev  = add(verde("[Pagina anterior]"),  "cnr_a_page", destinos(), -1)
r_back  = add(verde("[Atras]"),            "cnr_a_back", subir())
r_inv1  = add(verde("Abrir inventario"),   "cnr_a_inv",  [])
r_fin1  = add(verde("Terminar"),           "",           [])

r_ok    = add(verde("Fabricar"),         "cnr_a_craft", [link(3,"cnr_c_det"), link(0,"cnr_c_start")])
r_back2 = add(verde("[Atras]"),          "cnr_a_back",  subir())
r_inv2  = add(verde("Abrir inventario"), "cnr_a_inv",   [])
r_fin2  = add(verde("Terminar"),         "",            [])

E[0]["RepliesList"]=L([link(i) for i in (r_crear,r_porid,r_inv0,r_fin0)])

def pantalla():
    return ([link(idx,"cnr_c_slot",i) for i,idx in enumerate(slots)] +
            [link(r_next,"cnr_c_next"), link(r_prev,"cnr_c_prev"),
             link(r_back), link(r_inv1), link(r_fin1)])

E[1]["RepliesList"]=L(pantalla())
E[2]["RepliesList"]=L(pantalla())
E[3]["RepliesList"]=L([link(i) for i in (r_ok,r_back2,r_inv2,r_fin2)])
E[4]["RepliesList"]=L(pantalla())

dlg={"__data_type":"DLG ","DelayEntry":D(0),"DelayReply":D(0),
     "EndConverAbort":R(""),"EndConversation":R(""),"NumWords":D(0),"PreventZoomIn":B(1),
     "EntryList":L(E),"ReplyList":L(Rp),
     "StartingList":L([{"__struct_id":0,"Active":R("cnr_c_start"),"Index":D(0)}])}
json.dump(dlg, open('src/cnr/dlg/cnr_c_station.dlg.json','w',encoding='utf-8'),
          ensure_ascii=False, indent=2)
print("entries=%d replies=%d botones=%d"%(len(E),len(Rp),len(BOTONES)))
for i,t in enumerate(BOTONES):
    print("  %d  %s" % (TOKEN_BOTON+i, t))
