void main()
{
  object oPC = GetLastDisturbed();
  object oObjeto = GetFirstItemInInventory();

  if(GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_REMOVED)
  {
      if(GetIsObjectValid(oObjeto) == FALSE)
      {
          FloatingTextStringOnCreature("<cþ<<>* Accionas una trampa oculta *</c>", oPC);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d10(8), DAMAGE_TYPE_SLASHING), oPC);
          ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SWINGING_BLADE), GetLocation(OBJECT_SELF));
      }
  }
}
