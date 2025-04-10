
//Inclusion de librerias..
#include "inc_sqlite_time"
#include "pb_tesoro_gold"
#include "pb_tesoro_scroll"
#include "pb_tesoro_potion"
#include "pb_tesoro_ccweap"
#include "pb_tesoro_diweap"
#include "pb_tesoro_munici"
#include "pb_tesoro_magos"
#include "pb_tesoro_escudo"
#include "pb_tesoro_miscel"
#include "pb_tesoro_armor"
#include "mti_libreria"


void CreamosRecompensaEspecial(object oParty, int nDG)
{
    //Creamos recompensa Especial según la clase y nivel de quest
    if(GetLevelByClass(CLASS_TYPE_BARBARIAN, oParty) > 0 ||
        GetLevelByClass(CLASS_TYPE_FIGHTER, oParty) > 0 ||
        GetLevelByClass(CLASS_TYPE_CLERIC, oParty) > 0 ||
        GetLevelByClass(CLASS_TYPE_PALADIN, oParty) > 0 )
        {
            switch(d3())
            {
                case 1: DelayCommand(2.0,crearArmaCC(oParty, nDG)); break;
                case 2: DelayCommand(2.0,crearEscudo(oParty, nDG)); break;
                case 3: DelayCommand(2.0,crearMiscelaneo(oParty, nDG)); break;
            }
        }

    else if(GetLevelByClass(CLASS_TYPE_SORCERER, oParty) > 0 ||
        GetLevelByClass(CLASS_TYPE_WIZARD, oParty) > 0 ||
        GetLevelByClass(57, oParty) > 0 )
        {
            switch(d3())
            {
                case 1: DelayCommand(2.0,crearBastonMago(oParty, nDG)); break;
                case 2: DelayCommand(2.0,crearCetrosVaras(oParty, nDG)); break;
                case 3: DelayCommand(2.0,crearMiscelaneo(oParty, nDG)); break;
            }
        }
    else if(GetLevelByClass(CLASS_TYPE_RANGER, oParty) > 0 || GetLevelByClass(42, oParty) > 0 )
        {
            switch(d3())
            {
                case 1: DelayCommand(2.0,crearArmaDI(oParty, nDG)); break;
                case 2: DelayCommand(2.0,crearMunicion(oParty, nDG)); break;
                case 3: DelayCommand(2.0,crearMiscelaneo(oParty, nDG)); break;
            }
        }
    else if(GetLevelByClass(CLASS_TYPE_MONK, oParty) > 0 )
        {
        switch(d3())
            {
                case 1: DelayCommand(2.0,crearMiscelaneo(oParty, nDG)); break;
                case 2: DelayCommand(2.0,crearGuantesMonje(oParty, nDG)); break;
                case 3: DelayCommand(2.0,crearArmadura(oParty, nDG)); break;
            }
        }
    else
            {
   switch(d4())
   {
                case 1: DelayCommand(2.0,crearArmaCC(oParty, nDG)); break;
                case 2: DelayCommand(2.0,crearArmaDI(oParty, nDG)); break ;
                case 3: DelayCommand(2.0,crearArmadura(oParty, nDG)); break;
                case 4: DelayCommand(2.0,crearMiscelaneo(oParty, nDG)); break;
   }
            }

}


void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC, "quest_selune", 2);
object oItem = GetItemPossessedBy(oPC, "paquete_selune");
CreamosRecompensaEspecial(oPC, 16);
DestroyObject(oItem, 0.5);
GiveXPToCreature(oPC, 1000);
GiveGoldToCreature(oPC, 5000);
}
