void main()
{

int iDinero = 500;


string sObjeto = "ib_base_llaveesp";


string sFrase =  "¡No tienes 500 monedas de oro, mejor prueba con las chicas o las bebidas!";


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
