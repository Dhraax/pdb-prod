void main()
{
object oPC = GetLastUsedBy();
//definimos los ubicados a borrar, entre comillas la etiqueta del objeto.
object oJaulaAA = GetNearestObjectByTag("Jaula_malar_25");
object oJaulaBB = GetNearestObjectByTag("Jaula_malar_26");
object oJaulaCC = GetNearestObjectByTag("Jaula_malar_27");
object oJaulaDD = GetNearestObjectByTag("Jaula_malar_28");
//quitamos la propiedad trama a los objetos,
//recordad que si esta estatico, el script no funcionara, es importante quitarselo.
SetPlotFlag(oJaulaAA, FALSE);
SetPlotFlag(oJaulaBB, FALSE);
SetPlotFlag(oJaulaCC, FALSE);
SetPlotFlag(oJaulaDD, FALSE);
//destruimos los objetos.
DestroyObject(oJaulaAA, 1.0);
DestroyObject(oJaulaBB, 1.0);
DestroyObject(oJaulaCC, 1.0);
DestroyObject(oJaulaDD, 1.0);
//los efectos especiales.
effect eVisual = EffectVisualEffect(VFX_FNF_DISPEL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaAA);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaBB);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaCC);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaDD);
}
