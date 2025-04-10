// hcr3.1
// removed disabled logic.
// script that should be called from enter event of a null magic area or to
// remove all spell and supernatural effects which is what null magic areas do.
// thanks to Freezer for help on this.
#include "hc_inc"
#include "mti_libreria"
//hcr3.1

void RemoveSpells(object oPC)
{
    //Declare major variables
    effect eBad = GetFirstEffect(oPC);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        int nEtype=GetEffectType(eBad);
        if (GetEffectSubType(eBad) != SUBTYPE_EXTRAORDINARY)
            RemoveEffect( oPC, eBad );
        eBad = GetNextEffect(oPC);
    }
    // hcr3.1 removed disabled logic
    if (ObtenerIntPersistente(oTarget,"INDETECTABLE") == 1){ GuardarIntPersistente(oTarget,"INDETECTABLE",0);}


}
