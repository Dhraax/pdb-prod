/* EJERCITOS TRASGOS: ARQUEROS DEBILES 50 PO */
void main()
{
// Configura aqui el dinero necesario para contratar el ejercito
int iDinero = 175;

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

//Creamos las criaturas aleatoriamente y las unimos al jugador
int iProb1 = d2();
int iProb2 = d2();
int iProb3 = d2();
string sCriatura1;
string sCriatura2;
string sCriatura3;

if(iProb1 == 1) sCriatura1 = "hen_arq_trasg2";
else sCriatura1 = "hen_arq_trasg3";

if(iProb2 == 1) sCriatura2 = "hen_arq_trasg2";
else sCriatura2 = "hen_arq_trasg3";

if(iProb3 == 1) sCriatura3 = "hen_arq_trasg2";
else sCriatura3 = "hen_arq_trasg3";

object oTrasgo1 = CreateObject(OBJECT_TYPE_CREATURE, sCriatura1, GetLocation(oPC));
DelayCommand(2.5, AddHenchman(oPC, oTrasgo1));

object oTrasgo2 = CreateObject(OBJECT_TYPE_CREATURE, sCriatura2, GetLocation(oPC));
DelayCommand(2.5, AddHenchman(oPC, oTrasgo2));

object oTrasgo3 = CreateObject(OBJECT_TYPE_CREATURE, sCriatura3, GetLocation(oPC));
DelayCommand(2.5, AddHenchman(oPC, oTrasgo3));
}
