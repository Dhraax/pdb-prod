//::////////////////////////////////////////////////////////////////////////////
//:: Skript fuer den OnSpawn-Slot einer Kreatur
//::////////////////////////////////////////////////////////////////////////////
//::
//:: Wendet einen permanenten visuellen Effekt auf die Kreatur an. Einige
//:: Besondere andere Effekte sind ebenfalls veruegbar.
//::
//:: Variablen:
//:: Name:              Type:       Value:
//:: "odth_eff_id"      int         Visual effect ID from the visualeffects.2da
//::
//::////////////////////////////////////////////////////////////////////////////

const string ODTH_EFFECT_LVAR_ID  = "odth_eff_id";

//::////////////////////////////////////////////////////////////////////////////

void main()
{
    object oTarget = OBJECT_SELF;

    int nEffectID  = GetLocalInt(OBJECT_SELF, ODTH_EFFECT_LVAR_ID);

    effect eEffect = EffectVisualEffect(nEffectID);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eEffect, GetLocation(oTarget));
}
