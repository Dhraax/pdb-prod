/////////////////////////////////////////////////////////////////////////////
//
//      Poderes Especiales para Bosses Tipo 3 y Tipo 4
//      By Darth
//
//1.    Fuente de Poder: Se crea un ubicado donde sale el bicho (puede salir el ubicado en invisible o no) que hasta que no lo destruyan irá curando al boss todo el rato.
//2.    Ráfaga poderosa de viento: El Boss utiliza una aptitud cada X segundos para crear una poderosa ráfaga de viento que lanza por los aires a los personajes (efecto de esencia impactante). Salvación Reflejos.
//3.    Temblores: El Boss utiliza una aptitud cada X segundos para crear un terremoto que derriba a los personajes. Salvación Reflejos.
//4.    Envenenado: El Boss utiliza una aptitud cada X segundo para envenenar o maldecir a los personajes. Salvación Fortaleza.
//5.    Enajenado: El Boss utiliza una aptitud cada X segundos para confundir, aturdir o lanzar miedo a los personajes. Salvación Voluntad.
//6.    Teleportación: El Boss utiliza una aptitud cada X segundos para que los PJ’s sean teleportados aleatoriamente a otro punto del área (a los waypoints donde salen los encuentros).
//7.    Teleportación: El Boss utiliza una aptitud para huir cada X segundos teleportándose aleatoriamente a otro punto del área (a los waypoints donde salen los encuentros)
//8.    Celda sombría: El Boss encierra a los personajes en una celda que deben romper o disipar para liberarse.
//9.    Alza el vuelo y ataca a distancia: Cada X tiempo el Boss desaparece unos segundos y descarga varios conjuros desde la distancia segura.
//10.   Ilusiones: Cada X tiempo el Boss crea varias copias de si mismo (mismo nombre y apariencia) que desaparecen a los 10 segundos.
//
////////////////////////////////////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

//This internal function of the repelling is not for general use.
location NewLoc(object oTarget, float fDistance);

//Derrumbes
void Derrumba(location lLoc)
{
    effect eDerr = EffectVisualEffect(354);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDerr, lLoc, 4.0);
}

//Limpiar Inventario
void CleanCopy(object oImage)
{
     SetLootable(oImage, FALSE);
     object oItem = GetFirstItemInInventory(oImage);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        oItem = GetNextItemInInventory(oImage);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
     {
        oItem = GetItemInSlot(i, oImage);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }
     TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

//TeleportarPJs
void TeleportarPJs(object oBoss)
{
 //Si ya ha muerto nada...
 if(GetIsDead(oBoss)) return;

 int nDC = (GetHitDice(oBoss) - 10);
 if(nDC < 14) nDC = 14;
 effect eVis = EffectVisualEffect(1233);  //Unsummun red
 effect eExplode = EffectVisualEffect(1847); //Efecto Sombrio
 effect eDrain = EffectDamage(d10(1), DAMAGE_TYPE_MAGICAL);
 string sSpawnPoint;
 location lTarget = GetLocation(oBoss);

    //Apply the fireball explosion at the location captured above.
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oBoss);

    //Localizamos waypoint aleatorio
    switch (Random(2))
    {
        case 0: sSpawnPoint = "SP_ENC_0"; break;
        case 1: sSpawnPoint = "SP_ENC_1"; break;
    }

     object oTarget = GetNearestObjectByTag(sSpawnPoint, oBoss);
     location lTargLoc =  GetLocation(oTarget);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oJugador = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oJugador))
    {
        if(GetIsPC(oJugador) || GetIsEnemy(oJugador, oBoss))
        {
                //Salvacion de Voluntad
                if(!MySavingThrow(SAVING_THROW_WILL, oJugador, nDC, SAVING_THROW_TYPE_SPELL, oBoss))
                    {
                    AssignCommand(oJugador, ClearAllActions(TRUE));
                    SpeakString("¡Hora de viajar!");
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oJugador);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDrain, oJugador);
                    DelayCommand(0.5, AssignCommand(oJugador, ActionJumpToLocation(lTargLoc)));
                    }
                 else
                    {
                    effect eJaulasombria5 = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eJaulasombria5, oJugador);
                    }
        }
       //Select the next target within the spell shape.
       oJugador = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

 if(!GetIsDead(oBoss)) DelayCommand(RoundsToSeconds(4), TeleportarPJs(oBoss));
 else return;

}

