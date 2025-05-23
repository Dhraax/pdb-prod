/** Script de modificacion Penetracion Conjuros:
Añadir en este Script cualquier modificacion referente a la Penetracion de conjuros para superar la RC, devolviendo el valor a traves de nSP **/

void main()
{

object oCaster = OBJECT_SELF;
int nSP = 0;

//Magia Perniciosa +4 a las pruebas de nivel para superar la RC de un Usuario de la Urdimbre. No se aplica en conjuros que lances de las escuelas de evocación y transmutación.
if (GetHasFeat(1356, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_ILLUSION || GetHasFeat(1356, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_ENCHANTMENT
|| GetHasFeat(1356, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_NECROMANCY)
        {
        nSP += 4;
        }

//Bonificador UrdimbreSombria Si el lanzador tiene Urdimbre sombria y el conjuro es de Ilusion, Encantamiento o Nigromancia la penetracion aumenta en 1.
else if( GetHasFeat(1354, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_ILLUSION || GetHasFeat(1354, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_ENCHANTMENT
|| GetHasFeat(1354, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_NECROMANCY)
       {
        nSP += 1;
       }

//Penalizador UrdimbreSombria Si el lanzador tiene Urdimbre sombria y el conjuro es de Evocacion o Transmutacion la penetracion baja en 1.
if( GetHasFeat(1354, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_EVOCATION || GetHasFeat(1354, oCaster) && GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") == SPELL_SCHOOL_TRANSMUTATION)
       {
        nSP -= 1;
       }


SetLocalInt(oCaster, "X2_L_LAST_RETVAR", nSP);


}
