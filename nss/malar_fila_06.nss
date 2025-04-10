void main()
{
object oPC = GetLastUsedBy();
//definimos los ubicados a borrar, entre comillas la etiqueta del objeto.
object oJaulaU = GetNearestObjectByTag("Jaula_malar_21");
object oJaulaV = GetNearestObjectByTag("Jaula_malar_22");
object oJaulaX = GetNearestObjectByTag("Jaula_malar_23");
object oJaulaY = GetNearestObjectByTag("Jaula_malar_24");
//quitamos la propiedad trama a los objetos,
//recordad que si esta estatico, el script no funcionara, es importante quitarselo.
SetPlotFlag(oJaulaU, FALSE);
SetPlotFlag(oJaulaV, FALSE);
SetPlotFlag(oJaulaX, FALSE);
SetPlotFlag(oJaulaY, FALSE);
//destruimos los objetos.
DestroyObject(oJaulaU, 1.0);
DestroyObject(oJaulaV, 1.0);
DestroyObject(oJaulaX, 1.0);
DestroyObject(oJaulaY, 1.0);
//los efectos especiales.
effect eVisual = EffectVisualEffect(VFX_FNF_DISPEL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaU);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaV);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaX);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaY);
}