void Embestir(object oTarget, float fDistance)
{
 SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z, 1.0);
 location lLoc;
 lLoc= NewLoc(oTarget, fDistance);
 SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_ROTATE_X, 180.0);
 AssignCommand(oTarget, ClearAllActions());
 AssignCommand(oTarget, ActionJumpToLocation(lLoc));
}

void Aterrizar(object oTarget)
{
SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z, 0.0);
}

void Voltear(object oTarget)
{
SetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_ROTATE_X, 0.0);
}

//Salir despedido
void ActionRepel(object oTarget, float fDistance, float fTime)
{
 if(GetLocalInt(oTarget, "SLIDING")==TRUE)
 return;

 float fPause= 0.2; //Retraso para las animaciones

 //Aplicamos la variable embestido.
 SetLocalInt(oTarget, "SLIDING", TRUE);

 //Evitamos cosas raras
 AssignCommand(oTarget, ClearAllActions());
 AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, fPause));

 //Lo hacemos volar
 DelayCommand(fPause, Embestir(oTarget, fDistance));
 DelayCommand(fPause+fPause, Aterrizar(oTarget));
 DelayCommand(fTime-fPause+fPause+0.3, Voltear(oTarget));
 DelayCommand(fPause+fPause+0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, fTime-fPause+fPause+0.3));
 DelayCommand(fPause+fPause+0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(460), oTarget, 1.0));
 DelayCommand(fTime-fPause+fPause+0.3, SetLocalInt(oTarget, "SLIDING", FALSE));

}

//Ubicación aleatoria según posición del jugador
location NewLoc(object oTarget, float fDistance)
{
 vector v1= GetPosition(oTarget);
 vector v2= GetPosition(OBJECT_SELF);
 vector v3;
 vector v4= v2*-1.0;
 vector vn= v1+v4;
 vn= VectorNormalize(vn);
 vn= vn*fDistance;
 vn= vn+v1;
 int nNth=1;

 object oWp= GetNearestObjectByTag("repel_limit_marker", oTarget, nNth);
 while(GetIsObjectValid(oWp))
 {
 nNth++;
 v3= GetPosition(oWp);
 if(((v3.x<vn.x)&&(v2.x<v3.x))||((v3.x>vn.x)&&(v2.x>v3.x)))
 vn.x=v3.x;
 if(((v3.y<vn.y)&&(v2.y<v3.y))||((v3.y>vn.y)&&(v2.y>v3.y)))
 vn.y=v3.y;
 oWp= GetNearestObjectByTag("repel_limit_marker", oTarget, nNth);
 }

 return Location(GetArea(OBJECT_SELF), vn, GetFacing(OBJECT_SELF));
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// LISTADO DE PODERES
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//1. FUENTE DE PODER
void Fuentedepoder(object oBoss)
{
    //Si ya ha muerto nada...
    if(GetIsDead(oBoss)) return;
    object oCura;
    int iMax = GetMaxHitPoints(oBoss);
    effect eHeal = EffectHeal(iMax);
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
    effect eVis2 = EffectVisualEffect(258);

    //oCura = CreateObject(OBJECT_TYPE_PLACEABLE, "Filactelia", GetLocation(oBoss));
    object oFilactelia = GetNearestObjectByTag("Filactelia", oBoss);

    //Comprobamos la filactelia
    if(oFilactelia != OBJECT_INVALID)
      {
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oBoss);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oBoss);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oFilactelia);
       DelayCommand(4.0, Fuentedepoder(oBoss));
      }
    else return;
}


