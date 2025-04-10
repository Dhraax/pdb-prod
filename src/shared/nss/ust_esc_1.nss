/* CONTRATAR ESCLAVOS, GUERRILLERO TRASGO */
void main()
{
// Configura aqui el dinero necesario para contratar el esclavo
int iDinero = 100;

// Configura aqui la Resref de la criatura a crear (no etiqueta)
string sEsclavo = "hen_guer_trasgo";

object oPC = GetPCSpeaker();
object oMod = GetModule();

// Si ya tenia un esclavo el script no sigue
if(GetHenchman(oPC) != OBJECT_INVALID)
    {
     FloatingTextStringOnCreature("¡Solo puedes contratar a 1 esclavo!", oPC, FALSE);
     return;
    }

// Si no tiene suficiente oro el script no sigue
if(GetGold(oPC) < iDinero)
    {
     FloatingTextStringOnCreature("¡No tienes suficiente dinero para contratar los servicios de este esclavo!", oPC, FALSE);
     return;
    }

// Variables para que no se pueda contratar a esclavos en al menos 200 seg. de nuevo
SetLocalInt(oMod, "NOESCLAVOS", 1);
DelayCommand(200.0, DeleteLocalInt(oMod, "NOESCLAVOS"));

//Quitamos el oro
AssignCommand(oPC, TakeGoldFromCreature(iDinero, oPC, TRUE));

// Creamos el esclavo y lo unimos al jugador
object oEsclavo = CreateObject(OBJECT_TYPE_CREATURE, sEsclavo, GetLocation(oPC));
ChangeToStandardFaction(oEsclavo, STANDARD_FACTION_COMMONER);
DelayCommand(2.5, AddHenchman(oPC, oEsclavo));
}
