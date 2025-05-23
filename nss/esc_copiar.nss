#include "esc_inc"

void main()
{
  object oPC = GetPCSpeaker();
  object oEscritoGuardado = GetLocalObject(oPC, "ESC_PAPEL");

  if(GetGold(oPC) < 50)
  {
      SendMessageToPC(oPC, "<cþ<<>¡No tienes 50 monedas de oro para poder copiar el escrito!</c>");
      return;
  }

  if(UsosTinta(oPC) == FALSE) return;

  FloatingTextStringOnCreature("<c´þd>* Copias con éxito el escrito *</c>", oPC, FALSE);
  TakeGoldFromCreature(50, oPC, TRUE);
  object oCopia = CopyItem(oEscritoGuardado, oPC, TRUE);
  SetItemCursedFlag(oEscritoGuardado, FALSE);
  SetItemCursedFlag(oCopia, FALSE);
  SetDescription(oCopia, GetDescription(oEscritoGuardado));
}