//2. RAFAGA PODEROSA
void RafagaPoderosa(object oBoss)
{
    //Si ya ha muerto nada...
    if(GetIsDead(oBoss)) return;

    //Declare major variables
    int nDC = (GetHitDice(oBoss) - 10);
    if(nDC < 14) nDC = 14;
    string sAOETag;
    float fDelay;
    float fDistance = 1.0 + d6();

    //Efectos Rafaga de viento
    effect eExplode = EffectVisualEffect(285); //Tornado

    //Ubicacion del boss
    location lTarget = GetLocation(oBoss);

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eExplode, lTarget, 3.0);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
        {
            // Gust of wind should only destroy "cloud/fog like" area of effect spells.
            sAOETag = GetTag(oTarget);
            if ( sAOETag == "VFX_PER_FOGACID" ||
                 sAOETag == "VFX_PER_FOGKILL" ||
                 sAOETag == "VFX_PER_FOGBEWILDERMENT" ||
                 sAOETag == "VFX_PER_FOGSTINK" ||
                 sAOETag == "VFX_PER_FOGFIRE" ||
                 sAOETag == "VFX_PER_FOGMIND" ||
                 sAOETag == "VFX_PER_CREEPING_DOOM")
            {
                DestroyObject(oTarget);
            }
        }
        else if(oTarget != oBoss) {
                SignalEvent(oTarget, EventSpellCastAt(oBoss, SPELL_FIRE_STORM));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE, oBoss))
                {
                    AssignCommand(oTarget, ClearAllActions()); // prevenimos cosas raras
                    DelayCommand(fDelay, ActionRepel(oTarget, fDistance, 6.0));
                    FloatingTextStringOnCreature("*¡Una fuerte rafaga de viento te impulsa hacia atrás!*", oTarget);
                }
                else
                {
                effect eJaulasombria5 = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eJaulasombria5, oTarget);
                }
            }

       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    //Cada 4 asaltos
    if(!GetIsDead(oBoss)) DelayCommand(RoundsToSeconds(5), RafagaPoderosa(oBoss));
    else return;
}


//3. TEMBLORES
void Temblores(object oBoss)
{
     //Si ya ha muerto nada...
    if(GetIsDead(oBoss)) return;

    //Declare major variables
     int nDC = (GetHitDice(oBoss) - 10);
     if(nDC < 14) nDC = 14;

    //Ubicacion del boss
    location lTarget = GetLocation(oBoss);

    //Efecto del Boss
    effect eVis = EffectVisualEffect(460); //Polvo en el suelo
    effect eVis2 = EffectVisualEffect(928); //Terremoto fisura
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oBoss);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lTarget);


    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);

    location lLoc = GetLocation(oTarget);
    int i, nRand;
    float x,y, fDelay;

        //El Terremoto
        string sMensaje = ("*Da un pisotón en el suelo*");
        SpeakString("<c!}þ>" + sMensaje + "</c>");
        AssignCommand ( oBoss, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), lTarget));
        AssignCommand ( oBoss, DelayCommand( 2.8, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_SCREEN_BUMP), lTarget)));
        AssignCommand ( oBoss, DelayCommand( 3.0, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_SCREEN_SHAKE), lTarget)));
        AssignCommand ( oBoss, DelayCommand( 4.5, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_SCREEN_BUMP), lTarget)));
        AssignCommand ( oBoss, DelayCommand( 5.8, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect ( VFX_FNF_SCREEN_BUMP), lTarget)));
        // tell the DM object to play an earthquake sound
        AssignCommand ( oBoss, PlaySound ("as_cv_boomdist1"));
        AssignCommand ( oBoss, DelayCommand ( 2.0, PlaySound ("as_wt_thunderds3")));
        AssignCommand ( oBoss, DelayCommand ( 4.0, PlaySound ("as_cv_boomdist1")));
        // create a dust plume at the DM and clicking location
        object oTargetArea = GetArea(oBoss);
        int nXPos, nYPos, nCount;
        for(nCount = 0; nCount < 15; nCount++)
        {
        nXPos = Random(30) - 15;
        nYPos = Random(30) - 15;

        vector vNewVector = GetPosition(oBoss);
        vNewVector.x += nXPos;
        vNewVector.y += nYPos;

        location lDustLoc = Location(oTargetArea, vNewVector, 0.0);
        object oDust = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_dustplume", lDustLoc, FALSE);
        DelayCommand ( 4.0, DestroyObject ( oDust));
        }

        for(i = 1; i <= 15; i++)
            {
            vector vPos = GetPosition(oTarget);
            x = IntToFloat(Random(20) - 10);
            y = IntToFloat(Random(20) - 10);
            vPos.z = 14.0;
            vPos.x += x;
            vPos.y += y;
            location lLoc = Location(GetArea(oTarget), vPos, 0.0);
            nRand = Random(6);
            fDelay = nRand * 1.0;
            DelayCommand(fDelay, Derrumba(lLoc));
            }

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if(GetIsPC(oTarget) || GetIsEnemy(oTarget, oBoss))
        {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oBoss, SPELL_RAY_OF_ENFEEBLEMENT));

                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE, oBoss))
                {
                    effect eDam = EffectDamage(d6(3)+3, DAMAGE_TYPE_BLUDGEONING);
                    FloatingTextStringOnCreature("*Se desprenden montones de rocas que caen sobre ti*", oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                }
                else
                {
                    effect eJaulasombria5 = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eJaulasombria5, oTarget);
                }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    if(!GetIsDead(oBoss)) DelayCommand(RoundsToSeconds(5), Temblores(oBoss));
}

