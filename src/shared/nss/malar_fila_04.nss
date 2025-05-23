void main()
{
object oPC = GetLastUsedBy();
//definimos los ubicados a borrar, entre comillas la etiqueta del objeto.
object oJaulaM = GetNearestObjectByTag("Jaula_malar_13");
object oJaulaN = GetNearestObjectByTag("Jaula_malar_14");
object oJaulaO = GetNearestObjectByTag("Jaula_malar_15");
object oJaulaP = GetNearestObjectByTag("Jaula_malar_16");
//quitamos la propiedad trama a los objetos,
//recordad que si esta estatico, el script no funcionara, es importante quitarselo.
SetPlotFlag(oJaulaM, FALSE);
SetPlotFlag(oJaulaN, FALSE);
SetPlotFlag(oJaulaO, FALSE);
SetPlotFlag(oJaulaP, FALSE);
//destruimos los objetos.
DestroyObject(oJaulaM, 1.0);
DestroyObject(oJaulaN, 1.0);
DestroyObject(oJaulaO, 1.0);
DestroyObject(oJaulaP, 1.0);
//los efectos especiales.
effect eVisual = EffectVisualEffect(VFX_FNF_DISPEL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaM);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaN);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaO);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaP);
}
