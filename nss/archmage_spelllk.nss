
#include "pb_nivellanzador"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"

/*
 * This is the spellhook code, called when the Spell-Like feat is activated
 */
void main()
{
    object focus = GetItemPossessedBy(OBJECT_SELF, "ArchmagesFocusofPower");
    int nMetaMagic = GetMetaMagicFeat();
    string nSpellLevel = Get2DAString("spells", "Wiz_Sorc", GetSpellId());
    string nEpicSpell = Get2DAString("spells", "Innate", GetSpellId());

    /* Whatever happens next we must restore the hook */
    SetModuleOverrideSpellscript(GetLocalString(GetModule(), "spelllike_save_overridespellscript"));

    /* Tell to not execute the original spell */
    SetModuleOverrideSpellScriptFinished();

    /* Timestop disabled */
    int iSpellId = GetSpellId();
    if (iSpellId == 185)
    {
        SendMessageToPC(OBJECT_SELF, "<c´$$>Este hechizo no parece funcionar con esta actitud sortilega.</c>");
        return;
    }

    /* Paranoia -- should never happen */
    if (!GetHasFeat(FEAT_SPELL_LIKE, OBJECT_SELF)) return;

    /* Only wizard/sorc spells */
    if ((nSpellLevel == "") && (nEpicSpell != "10" ))
    {
        FloatingTextStringOnCreature("Aptitud Sortilega solo puede usarse con conjuros memorizados.", OBJECT_SELF, FALSE);
        return;
    }

    /* No item casting */
    if (GetIsObjectValid(GetSpellCastItem()))
    {
        FloatingTextStringOnCreature("Aptitud Sortilega solo puede usarse con conjuros memorizados.", OBJECT_SELF, FALSE);
        return;
    }

    /* Setup is done */
    SetLocalInt(focus, "spell_like_setup", 0);

    /* Store all the info needed */
    SetLocalInt(focus, "spell_like_spell", GetSpellId());
    SetLocalInt(focus, "spell_like_meta", nMetaMagic);

    FloatingTextStringOnCreature("Aptitud Sortilega finalizada. Tu conjuro ha sido almacenado en el foco de poder arcano.", OBJECT_SELF, FALSE);
}