//4. VENENO
void Veneno(object oBoss)
{
    //Si ya ha muerto nada...
    if(GetIsDead(oBoss)) return;
    //Declare major variables
    int nDC = (GetHitDice(oBoss) - 10);
     if(nDC < 14) nDC = 14;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_HORRID_WILTING); //Pulse green
    effect eVis = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_ACID); //IMP_POISION

    location lTarget = GetLocation(oBoss);

    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if(GetIsPC(oTarget) || GetIsEnemy(oTarget, oBoss))
        {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oBoss, SPELL_RAY_OF_ENFEEBLEMENT));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                //Salvacion de Fortaleza
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON, oBoss))
                {
                    effect ePosion = EffectPoison(POISON_COLOSSAL_SPIDER_VENOM);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePosion, oTarget, RoundsToSeconds(10));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
                else
                {
                    effect eJaulasombria5 = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eJaulasombria5, oTarget);
                }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    if(!GetIsDead(oBoss)) DelayCommand(RoundsToSeconds(5), Veneno(oBoss));
    else return;
}

//5. CONFUSION
void Confusion(object oBoss)
{
    //Si ya ha muerto nada...
    if(GetIsDead(oBoss)) return;
    //Declare major variables
    int nDC = (GetHitDice(oBoss) - 10);
     if(nDC < 14) nDC = 14;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_HOWL_MIND); //Anillo mental
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDrain = EffectConfused();
    //Localizacion del boss
    location lTarget = GetLocation(oBoss);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);

    //Aplicamos la accion de conjurar
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oBoss);

    while (GetIsObjectValid(oTarget))
    {
        if(GetIsPC(oTarget) || GetIsEnemy(oTarget, oBoss))
        {
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                //Salvacion de Voluntad
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oBoss))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDrain, oTarget, RoundsToSeconds(5)));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(5)));
                }
                else
                {
                    effect eJaulasombria5 = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eJaulasombria5, oTarget));
                }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    if(!GetIsDead(oBoss)) DelayCommand(RoundsToSeconds(5), Confusion(oBoss));
    else return;
}

//6. TELEPORTACION BOSS
void TeleportacionBoss(object oBoss)
{
 //Si ya ha muerto nada...
 if(GetIsDead(oBoss)) return;
 int iMax = (d12()+ GetHitDice(oBoss));
 float fDistance = 0.0;
 effect eHeal = EffectHeal(iMax);
 effect eVis = EffectVisualEffect(1233); //Unsummun red
 effect eCuracion = EffectVisualEffect(67); //Curación
 object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oBoss, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, -1, -1);

 //Diferentes distancias
  switch (Random(4))
    {
        case 0: fDistance = 10.0; break;
        case 1: fDistance = 15.0; break;
        case 2: fDistance = 22.0; break;
        case 3: fDistance = 5.0; break;
    }

 //Movemos al boss a la nueva ubicación aleatoria
    location lDustLoc = GetLocation(oBoss);
    location lTargLoc = NewLoc(oTarget, fDistance);

    //Creamos la posicion antigua del boss
    object oDust = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_dustplume", lDustLoc, FALSE);
    DestroyObject(oDust, 3.0);
    location lTarget = GetLocation(oDust);

