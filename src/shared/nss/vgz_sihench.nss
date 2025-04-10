int StartingConditional()
{
if( (
(GetTag(OBJECT_SELF) == "guerreroesqueletico01")||
(GetTag(OBJECT_SELF) == "guerreroesqueletico02")||
(GetTag(OBJECT_SELF) == "guerreroesqueletico03")||
(GetTag(OBJECT_SELF) == "calaveraanimada")||
(GetTag(OBJECT_SELF) == "nomuertoalzado")||
(GetTag(OBJECT_SELF) == "libroanimado")||
(GetTag(OBJECT_SELF) == "vgz_baulanimado")||
(GetTag(OBJECT_SELF) == "vgz_mesaanimada")||
(GetTag(OBJECT_SELF) == "golemdeentranas")||
(GetTag(OBJECT_SELF) == "temp_merc_perro")||
(GetTag(OBJECT_SELF) == "raicessutekhbis") )&&
(GetMaster(OBJECT_SELF) == GetPCSpeaker())) return TRUE;


return FALSE;
}
