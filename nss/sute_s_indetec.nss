#include "x2_inc_switches"
#include "mti_libreria"

const int CLASS_TYPE_CABALLERO_PROTECTOR = 41;
const int CLASS_TYPE_TIRADOR_ESPESURA    = 42;
const int CLASS_TYPE_BRIBON_ARCANO       = 43;
const int CLASS_TYPE_LADRON_SOMBRAS_AMN  = 44;
const int CLASS_TYPE_CABALLERO_ARCANO    = 45;


int CogerTipoClase (object oPJ)
{
    int nMax, i, nClass, nLevel, iClase;
    for (i =1; i<= 3; i++)
    {

            nClass= GetClassByPosition(i,oPJ);
            if (nClass != CLASS_TYPE_INVALID)
            {
                if (nClass ==  CLASS_TYPE_SORCERER || nClass ==  CLASS_TYPE_WIZARD ||
                    nClass ==  CLASS_TYPE_ASSASSIN || nClass == CLASS_TYPE_CLERIC ||
                    nClass == CLASS_TYPE_RANGER)
                {
                    nLevel = GetLevelByClass(nClass,oPJ);

                    if (nLevel> nMax)
                    {
                        nMax = nLevel;
                        iClase = nClass;
                    }
                }
            }
     }
     return iClase;
}
int CogerEspecialNivelLanzador(int iTipoClase, object oPJ)
{
    float fNivelLanzador = IntToFloat(GetLevelByClass(iTipoClase, oPJ));
    int iNivelLanzador;

    switch(iTipoClase)
    {
        // el maestro de la lividez gana niveles de lanzador a razón de
        // uno cada dos niveles
        case CLASS_TYPE_PALEMASTER:
            fNivelLanzador = (fNivelLanzador/2)+0.5;
            break;

        // el caballero arcano gana niveles de lanzador en todos los niveles
        // menos en el primero
        case CLASS_TYPE_CABALLERO_ARCANO:
            fNivelLanzador = fNivelLanzador-1;
            break;

        // por defecto asumimos que una clase de prestigio extraña recibe
        // la mitad de nivel de lanzador que sus niveles de clase
        default:
            fNivelLanzador = (fNivelLanzador/2)+0.5;
    }

    iNivelLanzador = FloatToInt(fNivelLanzador);
    return iNivelLanzador;
}


int CalcularNivelLanzador (object oPJ)
{

    int iNivelLanzador=0;
    int iClaseBase = GetLastSpellCastClass(); //CogerTipoClase(oPJ);
    if (iClaseBase == CLASS_TYPE_INVALID || iClaseBase==0)
    {
        iClaseBase = CogerTipoClase(oPJ);
    }
    switch(iClaseBase)
        {
            case CLASS_TYPE_CLERIC:
                iNivelLanzador = GetLevelByClass(iClaseBase,oPJ);
                break;

            case CLASS_TYPE_RANGER:
                iNivelLanzador = GetLevelByClass(iClaseBase,oPJ);
                break;
            case CLASS_TYPE_SORCERER:
                iNivelLanzador = GetLevelByClass(iClaseBase,oPJ);
                if(GetLevelByClass(CLASS_TYPE_PALEMASTER,oPJ)>0){
                    iNivelLanzador += CogerEspecialNivelLanzador(CLASS_TYPE_PALEMASTER, oPJ);
                }
                if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO,oPJ)>0){
                    iNivelLanzador += CogerEspecialNivelLanzador(CLASS_TYPE_BRIBON_ARCANO,oPJ);
                }
                if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO,oPJ)>0){
                    iNivelLanzador += CogerEspecialNivelLanzador(CLASS_TYPE_CABALLERO_ARCANO,oPJ);
                }
                break;
            case CLASS_TYPE_WIZARD:

                iNivelLanzador = GetLevelByClass(iClaseBase,oPJ);
                if(GetLevelByClass(CLASS_TYPE_PALEMASTER,oPJ)>0){
                    iNivelLanzador += CogerEspecialNivelLanzador(CLASS_TYPE_PALEMASTER, oPJ);
                }
                if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO,oPJ)>0){
                    iNivelLanzador += CogerEspecialNivelLanzador(CLASS_TYPE_BRIBON_ARCANO,oPJ);
                }
                if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO,oPJ)>0){
                    iNivelLanzador += CogerEspecialNivelLanzador(CLASS_TYPE_CABALLERO_ARCANO,oPJ);
                }
                break;
            case CLASS_TYPE_ASSASSIN:
                iNivelLanzador = GetLevelByClass(iClaseBase,oPJ);
                if(GetLevelByClass(CLASS_TYPE_LADRON_SOMBRAS_AMN,oPJ)>0){
                    iNivelLanzador += CogerEspecialNivelLanzador(CLASS_TYPE_LADRON_SOMBRAS_AMN, oPJ);
                }
                break;
           default:
                iNivelLanzador = 0;
                break;
        }

    return iNivelLanzador;

}
void BorrarIndetectabilidad(object oPJ)
{
 GuardarIntPersistente(oPJ,"INDETECTABLE",0);
}

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();    //Which event triggered this
    if(nEvent==X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC= GetItemActivator();
        if (GetIsDM(oPC)==FALSE)
        {
            if ((GetLevelByClass(CLASS_TYPE_CLERIC, oPC)>=4) || (GetLevelByClass(CLASS_TYPE_WIZARD, oPC)>=4) || (GetLevelByClass(CLASS_TYPE_SORCERER, oPC)>=4) || (GetLevelByClass(CLASS_TYPE_RANGER, oPC)>=4) || (GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC)>=4))
            {
                int iDuracion = CalcularNivelLanzador(oPC);
                float fDuracion =  HoursToSeconds(iDuracion);
                GuardarIntPersistente(oPC, "INDETECTABLE", 1);
                DelayCommand(fDuracion, BorrarIndetectabilidad(oPC));
            }
            return;
        }



    }

}
