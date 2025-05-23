/* EJERCITOS TRASGOS: ARQUEROS DEBILES 50 PO */
void main()
{
// Configura aqui el dinero necesario para contratar el ejercito
int iDinero = 250;

object oPC = GetPCSpeaker();
object oMod = GetModule();

// Si ya tenias como minimo un ayudante el script no sigue
if(GetHenchman(oPC) != OBJECT_INVALID)
    {
     FloatingTextStringOnCreature("¡Ya tienes ayudantes!", oPC, FALSE);
     return;
    }

// Si no tiene suficiente oro el script no sigue
if(GetGold(oPC) < iDinero)
    {
     FloatingTextStringOnCreature("¡No tienes suficiente dinero para contratar los servicios de este ejército!", oPC, FALSE);
     return;
    }

// Variables para que no se pueda contratar ejercitos en al menos 600 seg. de nuevo
SetLocalInt(oMod, "NOEJERCITOS", 1);
DelayCommand(600.0, DeleteLocalInt(oMod, "NOEJERCITOS"));

//Quitamos el oro
AssignCommand(oPC, TakeGoldFromCreature(iDinero, oPC, TRUE));

//Creamos las criaturas y las unimos al jugador
object oTrasgo1 = CreateObject(OBJECT_TYPE_CREATURE, "hen_grant_cham2", GetLocation(oPC));
DelayCommand(2.5, AddHenchman(oPC, oTrasgo1));

object oTrasgo2 = CreateObject(OBJECT_TYPE_CREATURE, "hen_gue_grant2", GetLocation(oPC));
DelayCommand(2.5, AddHenchman(oPC, oTrasgo2));

object oTrasgo3 = CreateObject(OBJECT_TYPE_CREATURE, "hen_gue_grant2", GetLocation(oPC));
DelayCommand(2.5, AddHenchman(oPC, oTrasgo3));
}