//Aplicamos efectos y lo movemos.
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oBoss);
    AssignCommand(oBoss, ClearAllActions(TRUE));
    DelayCommand(0.5, AssignCommand(oBoss, ActionSpeakString("¡Mi poder es infinito!")));
    DelayCommand(1.0, AssignCommand(oBoss, ActionJumpToLocation(lTargLoc)));
    DelayCommand(1.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCuracion, oBoss));
    DelayCommand(1.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oBoss));
    DelayCommand(1.5, ActionCastSpellAtLocation(SPELL_GREAT_THUNDERCLAP, lTarget, METAMAGIC_NONE, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
    DelayCommand(1.5, AssignCommand(oBoss, ActionAttack(oTarget)));


 if(!GetIsDead(oBoss)) DelayCommand(RoundsToSeconds(5), TeleportacionBoss(oBoss));
 else return;

}

//7. TELEPORTACION PJS
void TeleportacionPJs(object oBoss)
{
 if(!GetIsDead(oBoss)) DelayCommand(RoundsToSeconds(2), TeleportarPJs(oBoss));
}

//8. CELDASOMBRIA
void CeldaSombria(object oBoss)
{
 //Si ya ha muerto nada...
 if(GetIsDead(oBoss)) return;

 int nDC = (GetHitDice(oBoss) - 10);
 if(nDC < 14) nDC = 14;

 effect eDur  = EffectVisualEffect(1208); //FNF_STRIKE_EVIL
 effect eDur2 = EffectVisualEffect(1847); //Cancion Maldita
 effect eExplode = EffectLinkEffects(eDur,eDur2);
 effect eJaulasombria1 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
 effect eJaulasombria2 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
 effect eJaulasombria3 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
 effect eJaulasombria4 = SupernaturalEffect(EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));
 effect eDur4 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
 effect eDur5 = EffectVisualEffect(VFX_DUR_PARALYZED);
 effect eDur6 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
 effect eLink = EffectLinkEffects(eDur4, EffectParalyze());
 eLink = EffectLinkEffects(eLink, eDur5);
 eLink = EffectLinkEffects(eLink, eDur6);
 effect eDrain = EffectDamage(d10(2), DAMAGE_TYPE_MAGICAL);

    //Apply the fireball explosion at the location captured above.
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oBoss);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oJugador = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oBoss, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, -1, -1);

        if(GetIsPC(oJugador) && GetIsEnemy(oJugador, oBoss))
        {
               //Obtenemos ubicacion del jugador
               location lLugarActivado = GetLocation(oJugador);

                //Salvacion de Voluntad
                int iTirada = d20() + GetSpellResistance(oJugador);  // Salvacion: d20 + Resistencia magica
                if(iTirada < nDC)
                {
                    SpeakString("¡Ya eres mio!");
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eJaulasombria1, lLugarActivado);
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eJaulasombria2, lLugarActivado);
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eJaulasombria3, lLugarActivado);
                    //Creamos la jaula alrededor del PJ
                    AssignCommand(oJugador, ClearAllActions()); // prevenimos cosas raras
                    SetCommandable(FALSE,oJugador);
                    object oJaula = CreateObject(OBJECT_TYPE_PLACEABLE, "jaulaboss", lLugarActivado);
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eJaulasombria4, oJaula);
                    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDrain, oJugador));
                    DelayCommand(0.7, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oJugador, RoundsToSeconds(2)));
                    DelayCommand(1.0, SetCommandable(TRUE,oJugador));
                    DestroyObject(oJaula, RoundsToSeconds(5));
                }
                else
                {
                    effect eJaulasombria5 = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eJaulasombria5, oJugador);
                }
        }


 if(!GetIsDead(oBoss)) DelayCommand(RoundsToSeconds(6), CeldaSombria(oBoss));
 else return;

}

