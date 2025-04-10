


//SCRIPT para tiradas de habilidad en ubicados
//En la paleta habra 2 ubicados, entrada y salida. (Como los portales) y una puerta se tendran que renombrar con el mismo nombre.
//Se coloca el ubicado de entrada (SIEMPRE) luego dependiendo de lo que se quiera hacer se colocara el ubicado "salida" o la puerta.
//Despues se configuran las variables segun se quiera (Solo en el de entrada)

//Variable int UBICADO_HABILIDAD colocar el numero de habilidad que se desea utilizar.
//0     Trato con Animales
//1     Concentracion
//2     InutilizarMecanismo
//3     SaberLocal
//4     Sanar
//5     Esconderse
//6     Escuchar
//7     SaberArcano
//8     MoverseSigilosamente
//9     AbrirCerraduras
//10    SaberReligion
//11    Interpretar
//12    Diplomacia
//13    JuegoDeManos
//14    Buscar
//15    PonerTrampas
//16    ConocimientoConjuros
//17    Avistar
//18    SaberOtros
//19    UsarObjetoMagico
//20    Tasacion
//21    Piruetas
//22    Artesania
//23    Engañar
//24    Intimidar
//25    Nadar
//26    Saltar
//27    Montar
//28    AveriguarIntenciones
//29    DescifrarEscritura
//30    Disfrazarse
//31    Equilibrio
//32    Escapismo
//33    Falsificar
//34    HablarUnIdioma
//35    ReunirInformacion
//36    Supervivencia
//37    Trepar
//38    UsoDeCuerdas

//
//Variable int UBICADO_CD colocar la CD a superar.
//

//Variable int UBICADO_DANYO para indicar el tipo de daño si fallas
//1: Acido
//2: Fuego
//3: Frio
//4: Electrico
//5: Negativo
//6: Positivo
//7: Magico
//8: Sonico
//9: Cortante
//10: Perforante
//11: Contundente

//Variable int UBICADO_DANYO_DADOS para indicar cuandos d6 de daño se aplica si fallas

//Varibale int UBICADO_EXITO selecioanr un numero de lista que sera lo que ocurra si tienen exito.
//Consecuencias en caso de éxito:
//Algunas pruebas solo utilizan el ubicado "Entrada". (Bendicion, Curar a todo el grupo.)
//1.- Saltar individual (Efecto de salto hasta el ubicado destino, depende de si es trepar, nadar, equilibrio hara una animacion diferente).
//2.- Abrirse una puerta (El ubicado destino debe ser la puerta Puertas->Especial>Custom1 con el mismo nombre que el ubicado inicial)
//3.- Curar a todo el grupo (Cura tantos d6 como se haya definido en la variable UBICADO_DANYO_DADOS)
//4.- Bendición a todo el grupo (Lanza Bendicion nivel 20 a todo el grupo)
//5.- Romper ubicado(El ubicado destino se destruye, un solo uso por reinicio)
//6.- Teleportar (Efecto magico teleporta al ubicado destino a un solo jugador)
//7.- Teleportar a todo el grupo (Efecto magico teleporta a todo el grupo al ubicado destino)
//83

//Varibale int UBICADO_FALLO selecioanr un numero de lista que sera lo que ocurra si tienen pifia.
//Consecuencias en caso de fracaso:
//1.- Daño a ti solo (Daña tantos d6 como se haya definido en la variable UBICADO_DANYO_DADOS y del tipo definido en UBICADO_DANYO) **Consultar listado de daños.
//2.- Daño a todo el grupo (Daña a todas las criaturas a 30 pìes tantos d6 como se haya definido en la variable UBICADO_DANYO_DADOS y del tipo definido en UBICADO_DANYO) **Consultar listado de daños.
//3.- Derribarte (Caes derribado y te inflinje daño. d6 como haya definidos en la variable UBICADO_DANYO_DADOS)
//4.- Confundir  (Confunde y te inflinje daño. d6 como haya definidos en la variable UBICADO_DANYO_DADOS)
//5.- Petrificado (Queda petrificado permanente)
//6.- Maldición  (Se le lanza maldicion -6 a todo sobre el jugador)
//7.- Muerte  (Efecto de muerte sobre el jugador)
//8.- Teleport Fail a uno solo. (El jugador es enviado a un waypoint definido en string UBICADO_WAYPOINT)
//9.- Teleport Fail a todo el grupo. (Todas las criaturas a 30 pies son enviados al waypoint definido en string UBICADO_WAYPOINT)
//
// En los casos de fallo 8 y 9 es necesario colocar la Variable string UBICADO_WAYPOINT y crear el waypoint con ese nombre donde se quiera que sean transportados.

