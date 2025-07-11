/** Script de modificacion de las salvaciones en conjuros CD:
Añadir en este Script cualquier modificacion referente a las tiradas de salvacion CD , devolviendo el valor a traves de nDC **/

void main()
{

object oCaster = OBJECT_SELF;
object oTarget = GetSpellTargetObject();

int nDC = 0;

//Bonificador UrdimbreSombria (Si el lanzador tiene Urdimbre sombria y el conjuro es de Ilusion, Encantamiento o Nigromancia la CD aumenta en 1.
if( GetHasFeat(1354, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_ILLUSION || GetHasFeat(1354, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_ENCHANTMENT
|| GetHasFeat(1354, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_NECROMANCY)
    { nDC += 1; }

//Penalizador UrdimbreSombria (Si el lanzador tiene Urdimbre sombria y el conjuro es de Evocacion o Transmutacion la CD baja en 1.
if( GetHasFeat(1354, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_EVOCATION || GetHasFeat(1354, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_TRANSMUTATION)
    { nDC -= 1; }

// // Bonificador de Spellcraft (Conocimiento de Conjuros): +1 CD por cada 5 rangos completos
// nDC += GetSkillRank(SKILL_SPELLCRAFT, oCaster) / 5;

/*/Defensa Sombria
 if(GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_ILLUSION || GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_ENCHANTMENT  ||  GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_NECROMANCY)
    {
     if(GetHasFeat(1360, oTarget)){ nDC -= 3; SendMessageToPC(oCaster, "Algo en el objetivo modifica la CD en " + IntToString(nDC));}
     else if (GetHasFeat(1359, oTarget)){ nDC -= 2; SendMessageToPC(oCaster, "Algo en el objetivo modifica la CD en " + IntToString(nDC));}
     else if (GetHasFeat(1358, oTarget)){ nDC -= 1; SendMessageToPC(oCaster, "Algo en el objetivo modifica la CD en " + IntToString(nDC));}
    }
*/
SetLocalInt(oCaster, "X2_L_LAST_RETVAR", nDC);

}