//9. VOLAR
void Volar(object oBoss)
{
 //Si ya ha muerto nada...
 if(GetIsDead(oBoss)) return;


      //Fire Damage
      int nDamage = d10(2)+GetHitDice(oBoss);
      int nDC = (GetHitDice(oBoss) - 10);
      if(nDC < 14) nDC = 14;;

      //Efectos
      effect eVolar = EffectDisappearAppear(GetLocation(oBoss));
      effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
      effect eVis2 = EffectVisualEffect(460); //Polvo en el suelo
      effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
      effect eFire = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE); //Hellfire
      effect eFire1 = EffectVisualEffect(23); //Tormenta de fuego
      effect eFire2 = EffectVisualEffect(770); //Hellfire Storm
      effect eFire3 = EffectAreaOfEffect(AOE_PER_FOGFIRE, "****", "****", "****"); //AoeFire
      effect eHit = EffectVisualEffect(VFX_IMP_FLAME_M);

      //Buscamos al mas cercano
      object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oBoss, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, -1, -1);
      location lBossLoc = GetLocation(oBoss);
      object oDust = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_dustplume", lBossLoc, FALSE);
      DelayCommand (5.8, DestroyObject ( oDust));

      //Buscamos el ubicado invisible para crear la zona de daño
      location lDustLoc = GetLocation(oDust);

      //Alzamos el vuelo y lanzamos tormenta de fuego!
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVolar, oBoss, 6.0));
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oBoss));
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oBoss));
      DelayCommand(1.1, SetImmortal(oBoss, TRUE));
      DelayCommand(2.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFire1, lDustLoc));
      DelayCommand(2.9, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFire, lDustLoc));
      DelayCommand(3.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFire2, lDustLoc));
      DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eFire3, lDustLoc, 3.0));
      DelayCommand(6.0, SetImmortal(oBoss, FALSE));

      //Buscamos jugadores dentro del area de efecto
      object oJugador = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lDustLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
      while (GetIsObjectValid(oJugador))
        {
            SignalEvent(oJugador, EventSpellCastAt(oBoss, SPELL_FIRE_STORM));

            nDamage = GetReflexAdjustedDamage(nDamage/2, oJugador, nDC, SAVING_THROW_TYPE_FIRE, oBoss);

            if(oJugador != oBoss && oJugador != oDust) {
               //Aplicamos danyo fuego
               DelayCommand(2.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oJugador));
               DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oJugador));
               DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oJugador));
               DelayCommand(3.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oJugador));
               }

        //Select the next target within the spell shape.
        oJugador = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lDustLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE );
        }


 if(!GetIsDead(oBoss))DelayCommand(RoundsToSeconds(5), Volar(oBoss));;
}

