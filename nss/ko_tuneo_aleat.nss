//Cambio de apariencia aleatorio (enlazado con ko_encuentro sobre todo para la generacion de guardias aleatoria.
void main()
{
    int iVariableFenotipo = GetLocalInt (OBJECT_SELF, "NOCAMBIOFENOTIPO");//Colocar esta variable en el pnj si no quieres que cambie su fenotipo
    int iVariableCabeza = GetLocalInt (OBJECT_SELF, "NOCAMBIOCABEZA");//Colocar esta variable en el pnj si no quieres que cambie su cabeza
    int iFenotipo = GetPhenoType (OBJECT_SELF);
    int iProbabilidad = d6();//uno de cada 6 cambia fenotipo
    int iVariableFaccion = GetLocalInt (OBJECT_SELF, "CAMBIOFACCION");//Si tiene esta variable una criatura hostil, cambia a defensor, modificado para la Torre del Eclipse

    SetColor (OBJECT_SELF, COLOR_CHANNEL_HAIR,d10());          //Color de pelo
    SetColor (OBJECT_SELF, COLOR_CHANNEL_SKIN, d4());         //Color de piel

    if ((iVariableFenotipo == 0)&&(iProbabilidad ==1))                 //Fenotipo
    {
        if (iFenotipo == PHENOTYPE_BIG){
           SetPhenoType (PHENOTYPE_NORMAL,OBJECT_SELF);}
        else{
           SetPhenoType (PHENOTYPE_BIG,OBJECT_SELF);}
    }
    if (iVariableCabeza != 1)                                       //Cabeza
        {SetCreatureBodyPart(CREATURE_PART_HEAD,d20(),OBJECT_SELF);}

    if (iVariableFaccion == 1)                                      //Faccion
       {ChangeToStandardFaction (OBJECT_SELF, STANDARD_FACTION_DEFENDER);}

       }
