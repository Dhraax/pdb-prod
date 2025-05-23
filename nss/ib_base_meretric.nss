void main()
{

int iDinero = 100;

string sObjeto = "ib_base_llavemer";


string sFrase =  "¡No tienes 100 monedas de oro, largate de aqui maldito perdedor desgraciado jajajajaja!";


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