#include "colors_inc"

//DESCRIPCIONES
void Descripcionexito(object oPC)
{
   string sDes = GetLocalString(OBJECT_SELF, "DESCRIPCION_EXITO");
   string sMsg = ColorTokenWhite() + sDes + ColorTokenEnd();
   DelayCommand(0.5, SendMessageToPC(oPC, sMsg));
}

void Descripcionfallo(object oPC)
{
   string sDes = GetLocalString(OBJECT_SELF, "DESCRIPCION_EXITO");
   string sMsg = ColorTokenRed() + sDes + ColorTokenEnd();
   DelayCommand(0.5, SendMessageToPC(oPC, sMsg));
}

//CONSECUENCIAS EXITOS

//Saltar al otro lado, nadar, trepar, equilibio
void SaltoIndividual(object oPC, object oDestino)
{
    int iHabilidad = GetLocalInt(OBJECT_SELF, "UBICADO_HABILIDAD");
    int iAnimacion;

    switch(iHabilidad)
    {
        case 25: iAnimacion = ANIMATION_LOOPING_CUSTOM10; break;  //Nadar
        case 26: iAnimacion = ANIMATION_LOOPING_CUSTOM8; break;  //Saltar
        case 31: iAnimacion = ANIMATION_LOOPING_PAUSE_DRUNK; break; //Equilibrio
        case 37: iAnimacion = ANIMATION_LOOPING_CUSTOM14; break;  //Trepar
        default: iAnimacion = ANIMATION_LOOPING_CUSTOM8; break;
    }
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionPlayAnimation(iAnimacion, 1.0, 1.5));
    DelayCommand(4.0, AssignCommand(oPC, JumpToObject(oDestino)));
}

//Abrir la puerta destino con mensaje de que algo se ha abierto
void AbrirPuerta(object oPC, object oDestino)
{
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), oDestino));
    DelayCommand(2.0, ActionUnlockObject(oDestino));
    DelayCommand(2.5, ActionOpenDoor(oDestino));
    DelayCommand(2.5, SendMessageToPC(oPC, "Escuchas el ruido de una puerta abrirse..."));
}

//Cura a todos los miembros del grupo a 30 pies
void CurarTodos(object oPC, object oDestino)
{
    object oParty = GetFirstFactionMember(oPC, TRUE);
    string sArea = GetTag(GetArea(oPC));
    int iHeal = GetLocalInt(OBJECT_SELF, "UBICADO_DANYO_DADOS");
    int nHeal = d6(iHeal);

    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 1.5));

    while(GetIsObjectValid(oParty))
    {
      if(sArea == GetTag(GetArea(oParty)) && GetDistanceBetween(oPC, oParty) <= 30.0 && GetDistanceBetween(oPC, oParty) >= 0.1 || oPC == oParty)
        {
        AssignCommand(oPC, ClearAllActions());
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MASS_HEAL), OBJECT_SELF));
        DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oParty));
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal),oParty));
        }
     oParty = GetNextFactionMember(oPC, TRUE);
    }// End of while
}

