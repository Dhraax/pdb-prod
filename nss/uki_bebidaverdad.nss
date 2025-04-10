#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();    //Which event triggered this
    if(nEvent==X2_ITEM_EVENT_ACTIVATE)
    {
    object oPC= GetItemActivator();

string sDios = GetDeity(oPC);
string sEdad = IntToString(GetAge(oPC));
string sNombre = GetName(oPC,TRUE);
string sSubraza = GetSubRace(oPC);
int iBuenomalo = GetGoodEvilValue(oPC);
int iLegalcaos = GetLawChaosValue(oPC);
int iOro = GetGold(oPC);

    DelayCommand(1.5,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0)));
    DelayCommand(2.0,SetCutsceneMode(oPC,TRUE));
    DelayCommand(2.1, SetPlotFlag(oPC, FALSE));

    DelayCommand(2.5,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,1.0,2.4)));

    DelayCommand(5.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2,1.0)));
    DelayCommand(5.8,AssignCommand(oPC,SpeakString("¡Vaya esto esta de vicio!")));//Nombre

    DelayCommand(10.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2,1.0)));
    DelayCommand(10.0,AssignCommand(oPC,SpeakString("¡Solo tengo ganas de hablar!"))); //Edad

    if(sDios == "")
        {
    DelayCommand(15.0,AssignCommand(oPC,SpeakString("¡Esta pocion esta deliciosa!"))); //Deidad
        }
    else
        {
    DelayCommand(15.0,AssignCommand(oPC,SpeakString("¡Me gustaria tener mas pelo!"))); //Deidad
        }
    DelayCommand(15.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2,1.0)));

    if(sSubraza == "")
        {
    int iRaza = GetRacialType(oPC);
/*=====>*/
            if(iRaza == RACIAL_TYPE_HUMAN)
            {
DelayCommand(20.0,AssignCommand(oPC,SpeakString("¡Soy lo que todos quieren ser!")));//raza
            }
            else if(iRaza == RACIAL_TYPE_HALFELF)
            {
DelayCommand(20.0,AssignCommand(oPC,SpeakString("¡Soy lo que todos quieren ser!")));//raza
            }
        }
    else
        {
    DelayCommand(20.0,AssignCommand(oPC,SpeakString("¡Soy lo que todos quieren ser!")));//subraza
        }
    DelayCommand(20.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2,1.0)));

    if(iLegalcaos <= 30)
        {
        DelayCommand(25.0,AssignCommand(oPC,SpeakString("¡Vayamos a destrozar algo!"))); //caotico
        }
    else if(iLegalcaos >= 70)
        {
        DelayCommand(25.0,AssignCommand(oPC,SpeakString("¡Vayamos a destrozar algo!"))); //caotico
        }
    else
        {
        DelayCommand(25.0,AssignCommand(oPC,SpeakString("¡No me mireis asi!"))); //caotico
        }
    DelayCommand(25.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2,1.0)));

   /////////
    if(iBuenomalo <= 30)
        {
        DelayCommand(30.0,AssignCommand(oPC,SpeakString("¡Dejadme no quiero hablar mas!"))); //caotico
        }
    else if(iBuenomalo >= 70)
        {
        DelayCommand(30.0,AssignCommand(oPC,SpeakString("¡Os quiero a todos!"))); //caotico
        }
    else
        {
        DelayCommand(30.0,AssignCommand(oPC,SpeakString("¡Hago lo que quiero y cuando quiero!"))); //caotico
        }
    DelayCommand(30.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2,1.0)));

    if(iOro >= 1)
        {
        string sOro = IntToString(iOro);
    DelayCommand(35.0,AssignCommand(oPC,SpeakString("¡Tengo un problema!"))); //Cantidad de oro
        }
    else
        {
    DelayCommand(35.0,AssignCommand(oPC,SpeakString("¡No tengo dinero!"))); //Cantidad de oro
        }
    DelayCommand(35.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2,1.0)));

    DelayCommand(37.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,1.0,8.0)));

    DelayCommand(45.0,SetCutsceneMode(oPC,FALSE));
    }
}
