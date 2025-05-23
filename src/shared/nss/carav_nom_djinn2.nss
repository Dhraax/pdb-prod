#include "mti_libreria"
#include "x0_i0_partywide"
void main()
{
object oPC = GetPCSpeaker();
object oItemToTake = GetItemPossessedBy(oPC, "caravasarcabezarakasha");
int iGrupo, iSecuaces;

iGrupo=FALSE;
iSecuaces=FALSE;

//comprobar que no este en grupo
int iPCContador = GetNumberPartyMembers(oPC) - 1;
if  (iPCContador > 0) iGrupo = TRUE;

//comprobar que no tenga ningún familiar, criatura convocada o npc contratado
int i, nCount;
int iAliados= GetMaxHenchmen();
if (iAliados>0)
{
    for (i=1; i<=iAliados; i++)
       {
            if (GetIsObjectValid(GetHenchman(oPC, i)))
            nCount++;
       }
}
if (nCount>0) iSecuaces=TRUE;

//Solo cobra la quest si esta completemante solo.
if ((iGrupo==FALSE) && (iSecuaces==FALSE))
  {
    GiveXPToCreature(oPC, 500);
    CreateItemOnObject("uri_garraderasha", oPC, 1);

    GuardarIntPersistente(oPC, "QUEST_CARAVASAR_DJINN", 3);

    if (GetIsObjectValid(oItemToTake)) DestroyObject(oItemToTake);
  }
else
  {
      SendMessageToPC (oPC, "Salga del grupo o desconvoque caulquier familiar, criatura o pnj para poder cobrar la misión.");
  }
}