//Bendice a todos los miembros del grupo a 30 pies
void BendecirTodos(object oPC, object oDestino)
{
    object oParty = GetFirstFactionMember(oPC, TRUE);
    string sArea = GetTag(GetArea(oPC));

    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 1.5));

    while(GetIsObjectValid(oParty))
    {
      if(sArea == GetTag(GetArea(oParty)) && GetDistanceBetween(oPC, oParty) <= 30.0 && GetDistanceBetween(oPC, oParty) >= 0.1 || oPC == oParty)
        {
        AssignCommand(oPC, ClearAllActions());
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), OBJECT_SELF));
        DelayCommand(2.5, ActionCastSpellAtObject(SPELL_BLESS ,oParty,METAMAGIC_ANY,TRUE,20,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
        }
     oParty = GetNextFactionMember(oPC, TRUE);
    }// End of while
}

//Rompe el ubicado destino
void RomperUbicado(object oPC, object oDestino)
{
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.5));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUND_BURST), oDestino));
    DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), GetLocation(oDestino), 2.0));
    DelayCommand(2.0, DestroyObject(oDestino));
    return;
}

//Teleporta a un jugador al ubicado destino
void Teleportar(object oPC, object oDestino)
{
    AssignCommand(oPC, ClearAllActions());
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_DISPEL_GREATER), OBJECT_SELF, 1.5));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL_GREATER), OBJECT_SELF));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 1.5));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), oPC));
    DelayCommand(2.0, AssignCommand(oPC, JumpToObject(oDestino)));
}

//Teleporta a todos los del grupo a 30 pies al ubicado destino
void TeleportarGrupo(object oPC, object oDestino)
{
    object oParty = GetFirstFactionMember(oPC, TRUE);
    string sArea = GetTag(GetArea(oPC));
    while(GetIsObjectValid(oParty))
    {
      if(sArea == GetTag(GetArea(oParty)) && GetDistanceBetween(oPC, oParty) <= 30.0 && GetDistanceBetween(oPC, oParty) >= 0.1 || oPC == oParty)
        {
        AssignCommand(oPC, ClearAllActions());
        DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_DISPEL_GREATER), OBJECT_SELF, 1.5));
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL_GREATER), OBJECT_SELF));
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 1.5));
        DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), oParty));
        DelayCommand(2.0, AssignCommand(oParty, JumpToObject(oDestino)));
        }
     oParty = GetNextFactionMember(oPC, TRUE);
    }// End of while
}


//Genera una reja secreta
void CrearReja(object oPC, object oDestino)
{
      string sWaypoint = GetLocalString(OBJECT_SELF, "UBICADO_WAYPOINT");
      string sDestino = GetLocalString(OBJECT_SELF, "UBICADO_DESTINO_TRAMPILLA");
      object oWaypoint = GetObjectByTag(sWaypoint);
      location lWaypoint = GetLocation(oWaypoint);
      object oPuertaSecreta = CreateObject(OBJECT_TYPE_PLACEABLE, "zep_drain002", lWaypoint, FALSE);
      string sName = GetName(OBJECT_SELF);

      SetName(oPuertaSecreta, sName);
      SetLocalString(oPuertaSecreta, "UBICADO_DESTINO", sDestino);
      DestroyObject(oPuertaSecreta, 120.0);

      AssignCommand(oPC, ClearAllActions());
      DelayCommand(1.5, SendMessageToPC(oPC, "* ¡Descubres una puerta secreta! *"));
}

//CONSECUENCIAS FALLOS

//Danño a uno solo
void DanyoIndividual(object oPC, int iDamage, int nDamage)
{
    int iDanyo;

    switch(iDamage)
        {
        case 1: iDanyo = VFX_IMP_ACID_L; break;
        case 2: iDanyo =VFX_IMP_FLAME_M; break;
        case 3: iDanyo = VFX_IMP_FROST_L; break;
        case 4: iDanyo = VFX_IMP_LIGHTNING_M; break;
        case 5: iDanyo = VFX_IMP_NEGATIVE_ENERGY; break;
        case 6: iDanyo = VFX_IMP_SONIC; break;
        case 7: iDanyo = VFX_IMP_MAGBLUE; break;
        case 8: iDanyo = VFX_IMP_SONIC; break;
        case 9: iDanyo = VFX_IMP_KNOCK; break;
        case 10: iDanyo = VFX_IMP_KNOCK; break;
        case 11: iDanyo = VFX_IMP_KNOCK; break;
        default: iDanyo = VFX_IMP_CHARM; break;
        }
    DelayCommand(1.5, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 1.5)));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iDanyo), oPC));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUND_BURST), OBJECT_SELF));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamage(d6(nDamage), iDamage) ,oPC, 3.0f));
}

