#include "f_vampire_spls_h"
#include "nw_i0_plot"
#include "lib_race"

void AbrirPuerta(object oPuerta2, object oPJ)
{
    if (GetIsOpen(oPuerta2)==FALSE)
    {
        ActionDoCommand(ActionOpenDoor(oPuerta2));
        SendMessageToPC (oPJ,"Bajandose puente levadizo.");
    }
    else
    {
        ActionDoCommand(ActionCloseDoor(oPuerta2));
        SendMessageToPC (oPJ,"Subiendo puente levadizo.");
    }


}
void main()
{
    object oPC =  GetLastUsedBy();
    if (GetIsPC(oPC)==TRUE)
    {
        int iApar =  GetAppearanceType(oPC);
        string sSubraza = GetSubRace(oPC);
        object oPuerta = GetObjectByTag("asy_puertalevadizavampira");
        //Solo pueden pulsar la palanca en forma Humanoide.
        if (((iApar>=1) && (iApar<7)) || (iApar==1769))
        {
            //Solo pueden pulsar la palaca los no muertos, vampiros y ghuls.
            if (PB_Race_GetIsUndead(oPC) || GetIsVampire(oPC) || sSubraza=="ghul" || sSubraza=="necropolita" || sSubraza=="deathknight" || sSubraza=="liche")
            {
                AbrirPuerta(oPuerta, oPC);
            }
            else
            {
                int iBolean;
                if(GetItemPossessedBy(oPC, "asy_emblemavamp") == OBJECT_INVALID)
                {
                    iBolean = FALSE;
                }
                else
                {
                    AbrirPuerta(oPuerta, oPC);
                    return;

                }
                //Si posee el emblema vampirico o no.
                if(iBolean==FALSE)
                {
                    SendMessageToPC(oPC, "La palanca permanece inmóvil, por mucho que tires de ella.");
                    //Si el jugador es clerigo, mago o hechiceros podrian sacar mas informacion de porque
                    //la palanca no se mueve,tras una determinada tirada.
                    int iclase1 = GetClassByPosition(1,oPC);
                    int iclase2 = GetClassByPosition(2,oPC);
                    int iclase3 = GetClassByPosition(3,oPC);
                    if ((iclase1==CLASS_TYPE_CLERIC) || (iclase2==CLASS_TYPE_SORCERER) || (iclase3==CLASS_TYPE_WIZARD))
                    {
                        int iTirada = d10();
                        int iSaberbonus = GetAbilityScore(oPC, ABILITY_WISDOM,FALSE);
                        int iSabiduria = GetWisdom(oPC);
                        int iBonus = 0;
                        int iCD = 14; //dificultad
                        if (iSaberbonus >= iSabiduria)
                        {
                            iBonus = iSaberbonus - iSabiduria;
                        }
                        int nRoll =iTirada+iBonus;
                        //Se hace una tirada de un d10 mas el bonus de su sabiduria para averiguar que sucede con el dispositivo
                        //Si supera la tirada (dependiendo del valor de iCD), el clerigo, mago o hechicero obtendra mayor o menos inforamcion.
                        if (nRoll> iCD)
                        {
                            SendMessageToPC(oPC, "Te sientes ligeramente mareado, una extraña y oscura sensación parece invadirte. Que aparentemente puedes controlar pero sientes que esa oscuridad a tocado tu propio corazón.");
                            SendMessageToPC(oPC, "Casi inmediatamente escuchas una poderosa y tenebrosa voz de ultratumba que te dice: Los muertos la construyeron solo los moraban sin vida pueden darle uso.");
                            SendMessageToPC(oPC, "Paulatinamente la sensación va desapareciendo pero seguramente esta experiencia te costará un par de pesadillas en futuras noches.");
                            SendMessageToPC(oPC, "En definitva llegas a la conclusión que tanto esta palanca como todo este lugar está protegido por una poderosísima magia nigromántica.");
                        }
                        else
                        {
                            SendMessageToPC (oPC, "No llegas a averiguar que es lo que sucede con este dispositivo, solo sientes que esta protegido por algun tipo de magia o protección, pero eres incapaz de averigual de que tipo.");
                        }
                    }

                }


            }

        }
        else
        {
            SendMessageToPC(oPC, "Solo puedes abrir la puerta en tu forma humanoide");
        }
    }
}
