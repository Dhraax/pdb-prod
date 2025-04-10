#include "nwnx_creature"
#include "mti_libreria"

void main()
{
    object oPC = GetPCSpeaker();
    string sLinaje = GetScriptParam("Linaje");

    if(sLinaje == "1")  //Es linaje eléctrico.
    {
        GuardarIntPersistente(oPC,"DRACONIDO_TIPO",1); //Tipo eléctrico.
        NWNX_Creature_AddFeat(oPC, 563); //Resistencia 10 a la electricidad (mediante la dote Resistencia a la Energía Épica).
    }
    if(sLinaje == "2")  //Es linaje frío.
    {
        GuardarIntPersistente(oPC,"DRACONIDO_TIPO",2); //Tipo frío.
        NWNX_Creature_AddFeat(oPC, 533); //Resistencia 10 al frío (mediante la dote Resistencia a la Energía Épica).
    }
    if(sLinaje == "3")  //Es linaje ácido.
    {
        GuardarIntPersistente(oPC,"DRACONIDO_TIPO",3); //Tipo ácido.
        NWNX_Creature_AddFeat(oPC, 543); //Resistencia 10 al ácido (mediante la dote Resistencia a la Energía Épica).
    }
    if(sLinaje == "4")  //Es linaje fuego.
    {
        GuardarIntPersistente(oPC,"DRACONIDO_TIPO",4); //Tipo fuego.
        NWNX_Creature_AddFeat(oPC, 553); //Resistencia 10 al fuego (mediante la dote Resistencia a la Energía Épica).
    }
    NWNX_Creature_AddFeat(oPC, 965); //Aliento.
    GuardarIntPersistente(oPC, "DRACONIDO_LINAJE",TRUE); //Revisad ésto, que no tengo la librería para las persistentes.
    SetCutsceneMode(oPC,FALSE);
}