//Daño en area
void DanyoGrupo(object oPC, int iDamage, int nDamage)
{

 object oTarget;
 int iDanyo;
 location lUbicado = GetLocation(OBJECT_SELF);

    switch(iDamage)
        {
        case 1: iDanyo = VFX_IMP_ACID_L; break;
        case 2: iDanyo =VFX_IMP_FLAME_M; break;
        case 3: iDanyo = VFX_IMP_FROST_L; break;
        case 4: iDanyo = VFX_IMP_LIGHTNING_M; break;
        case 5: iDanyo = VFX_IMP_NEGATIVE_ENERGY; break;
        case 6: iDanyo = VFX_IMP_SONIC; break;
        case 7: iDanyo = VFX_IMP_MAGBLUE; break;
        case 8: iDanyo = VFX_IMP_SONIC; break;
        case 9: iDanyo = VFX_IMP_KNOCK; break;
        case 10: iDanyo = VFX_IMP_KNOCK; break;
        case 11: iDanyo = VFX_IMP_KNOCK; break;
        default: iDanyo = VFX_IMP_CHARM; break;
        }
  oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 30.0, lUbicado , TRUE, OBJECT_TYPE_CREATURE);
  while(GetIsObjectValid(oTarget))
    {
        DelayCommand(1.5, AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 1.5)));
        DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iDanyo), oTarget));
        DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUND_BURST), OBJECT_SELF));
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamage(d6(nDamage), iDamage) ,oTarget, 3.0f));
   oTarget = GetNextObjectInShape(SHAPE_SPHERE, 30.0, lUbicado , TRUE, OBJECT_TYPE_CREATURE);
    } //End while

}

//Derrriba y hace daño a uno
void Derribar(object oPC, int iDamage, int nDamage)
{
    int iDanyo;
    switch(iDamage)
        {
        case 1: iDanyo = VFX_IMP_ACID_L; break;
        case 2: iDanyo =VFX_IMP_FLAME_M; break;
        case 3: iDanyo = VFX_IMP_FROST_L; break;
        case 4: iDanyo = VFX_IMP_LIGHTNING_M; break;
        case 5: iDanyo = VFX_IMP_NEGATIVE_ENERGY; break;
        case 6: iDanyo = VFX_IMP_SONIC; break;
        case 7: iDanyo = VFX_IMP_MAGBLUE; break;
        case 8: iDanyo = VFX_IMP_SONIC; break;
        case 9: iDanyo = VFX_IMP_KNOCK; break;
        case 10: iDanyo = VFX_IMP_KNOCK; break;
        case 11: iDanyo = VFX_IMP_KNOCK; break;
        default: iDanyo = VFX_IMP_CHARM; break;
        }

    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iDanyo), oPC));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, RoundsToSeconds(3)));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUND_BURST), OBJECT_SELF));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamage(d6(nDamage), iDamage) ,oPC, 3.0f));
}


//Confunde y hace daño
void Confundir(object oPC,int iDamage, int nDamage)
{
int iDanyo;
    switch(iDamage)
        {
        case 1: iDanyo = VFX_IMP_ACID_L; break;
        case 2: iDanyo =VFX_IMP_FLAME_M; break;
        case 3: iDanyo = VFX_IMP_FROST_L; break;
        case 4: iDanyo = VFX_IMP_LIGHTNING_M; break;
        case 5: iDanyo = VFX_IMP_NEGATIVE_ENERGY; break;
        case 6: iDanyo = VFX_IMP_SONIC; break;
        case 7: iDanyo = VFX_IMP_MAGBLUE; break;
        case 8: iDanyo = VFX_IMP_SONIC; break;
        case 9: iDanyo = VFX_IMP_KNOCK; break;
        case 10: iDanyo = VFX_IMP_KNOCK; break;
        case 11: iDanyo = VFX_IMP_KNOCK; break;
        default: iDanyo = VFX_IMP_CHARM; break;
        }

    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iDanyo), oPC));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectConfused(), oPC, RoundsToSeconds(5)));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SOUND_BURST), OBJECT_SELF));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(nDamage), iDamage) ,oPC));
}

