void main()
{
object oPC = GetLastUsedBy();

//RESREF DEL OBJETO A CREAR
string sResref = "nedroncuerpo";

if(GetCampaignInt("QUESTSARACH", "CUERPO", oPC) == 0 )
    {
    SetCampaignInt("QUESTSARACH", "CUERPO", 1, oPC);
     CreateItemOnObject(sResref, oPC);
    }
else
    {
     FloatingTextStringOnCreature("Ya has recojido el cadaver de Nedron", oPC);
    }
}