//10. ILUSIONES
void Ilusiones(object oBoss)
{
 //Si ya ha muerto nada...
 if(GetIsDead(oBoss)) return;

 //Efectos
 effect eVis = EffectVisualEffect(481); //Summon Dragon
 effect eVis2 = EffectVisualEffect(1535); //Epic Undead Purple
 effect eAdios = EffectVisualEffect(1233); //Unsummun red

 //Aplicamos efecto al boss
 DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oBoss));
 DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oBoss));

 //Creamos 2 copias del boss
 location lTarget = GetLocation(oBoss);
 object oCopy = CopyObject(oBoss, lTarget, OBJECT_INVALID, "Clone"+GetName(oBoss));
 object oCopy2 = CopyObject(oBoss, lTarget, OBJECT_INVALID, "Clone2"+GetName(oBoss));
 location lCopy = GetLocation(oCopy);

 //Limpiamos inventario y generamos efectos
 DelayCommand(0.1f, CleanCopy(oCopy));
 DelayCommand(0.1f, CleanCopy(oCopy2));
 DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCopy));
 DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oCopy));
 DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCopy2));
 DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oCopy2));
 DelayCommand(0.3f, SetImmortal(oBoss, TRUE));
 DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), oCopy, 1.0));
 DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), oBoss, 1.0));
 DelayCommand(0.3f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), oCopy2, 1.0));
 DelayCommand(0.5f, AssignCommand(oCopy, ClearAllActions(TRUE)));
 DelayCommand(0.5f, AssignCommand(oBoss, ClearAllActions(TRUE)));
 DelayCommand(0.8f, AssignCommand(oCopy, JumpToLocation(lTarget)));
 DelayCommand(0.8f, AssignCommand(oBoss, JumpToLocation(lCopy)));
 DelayCommand(1.0f, SetImmortal(oBoss, FALSE));

 //Las Destruimos despues de 2 asaltos
 DelayCommand(RoundsToSeconds(1)- 1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAdios, oCopy));
 DelayCommand(RoundsToSeconds(1)- 1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAdios, oCopy2));
 DestroyObject(oCopy,RoundsToSeconds(1));
 DestroyObject(oCopy2,RoundsToSeconds(1));

 if(!GetIsDead(oBoss))DelayCommand(RoundsToSeconds(6), Ilusiones(oBoss));
}

//11. TENTACULOS KRAKEN
void Kraken(object oBoss)
{
    //Si ya ha muerto nada...
    if(GetIsDead(oBoss)) return;
    //Declare major variables
    int nDC = (GetHitDice(oBoss) - 10);
     if(nDC < 14) nDC = 14;
    float fDelay;
    int nDamage = d10(3)+ GetAbilityModifier(ABILITY_STRENGTH, oBoss);
    effect eExplode = EffectVisualEffect(VFX_FNF_LOS_EVIL_30); //Pulse green
    effect eVis = EffectVisualEffect(VFX_DUR_TENTACLE); //Tentaculos
    effect eVis2 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD); //Paralizado
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);

    location lTarget = GetLocation(oBoss);

    //Apply the fireball explosion at the location captured above.
    SpeakString("*¡Lanza sus tentaculos!*");
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if(GetIsPC(oTarget) || GetIsEnemy(oTarget, oBoss))
        {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oBoss, SPELL_RAY_OF_ENFEEBLEMENT));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                //Salvacion de Fortaleza
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE, oBoss))
                {
                    effect eParalizar = EffectParalyze();
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalizar, oTarget, RoundsToSeconds(3));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(3)));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oTarget, RoundsToSeconds(3)));
                    DelayCommand(fDelay, FloatingTextStringOnCreature("*¡Los tentaculos te atrapan!*", oTarget, FALSE));
                    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE, oBoss))
                      {
                        DelayCommand(3.0, FloatingTextStringOnCreature("*¡Los tentaculos te aplastan!*", oTarget, FALSE));
                        DelayCommand(3.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                      }
                }
                else
                {
                    effect eJaulasombria5 = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eJaulasombria5, oTarget);
                }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    if(!GetIsDead(oBoss)) DelayCommand(RoundsToSeconds(5), Kraken(oBoss));
    else return;
}

//Lanzamos el SCRIPT según variable del Boss
void main ()
{
object oBoss = OBJECT_SELF;
int oPoder = GetLocalInt(oBoss, "PODER_ESPECIAL");

//Solo una vez
if(GetLocalInt(oBoss, "YATENGOPODER") != FALSE) return;
SetLocalInt(oBoss, "YATENGOPODER", TRUE);

switch(oPoder)
        {
       case 1: Fuentedepoder(oBoss); break;
       case 2: RafagaPoderosa(oBoss); break;
       case 3: Temblores(oBoss); break;
       case 4: Veneno(oBoss); break;
       case 5: Confusion(oBoss); break;
       case 6: TeleportacionBoss(oBoss); break;
       case 7: TeleportacionPJs(oBoss); break;
       case 8: CeldaSombria(oBoss); break;
       case 9: Volar(oBoss); break;
       case 10: Ilusiones(oBoss); break;
       case 11: Kraken(oBoss); break;
        }

}