//Queda petrificado
void Petrificar(object oPC,int iDamage, int nDamage)
{
    int iDanyo;
    switch(iDamage)
        {
        case 1: iDanyo = VFX_IMP_ACID_L; break;
        case 2: iDanyo =VFX_IMP_FLAME_M; break;
        case 3: iDanyo = VFX_IMP_FROST_L; break;
        case 4: iDanyo = VFX_IMP_LIGHTNING_M; break;
        case 5: iDanyo = VFX_IMP_NEGATIVE_ENERGY; break;
        case 6: iDanyo = VFX_IMP_SONIC; break;
        case 7: iDanyo = VFX_IMP_MAGBLUE; break;
        case 8: iDanyo = VFX_IMP_SONIC; break;
        case 9: iDanyo = VFX_IMP_KNOCK; break;
        case 10: iDanyo = VFX_IMP_KNOCK; break;
        case 11: iDanyo = VFX_IMP_KNOCK; break;
        default: iDanyo = VFX_IMP_CHARM; break;
        }

    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iDanyo), oPC));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPetrify(), oPC));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWKILL), OBJECT_SELF));
}

//Maldice con -6 a todo
void Maldecir(object oPC,int iDamage, int nDamage)
{
    effect eMaldito = EffectCurse(6, 6, 6, 6, 6, 6);

    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GREATER_RUIN), oPC));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMaldito, oPC));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_IMPLOSION), OBJECT_SELF));
}

//Muere...
void Muerte(object oPC,int iDamage, int nDamage)
{
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_L), oPC));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDeath(TRUE), oPC));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_WEIRD), OBJECT_SELF));
}

//Hace que un jugador se teleporte a un waypoint definido
void FailTeleport(object oPC,int iDamage, int nDamage)
{
    string sWaypoint = GetLocalString(OBJECT_SELF, "UBICADO_WAYPOINT");
    object oWaypoint = GetObjectByTag(sWaypoint);
    location lWaypoint = GetLocation(oWaypoint);

    AssignCommand(oPC, ClearAllActions());
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_DISPEL_GREATER), OBJECT_SELF, 1.5));
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL_GREATER), OBJECT_SELF));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 1.5));
    DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), oPC));
    DelayCommand(2.0, AssignCommand(oPC, JumpToLocation(lWaypoint)));
}

//Hace que todas las criaturas a 30 pies se teleporten a un waypoint definido
void FailTeleportGrupo(object oPC,int iDamage, int nDamage)
{
    object oTarget;
    location lUbicado = GetLocation(OBJECT_SELF);
    string sWaypoint = GetLocalString(OBJECT_SELF, "UBICADO_WAYPOINT");
    object oWaypoint = GetObjectByTag(sWaypoint);
    location lWaypoint = GetLocation(oWaypoint);

    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 1.5));

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 30.0, lUbicado , TRUE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        AssignCommand(oTarget, ClearAllActions());
        DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_FNF_DISPEL_GREATER), OBJECT_SELF, 1.5));
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL_GREATER), OBJECT_SELF));
        DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), oTarget));
        DelayCommand(2.0, AssignCommand(oTarget, JumpToLocation(lWaypoint)));

    oTarget = GetNextObjectInShape(SHAPE_SPHERE, 30.0, lUbicado , TRUE, OBJECT_TYPE_CREATURE);
    } //End while

}

