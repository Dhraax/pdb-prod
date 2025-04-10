void main()
{
// Configura aqui el dinero necesario para hacer la compra
int iDinero = 19;

// Configura aqui la Resref del objeto a crear (no etiqueta)
string sObjeto = "amn_hab_avent";

// Configura aqui la frase que saltara al jugador en caso de que no tenga el dinero
string sFrase =  "¡No tienes 19 monedas de oro!";


object oPC = GetPCSpeaker();

if (GetGold(oPC) >= iDinero)
     {
        AssignCommand(oPC, TakeGoldFromCreature(iDinero, oPC, TRUE));
        CreateItemOnObject(sObjeto, oPC);
     }

else
     {
        FloatingTextStringOnCreature(sFrase, oPC, FALSE);
     }
}
