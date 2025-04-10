void main()
{
object oPC = GetLastUsedBy();
//definimos los ubicados a borrar, entre comillas la etiqueta del objeto.
object oJaulaQ = GetNearestObjectByTag("Jaula_malar_17");
object oJaulaR = GetNearestObjectByTag("Jaula_malar_18");
object oJaulaS = GetNearestObjectByTag("Jaula_malar_19");
object oJaulaT = GetNearestObjectByTag("Jaula_malar_20");
//quitamos la propiedad trama a los objetos,
//recordad que si esta estatico, el script no funcionara, es importante quitarselo.
SetPlotFlag(oJaulaQ, FALSE);
SetPlotFlag(oJaulaR, FALSE);
SetPlotFlag(oJaulaS, FALSE);
SetPlotFlag(oJaulaT, FALSE);
//destruimos los objetos.
DestroyObject(oJaulaQ, 1.0);
DestroyObject(oJaulaR, 1.0);
DestroyObject(oJaulaS, 1.0);
DestroyObject(oJaulaT, 1.0);
//los efectos especiales.
effect eVisual = EffectVisualEffect(VFX_FNF_DISPEL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaQ);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaR);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaS);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaT);
}