//Buscamos que exito hay definido
void Exito(object oPC, object oDestino, int iExito)
{
switch(iExito)
        {
        case 1: SaltoIndividual(oPC, oDestino); break;
        case 2: AbrirPuerta(oPC, oDestino); break;
        case 3: CurarTodos(oPC, oDestino); break;
        case 4: BendecirTodos(oPC, oDestino); break;
        case 5: RomperUbicado(oPC, oDestino); break;
        case 6: Teleportar(oPC, oDestino); break;
        case 7: TeleportarGrupo(oPC, oDestino); break;
        case 8: CrearReja(oPC, oDestino); break;
        default: SendMessageToPC(oPC, "No ocurre nada de especial");
        }
}


//Buscamos que segundo exito hay definido
void Exito2(object oPC, object oDestino, int iExito2)
{
switch(iExito2)
        {
        case 1: SaltoIndividual(oPC, oDestino); break;
        case 2: AbrirPuerta(oPC, oDestino); break;
        case 3: CurarTodos(oPC, oDestino); break;
        case 4: BendecirTodos(oPC, oDestino); break;
        case 5: RomperUbicado(oPC, oDestino); break;
        case 6: Teleportar(oPC, oDestino); break;
        case 7: TeleportarGrupo(oPC, oDestino); break;
        case 8: CrearReja(oPC, oDestino); break;
        default: SendMessageToPC(oPC, "No ocurre nada de especial");
        }
}


//Buscamos que fallo hay definido
void Fallo(object oPC, int iFallo, int iDamage, int nDamage)
{
switch(iFallo)
        {
        case 1: DanyoIndividual(oPC, iDamage, nDamage); break;
        case 2: DanyoGrupo(oPC, iDamage, nDamage); break;
        case 3: Derribar(oPC, iDamage, nDamage); break;
        case 4: Confundir(oPC, iDamage, nDamage); break;
        case 5: Petrificar(oPC, iDamage, nDamage); break;
        case 6: Maldecir(oPC, iDamage, nDamage); break;
        case 7: Muerte(oPC, iDamage, nDamage); break;
        case 8: FailTeleport(oPC, iDamage, nDamage); break;
        case 9: FailTeleportGrupo(oPC, iDamage, nDamage); break;
        }
}

//Buscamos que segundo fallo hay definido
void Fallo2(object oPC, int iFallo, int iDamage, int nDamage)
{
switch(iFallo)
        {
        case 1: DanyoIndividual(oPC, iDamage, nDamage); break;
        case 2: DanyoGrupo(oPC, iDamage, nDamage); break;
        case 3: Derribar(oPC, iDamage, nDamage); break;
        case 4: Confundir(oPC, iDamage, nDamage); break;
        case 5: Petrificar(oPC, iDamage, nDamage); break;
        case 6: Maldecir(oPC, iDamage, nDamage); break;
        case 7: Muerte(oPC, iDamage, nDamage); break;
        case 8: FailTeleport(oPC, iDamage, nDamage); break;
        case 9: FailTeleportGrupo(oPC, iDamage, nDamage); break;
        }
}


/////////////////////////////////////////////////////////////////////////////////////////


