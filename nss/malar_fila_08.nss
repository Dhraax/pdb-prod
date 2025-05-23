void main()
{
object oPC = GetLastUsedBy();
//definimos los ubicados a borrar, entre comillas la etiqueta del objeto.
object oJaulaEE = GetNearestObjectByTag("Jaula_malar_29");
object oJaulaFF = GetNearestObjectByTag("Jaula_malar_30");
object oJaulaGG = GetNearestObjectByTag("Jaula_malar_31");
object oJaulaHH = GetNearestObjectByTag("Jaula_malar_32");
//quitamos la propiedad trama a los objetos,
//recordad que si esta estatico, el script no funcionara, es importante quitarselo.
SetPlotFlag(oJaulaEE, FALSE);
SetPlotFlag(oJaulaFF, FALSE);
SetPlotFlag(oJaulaGG, FALSE);
SetPlotFlag(oJaulaHH, FALSE);
//destruimos los objetos.
DestroyObject(oJaulaEE, 1.0);
DestroyObject(oJaulaFF, 1.0);
DestroyObject(oJaulaGG, 1.0);
DestroyObject(oJaulaHH, 1.0);
//los efectos especiales.
effect eVisual = EffectVisualEffect(VFX_FNF_DISPEL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaEE);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaFF);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaGG);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaHH);
}
