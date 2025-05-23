void main()
{
object oPC = GetLastUsedBy();
//definimos los ubicados a borrar, entre comillas la etiqueta del objeto.
object oJaulaA = GetNearestObjectByTag("Jaula_malar_01");
object oJaulaB = GetNearestObjectByTag("Jaula_malar_02");
object oJaulaC = GetNearestObjectByTag("Jaula_malar_03");
object oJaulaD = GetNearestObjectByTag("Jaula_malar_04");
//quitamos la propiedad trama a los objetos,
//recordad que si esta estatico, el script no funcionara, es importante quitarselo.
SetPlotFlag(oJaulaA, FALSE);
SetPlotFlag(oJaulaB, FALSE);
SetPlotFlag(oJaulaC, FALSE);
SetPlotFlag(oJaulaD, FALSE);
//destruimos los objetos.
DestroyObject(oJaulaA, 1.0);
DestroyObject(oJaulaB, 1.0);
DestroyObject(oJaulaC, 1.0);
DestroyObject(oJaulaD, 1.0);
//los efectos especiales.
effect eVisual = EffectVisualEffect(VFX_FNF_DISPEL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaA);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaB);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaC);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaD);
}