void main()
{

//Definimos todo
object oPC = GetLastUsedBy();
object oUbicado = OBJECT_SELF;

//Si no es ubicado usamos el desencadenante
int iUbicado = GetObjectType(oUbicado);
if(iUbicado == OBJECT_TYPE_TRIGGER) oPC = GetEnteringObject();



int iHabilidad = GetLocalInt(oUbicado, "UBICADO_HABILIDAD");
string sSkill = GetStringByStrRef(StringToInt(Get2DAString("skills", "Name", iHabilidad)));
int iCD = GetLocalInt(oUbicado, "UBICADO_CD");
int nHabilidad = GetSkillRank(iHabilidad, oPC);
int iDamage = GetLocalInt(oUbicado, "UBICADO_DANYO");
int nDamage = GetLocalInt(oUbicado, "UBICADO_DANYO_DADOS");
int iExito = GetLocalInt(oUbicado, "UBICADO_EXITO");
int iExito2 = GetLocalInt(oUbicado, "UBICADO_EXITO2");
int iFallo = GetLocalInt(oUbicado, "UBICADO_FALLO");
int iFallo2 = GetLocalInt(oUbicado, "UBICADO_FALLO2");
int iTirada = d20() + nHabilidad;
string sTirada = IntToString(iTirada);
string sCD = IntToString(iCD);
string sDestino = GetLocalString(oUbicado, "UBICADO_DESTINO");


//Si es una trampilla vamos al destino
if(GetLocalInt(OBJECT_SELF, "UBICADO_SOYTRAMPILLA") == 1)
    {
      string sWaypoint = GetLocalString(OBJECT_SELF, "UBICADO_DESTINO");
      object oWaypoint = GetObjectByTag(sWaypoint);
      location lWaypoint = GetLocation(oWaypoint);
      AssignCommand(oPC, JumpToLocation(lWaypoint));
      return;
    }

//Asignamos el daño segun el valor de la variable.
switch(iDamage)
        {
        case 1: iDamage = DAMAGE_TYPE_ACID; break;
        case 2: iDamage = DAMAGE_TYPE_FIRE; break;
        case 3: iDamage = DAMAGE_TYPE_COLD; break;
        case 4: iDamage = DAMAGE_TYPE_ELECTRICAL; break;
        case 5: iDamage = DAMAGE_TYPE_NEGATIVE; break;
        case 6: iDamage = DAMAGE_TYPE_POSITIVE; break;
        case 7: iDamage = DAMAGE_TYPE_MAGICAL; break;
        case 8: iDamage = DAMAGE_TYPE_SONIC; break;
        case 9: iDamage = DAMAGE_TYPE_SLASHING; break;
        case 10: iDamage = DAMAGE_TYPE_PIERCING; break;
        case 11: iDamage = DAMAGE_TYPE_BLUDGEONING; break;
        default: iDamage = DAMAGE_TYPE_BLUDGEONING; break;
        }


//Hacemos la tirada y vemos si es exito o fallo

      if(iTirada >= iCD)
        {
            int x;
            for(x=0; x < 30; x++)
            {
                object oDestino = GetObjectByTag(sDestino, x);

                //Revisamos si hay ubicado destino
                if(GetName(oUbicado) == GetName(oDestino))
                {
                    //Aplicamos el exitooo XD
                    DelayCommand(2.0, SendMessageToPC(oPC, "Prueba de habilidad: "+sSkill+" ¡Exito!: "+sTirada+" vs "+sCD+"."));
                    Exito(oPC, oDestino, iExito);
                    if(GetLocalString(OBJECT_SELF, "DESCRIPCION_EXITO") != "")Descripcionexito(oPC);

                    //Revisamos si tenemos doble exito
                    if(iExito2 > 0)
                        {
                        DelayCommand(2.0, Exito2(oPC, oDestino, iExito2));
                        }
                }

             }
             //Si tenemos habilitado destino trampilla.
             if(iExito == 8)
                {
                    object oDestino = GetObjectByTag(sDestino);
                    DelayCommand(2.0, SendMessageToPC(oPC, "Prueba de habilidad: "+sSkill+" ¡Exito!: "+sTirada+" vs "+sCD+"."));
                    Exito(oPC, oDestino, iExito);
                    if(GetLocalString(OBJECT_SELF, "DESCRIPCION_EXITO") != "")Descripcionexito(oPC);

                    //Revisamos si tenemos doble exito
                    if(iExito2 > 0)
                        {
                        DelayCommand(2.0, Exito2(oPC, oDestino, iExito2));
                        }
                 }


         }
      else
            {
               //Aplicamos el fallooo
                DelayCommand(2.0, SendMessageToPC(oPC, "Prueba de habilidad: "+sSkill+" ¡Fracaso!: "+sTirada+" vs "+sCD+"."));
                Fallo(oPC, iFallo, iDamage, nDamage);
                if(GetLocalString(OBJECT_SELF, "DESCRIPCION_FALLO") != "")   Descripcionfallo(oPC);


                //Revisamos si tenemos doble fallo
                if(iFallo2 > 0)
                    {
                    DelayCommand(2.0, Fallo2(oPC, iFallo2, iDamage, nDamage));
                    }
            }

}
