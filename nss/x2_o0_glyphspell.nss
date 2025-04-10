#include "x2_inc_itemprop"

void main()
{
   int nSpell = GetLastSpell();
   int iNivelInnato = StringToInt(Get2DAString("spells", "Innate", GetSpellId()));
   object oCreator = GetLocalObject(OBJECT_SELF,"X2_PLC_GLYPH_CASTER");
   object oCaster = GetLastSpellCaster();

    if (oCaster == oCreator)
    {
        if (iNivelInnato < 4 )   //esta linea limita los conjuros que absorbe el glifo a la 3a esfera
        SetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_SPELL",nSpell);
    }
    else
    // Dispel magic always
    if (nSpell ==    SPELL_DISPEL_MAGIC || nSpell == SPELL_GREATER_DISPELLING || nSpell == SPELL_LESSER_DISPEL || nSpell ==  SPELL_MORDENKAINENS_DISJUNCTION)
    {
        DestroyObject(OBJECT_SELF);
    }

}
