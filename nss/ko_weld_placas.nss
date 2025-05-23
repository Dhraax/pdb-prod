#include "nw_i0_tool"

int StartingConditional()
{

object oPC = GetPCSpeaker();
string sIdioma = GetLocalString (OBJECT_SELF, "IDIOMA");
string sTieneIdiomaElfo = "Que la oscuridad que mora en estas cuevas quede encerrada para siempre. Caídos. Hijos de la 'Renegada', maldita en su nombre y a todos a los que la adoran. Que vuestra vileza muera en este lugar de bondad y paz. Que la belleza de Suldanessellar y de Wéldazh quede vetada a vuestros impíos ojos. Que el padre nos tenga en su gloria y a todos aquellos que defendieron este lugar, a todos los que impidieron que el mal se extienda por el bosque. Mi Reina, Ai Armiel Telere Maenen Hir. Aentalhas Elmanesse";
string sNoTieneIdiomaElfo = "Que la... quede encerrada para siempre. Caídos... de la renegada, maldita en su nombre y... en este lugar de bondad y paz. Que la belleza de Suldanessellar... a vuestros impíos ojos. Que el padre nos tenga en su gloria y a todos los que defendieron este lugar, a todos... bosque... Aentalhas Elmanesse";
string sStringLargo1 = "Las miles se convertirán en ocho: las ocho más fuertes, las ocho más astutas, las ocho más tortuosas, las ocho más despiadadas. Una será la Yor'thae, hija de las tinieblas, la otra recibirá el manto del Caos. Más allá del capullo del sanctasanctórum, los hijos del Engañado creerán que conocen a Lloth, se consideran orgullosos, valiosos o superiores. Son unos locos. La conspiración está escrita por la Señora del Caos.";
string sStringLargo2 = "Pues por los caminos de la Reina Araña no se avanza recto, ni hacia ningún destino cierto. Sólo ella conoce su destino final, el término de su conspiración. Yor'thae, asesina de arañas, madre de arañas. Octava de ocho. Ella nos liberará de nuestra condena eterna, nosotras, las drañas, seremos al fin liberadas. Manos ejecutoras, traedoras de la condena. Que los hijos del Engañado tiemblen cuando llegue nuestra hora.";
string sTieneIdiomaDrow = sStringLargo1 + sStringLargo2;
string sNoTieneIdiomaDrow = "Las miles se convertirán en ocho... más astutas... Yor'thae, hija de las tinieblas... manto del Caos. Más allá del capullo del sanctasanctórum... Engañado... Lloth, se consideran orgullosos, valiosos o... Son unos locos... Señora del Caos. Pues por los caminos de la Reina Araña sólo ella conoce... final, el término de su conspiración. Yor'thae, asesina... madre... Octava de ocho... nuestra condena... liberadas. Manos ejecutoras... condena... del Engañado tiemblen cuando llegue nuestra hora";
string sFracasoElfo ="Parece élfico";
string sFracasoDrow ="Parece drow";
int iTirada = d20();
int iRango = GetSkillRank (29, oPC);
int iAntiSpanElfo = GetLocalInt(oPC,"PLACAELFO_WELDATH");
int iAntiSpanDrow = GetLocalInt(oPC,"PLACADROW_WELDATH");

if (sIdioma == "hlslang_1")//Si es la placa escrita en elfico
    {
    if(HasItem(oPC, sIdioma))
         {
         SetCustomToken (7002, sTieneIdiomaElfo);
         }

    else
         {
         if (((iTirada + iRango)>=30)&&(iAntiSpanElfo ==0)||(iAntiSpanElfo == 1))
            {
            SetCustomToken (7002, sTieneIdiomaElfo);
            SetLocalInt(oPC,"PLACAELFO_WELDATH",1);
            DelayCommand(600.0, DeleteLocalInt(oPC, "PLACAELFO_WELDATH"));
            }
         if (((iTirada + iRango)>=20)&&(iAntiSpanElfo ==0)||(iAntiSpanElfo == 2))
            {
            SetCustomToken (7002, sNoTieneIdiomaElfo);
            SetLocalInt(oPC,"PLACAELFO_WELDATH",2);
            DelayCommand(600.0, DeleteLocalInt(oPC, "PLACAELFO_WELDATH"));
            }
         else{
             SetCustomToken (7002, sFracasoElfo);
             SetLocalInt(oPC,"PLACAELFO_WELDATH",3);
             DelayCommand(600.0, DeleteLocalInt(oPC, "PLACAELFO_WELDATH"));
             }
         }
    }

else{//si es la placa escrita en drow
    if(HasItem(oPC, sIdioma))
         {
         SetCustomToken (7002, sTieneIdiomaDrow);
         }

    else
         {
         if (((iTirada + iRango)>=30)&&(iAntiSpanDrow ==0)||(iAntiSpanDrow == 1))
            {
            SetCustomToken (7002, sTieneIdiomaDrow);
            SetLocalInt(oPC,"PLACADROW_WELDATH",1);
            DelayCommand(600.0, DeleteLocalInt(oPC, "PLACADROW_WELDATH"));
            }
         if (((iTirada + iRango)>=25)&&(iAntiSpanDrow ==0)||(iAntiSpanDrow == 2))
            {
            SetCustomToken (7002, sNoTieneIdiomaDrow);
            SetLocalInt(oPC,"PLACADROW_WELDATH",2);
            DelayCommand(600.0, DeleteLocalInt(oPC, "PLACADROW_WELDATH"));
            }
         else{
             SetCustomToken (7002, sFracasoDrow);
             SetLocalInt(oPC,"PLACADROW_WELDATH",3);
             DelayCommand(600.0, DeleteLocalInt(oPC, "PLACADROW_WELDATH"));
             }
         }
    }
return TRUE;
}
