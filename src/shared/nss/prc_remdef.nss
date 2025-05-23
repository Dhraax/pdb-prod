// Remover efectos Posicion Defensiva //

#include "nw_i0_spells"

void main()
{
    object oPC = OBJECT_SELF;
    object oMod = GetModule();

    // Antisaturamiento, solo una vez cada 6 segundos
  if(GetLocalInt(oMod, "REMDEF" + GetName(oPC, TRUE)))
      {
      SendMessageToPC(oPC, "<cþ<<>Debes esperar 6 segundos para volver a usar esta habilidad.</c>");
      return;
      }

    SetLocalInt(oMod, "REMDEF" + GetName(oPC, TRUE), TRUE);
    DelayCommand(6.0, DeleteLocalInt(oMod, "REMDEF" + GetName(oPC, TRUE)));

    // Solo si estamos en Posición Defensiva
    if(GetHasFeatEffect(1458, oPC))
    {
        RemoveSpellEffects(1333, oPC, oPC);
    }

    else FloatingTextStringOnCreature("** Debes estar en Posición Defensiva para utilizar esta habilidad. **",OBJECT_SELF ,FALSE);
}
