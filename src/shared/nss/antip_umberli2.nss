void main()
{
object oPC = GetEnteringObject();

object oArma = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

if(GetBaseItemType(oArma) != BASE_ITEM_TRIDENT)
    {
    effect e1 = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY_FEMALE);
    effect e2 = EffectVisualEffect(VFX_IMP_PULSE_WATER);
    effect e3 = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_MIND);
    effect e4 = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);
    object oWP = GetNearestObjectByTag("WP_Muerteahogado");
    location loc = GetLocation(oWP);

    ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectKnockdown(),oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectDamage(d20(6),DAMAGE_TYPE_SONIC),oPC);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e2,loc);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e3,loc);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,e4,loc);
    DelayCommand(0.3,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e2,loc,3.0));
    DelayCommand(0.5,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e1,loc,3.0));
    DelayCommand(0.5,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e2,loc,3.0));
    DelayCommand(0.7,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e3,loc));
    DelayCommand(0.7,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e1,loc,3.0));
    DelayCommand(0.7,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e2,loc,3.0));
    DelayCommand(0.9,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e1,loc,3.0));
    DelayCommand(0.9,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e2,loc,3.0));
    DelayCommand(1.1,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e1,loc,3.0));
    DelayCommand(1.1,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e2,loc,3.0));
    DelayCommand(1.1,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,e3,loc));
    }
}
