void main()
{
// Configura aqui el dinero necesario para hacer la compra
int iDinero = 150;

// Configura aqui la Resref del objeto a crear (no etiqueta)
string sObjeto = "amn_hab_noble";

// Configura aqui la frase que saltara al jugador en caso de que no tenga el dinero
string sFrase =  "¡No tienes 150 monedas de oro!";


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
