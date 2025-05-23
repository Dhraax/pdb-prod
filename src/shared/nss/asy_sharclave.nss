//:://////////////////////////////////////////////////
//:: Asy_sharclave
/*
  Se coloca en el  OnHeartbeat script de los Ubicados.

  Este scripts escucha la conversacion de los pjs
  y si han activado la estatua de la diosa, si son
  dignos de ella y han pronunciado la palabra
  adecuada son enviados donde deben.

  Si no son dignos de la diosa esta les muestra una
  pequena advertencia para disuadirlos.


 */
//:://////////////////////////////////////////////////
//::
//:: Creado Por: Asyel
//:: Created On: 12/01/2009
//:://////////////////////////////////////////////////
#include "nw_i0_generic"
void main()
{
  object oEstatua = OBJECT_SELF;
  object openta = GetObjectByTag("asy_oestatuashar3");
  object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,openta, 1, -1,-1,-1,-1);
  string sClave;
  if (GetIsPC(oPC))
  {


    location lLocal1= GetLocation(GetObjectByTag("asy_diosashar2"));
    //Verificamos si han activado la estatua.
    if ((GetLocalInt(oEstatua, "asy_estatua")==1))
    {
      //Verificamos que el pj se ha colocado en el centro del pentagrama.
      if((GetLocalInt(oEstatua, "asy_entpenta")==1))
      {
        //Guarda la palabra clave
        sClave= GetLocalString(oEstatua, "Contrasena");;
        object oSalto;
        //Comprobamos que la estatua es la primera vez que escucha
        if(GetLocalInt(oEstatua, "Hecho")== 0)
        {

            SetListening(oEstatua, TRUE);
            //Indicamos que disocie la palabra clave de los dicho por el pj
            SetListenPattern(oEstatua, "**" + sClave + "**", 9001);
            SetLocalInt(oEstatua, "Hecho", 1);
        }
        int nConver = GetListenPatternNumber();
        //Verificamos si es digno de la diosa. Es decir si es siervo
        //de Shar, si es vampiro y si ha colocado en el centro del pentagrama.
        if ((GetLocalInt(oEstatua, "asy_digno")==1))
        {
           //Verificamos que la estaua ha escuchado al pj
           if(nConver == 9001)
           {
            //Verificamos que el pj ha dicho la palabra correcta.
            if(GetMatchedSubstring(1) == sClave)
            {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_IMP_HARM),oPC);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_FNF_PWKILL),oPC);

                    //SetLocalInt(oEstatua, "Hecho", 0);
                    //SetListenPattern(oEstatua, "**", 500);
                    nConver=0;
                    //Si es Vampiro ira a la cripta vampira,
                    if(GetStringLowerCase(GetSubRace(oPC)) == "vampiro")
                    {

                        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_DUR_DARKNESS ),lLocal1,60.0);
                        AssignCommand(oPC, ActionSpeakString("*Un extraña sensación te invade mientras la oscuridad te envuelve y una extraña fuerza tira de ti.*", TALKVOLUME_TALK));
                        oSalto=GetObjectByTag("inicio_vamps");
                    }//No es un vampiro.
                    //Sino es vampiro verificamos que sea ghoul.
                    else
                    {
                        if(GetStringLowerCase(GetSubRace(oPC)) == "ghul") //Si es Ghoul va al zona de la cripta para los ghouls.
                        {
                            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_DUR_DARKNESS ),lLocal1,60.0);
                            AssignCommand(oPC, ActionSpeakString("*Un extraña sensación te invade mientras la oscuridad te envuelve y una extraña fuerza tira de ti.*", TALKVOLUME_TALK));
                            oSalto=GetObjectByTag("inicio_ghouls");
                        }//no es ghul
                        //Si no es vampiro y no es ghul, es un siervo de la diosa
                        //que ha pronunciado su nombre con lo cual recibira una bendicion.
                        else
                        {

                            //ActionCastSpellAtObject(SPELL_BLESS ,oPC,METAMAGIC_ANY, TRUE);
                            AssignCommand(oPC,ActionCastSpellAtObject(SPELL_BLESS, oPC, METAMAGIC_ANY, TRUE, 4,PROJECTILE_PATH_TYPE_DEFAULT,TRUE));
                            //effect eBlind =  EffectBlindness();
                            //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oPC, 29.0);
                            AssignCommand(oPC, ActionSpeakString("*Notas como la esencia de la diosa recorre tu cuerpo.*", TALKVOLUME_TALK));
                            SetLocalInt(oEstatua, "Hecho",0);
                            SetListenPattern(oEstatua, "**", 500);

                        } //Fin sino es un Ghuls
                    }//Fin sino es un vampiro
                    sClave=" ";
                    ClearActions();
                    SetLocalInt(oEstatua, "Hecho",0);
                    SetListenPattern(oEstatua, "**", 500);
                    AssignCommand(oPC,ActionJumpToObject(oSalto));

             } //Dejamos de verificar que ha dicho la palabra correcta.
           }//Dejamos de verificar si se ha escuchado la palabra.
        }
        else //El pj no es digno siervo de la diosa.
        {
            if(nConver == 9001) //Verificamos que la estatua esta eschuchando por el canal adecuado.
            {
                //Verificamos que el pj indigno ha dicho la palabra correcta.
                if(GetMatchedSubstring(1) == sClave)
                {
                    //La diosa le muestra al ser indigno que se ande con ojo con un terremoto.
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(356), lLocal1);
                    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,EffectVisualEffect(VFX_DUR_DARKNESS ),lLocal1,60.0);
                    AssignCommand(oPC, ActionSpeakString("*Tu sentido común te dice que será mejor que salgas de aqui ya.*", TALKVOLUME_TALK));
                    SetLocalInt(oEstatua, "asy_digno",0);
                    SetLocalInt(oEstatua, "Hecho",0);
                    SetListenPattern(oEstatua, "**", 500);
                    sClave=" ";
                }//Fin de la Verificacion de la palabra clave.
            } //Fin de la Verificacacion de la escucha por el canal adecuado.
       }//Fin del si el pj no es siervo de la diosa.
       //sClave=" ";
       nConver=0;

      }//Fin de la verificacion si el pj se encuentra en el centro del pentagrama.
    }//Fin de la verificacion si el pj ha activado la estatua.




 //SetListeningPatterns();
  }
  SetListeningPatterns();
  sClave=" ";
  ClearActions();
// * End main() * //
}
