void main()
{
object oPC = GetLastUsedBy();
//definimos los ubicados a borrar, entre comillas la etiqueta del objeto.
object oJaulaI = GetNearestObjectByTag("Jaula_malar_09");
object oJaulaJ = GetNearestObjectByTag("Jaula_malar_10");
object oJaulaK = GetNearestObjectByTag("Jaula_malar_11");
object oJaulaL = GetNearestObjectByTag("Jaula_malar_12");
//quitamos la propiedad trama a los objetos,
//recordad que si esta estatico, el script no funcionara, es importante quitarselo.
SetPlotFlag(oJaulaI, FALSE);
SetPlotFlag(oJaulaJ, FALSE);
SetPlotFlag(oJaulaK, FALSE);
SetPlotFlag(oJaulaL, FALSE);
//destruimos los objetos.
DestroyObject(oJaulaI, 1.0);
DestroyObject(oJaulaJ, 1.0);
DestroyObject(oJaulaK, 1.0);
DestroyObject(oJaulaL, 1.0);
//los efectos especiales.
effect eVisual = EffectVisualEffect(VFX_FNF_DISPEL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaI);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaJ);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaK);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaL);
}
