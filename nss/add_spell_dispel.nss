/** Script de modificacion Disipacion Conjuros:
Añadir en este Script cualquier modificacion referente a la Disipacion de conjuros, devolviendo el valor a traves de nDP **/

void main()
{

object oCaster = OBJECT_SELF;
object oTarget = GetSpellTargetObject();
int nDP = 0;


//Magia Tenaz
if( GetHasFeat(1355, oTarget) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_ILLUSION || GetHasFeat(1355, oTarget) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_ENCHANTMENT
|| GetHasFeat(1355, oTarget) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_NECROMANCY)
    {
     nDP += 5;
     //SetLocalInt(oTarget, "X2_L_LAST_RETVAR", nDP);
     SendMessageToPC(oTarget, "Magia Tenaz: Tu resistencia a la disipacion se ha modificado en " + IntToString(nDP));
    }

SetLocalInt(oTarget, "X2_L_LAST_RETVAR", nDP);


}