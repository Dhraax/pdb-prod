// Remover efectos del Frenesi //

#include "nw_i0_spells"

void main()
{
    object oPC = OBJECT_SELF;
    object oMod = GetModule();

    // Antisaturamiento, solo una vez cada 6 segundos
  if(GetLocalInt(oMod, "REMFRENZY" + GetName(oPC, TRUE)))
  {
      SendMessageToPC(oPC, "<cþ<<>Debes esperar 6 segundos para volver a usar esta habilidad.</c>");
      return;
  }

  SetLocalInt(oMod, "REMFRENZY" + GetName(oPC, TRUE), TRUE);
  DelayCommand(6.0, DeleteLocalInt(oMod, "REMFRENZY" + GetName(oPC, TRUE)));

    if(GetHasFeatEffect(1443, oPC))// Solo si estamos en frenesi
    {
        int willSave = WillSave(oPC, 20, SAVING_THROW_TYPE_NONE, oPC);
        if(willSave == 1)
        {
           RemoveSpellEffects(1329, oPC, oPC);
           SetImmortal(oPC, FALSE);
           FloatingTextStringOnCreature("** Consigues salir de tu estado de Frenesi. **",OBJECT_SELF ,FALSE);
        }
     }

      else FloatingTextStringOnCreature("** Debes estar en Frenesi para utilizar esta habilidad. **",OBJECT_SELF ,FALSE);
}
