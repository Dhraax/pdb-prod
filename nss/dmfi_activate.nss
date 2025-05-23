void dmw_CleanUp(object oMySpeaker)
{
   int nCount;
   int nCache;
   DeleteLocalObject(oMySpeaker, "dmfi_univ_target");
   DeleteLocalLocation(oMySpeaker, "dmfi_univ_location");
   DeleteLocalObject(oMySpeaker, "dmw_item");
   DeleteLocalString(oMySpeaker, "dmw_repamt");
   DeleteLocalString(oMySpeaker, "dmw_repargs");
   nCache = GetLocalInt(oMySpeaker, "dmw_playercache");
   for(nCount = 1; nCount <= nCache; nCount++)
   {
      DeleteLocalObject(oMySpeaker, "dmw_playercache" + IntToString(nCount));
   }
   DeleteLocalInt(oMySpeaker, "dmw_playercache");
   nCache = GetLocalInt(oMySpeaker, "dmw_itemcache");
   for(nCount = 1; nCount <= nCache; nCount++)
   {
      DeleteLocalObject(oMySpeaker, "dmw_itemcache" + IntToString(nCount));
   }
   DeleteLocalInt(oMySpeaker, "dmw_itemcache");
   for(nCount = 1; nCount <= 10; nCount++)
   {
      DeleteLocalString(oMySpeaker, "dmw_dialog" + IntToString(nCount));
      DeleteLocalString(oMySpeaker, "dmw_function" + IntToString(nCount));
      DeleteLocalString(oMySpeaker, "dmw_params" + IntToString(nCount));
   }
   DeleteLocalString(oMySpeaker, "dmw_playerfunc");
   DeleteLocalInt(oMySpeaker, "dmw_started");
}


void main()
{
    object oUser=OBJECT_SELF;
    if (!GetIsObjectValid(oUser)) oUser = GetItemActivator();
    object oItem = GetLocalObject(oUser, "dmfi_item");
    if (!GetIsObjectValid(oItem)) oItem=GetItemActivated();
    object oOther = GetLocalObject(oUser, "dmfi_target");
    if (!GetIsObjectValid(oOther)) oOther=GetItemActivatedTarget();
    location lLocation=GetLocalLocation(oUser, "dmfi_location");
    if (!GetIsObjectValid(GetAreaFromLocation(lLocation))) lLocation = GetItemActivatedTargetLocation();
    string sItemTag=GetTag(oItem);



//initialize the listening commands reminder
    if (GetLocalInt(GetModule(), "dmfi_voice_initial")!=1 && (GetLocalInt(oUser, "dmfi_reminded")!=1)
        &&(GetIsDM(oUser)))
            {
            SetLocalInt(oUser, "dmfi_reminded", 1);
            SendMessageToAllDMs("Apunta a una criatura con la herramienta de Voz para iniciar el sistema.");
            FloatingTextStringOnCreature("Apunta a una criatura con la herramienta de Voz para iniciar el sistema.", oUser);
            }

//*************************************INITIALIZATION CODE***************************************
//***************************************RUNS ONE TIME ***************************************

//voice stuff is module wide

    if (GetLocalInt(GetModule(), "dmfi_initialized")!=1)
        {
        SetLocalInt(GetModule(), "dmfi_initialized", 1);
        int iLoop = 20610;
        string sText;
        while (iLoop<20680)
            {
            sText = GetCampaignString("dmfi", "hls" + IntToString(iLoop));
            SetCustomToken(iLoop, sText);
            iLoop++;
            }
        SendMessageToAllDMs("Tokens de Voz inicializados.");
        }


//remainder of settings are user based

    if ((GetLocalInt(oUser, "dmfi_initialized")!=1) && GetIsDM(oUser))
    {
    //if you have campaign variables set - use those settings
    if (GetCampaignInt("dmfi", "Settings", oUser)==1)
        {
        FloatingTextStringOnCreature("Configuracion restaurada", oUser, FALSE);
        SetLocalInt(oUser, "dmfi_initialized", 1);

        int n = GetCampaignInt("dmfi", "dmfi_alignshift", oUser);
        SetCustomToken(20781, IntToString(n));
        SetLocalInt(oUser, "dmfi_alignshift", n);
        SendMessageToPC(oUser, "Ajustes: Cambio Alineamiento: "+IntToString(n));


        n = GetCampaignInt("dmfi", "dmfi_safe_factions", oUser);
        SetLocalInt(oUser, "dmfi_safe_factions", n);
        SendMessageToPC(oUser, "Ajustess: Facciones (1 es DMFI Safe Faction): "+IntToString(n));

        n = GetCampaignInt("dmfi", "dmfi_damagemodifier", oUser);
        SetLocalInt(oUser, "dmfi_damagemodifier",n);
        SendMessageToPC(oUser, "Ajustes: Modificadores Daño: "+IntToString(n));

        n = GetCampaignInt("dmfi","dmfi_buff_party",oUser);
        SetLocalInt(oUser, "dmfi_buff_party", n);
        if (n==1)
            SetCustomToken(20783, "Party");
        else
            SetCustomToken(20783, "Single Target");

        SendMessageToPC(oUser, "Ajustes: Bendecir Grupo (1 es Grupo): "+IntToString(n));

        string sLevel = GetCampaignString("dmfi", "dmfi_buff_level", oUser);
        SetCustomToken(20782, sLevel);
        SetLocalString(oUser, "dmfi_buff_level", sLevel);
        SendMessageToPC(oUser, "Ajustes: Nivel Aureola: "+ sLevel);

        float f = GetCampaignFloat("dmfi", "dmfi_reputaion", oUser);
        SetLocalFloat(oUser, "dmfi_reputation", f);
        SendMessageToPC(oUser, "Ajustess: Ajuste de Reputacion: "+FloatToString(f));

               f = GetCampaignFloat("dmfi", "dmfi_effectduration", oUser);
               SetLocalFloat(oUser, "dmfi_effectduration", f);
               SendMessageToPC(oUser, "Ajustess: Duracion de Efecto: "+FloatToString(f));

               f = GetCampaignFloat("dmfi", "dmfi_sound_delay", oUser);
               SetLocalFloat(oUser, "dmfi_sound_delay", f);
               SendMessageToPC(oUser, "Ajustess: Retraso de Sonido: "+FloatToString(f));

               f = GetCampaignFloat("dmfi", "dmfi_beamduration", oUser);
               SetLocalFloat(oUser, "dmfi_beamduration", f);
               SendMessageToPC(oUser, "Ajustess: Duracion de Rayo: "+FloatToString(f));

               f = GetCampaignFloat("dmfi", "dmfi_stunduration", oUser);
               SetLocalFloat(oUser, "dmfi_stunduration", f);
               SendMessageToPC(oUser, "Ajustes: Duracion Aturdidora: "+FloatToString(f));

               f = GetCampaignFloat("dmfi", "dmfi_saveamount", oUser);
               SetLocalFloat(oUser, "dmfi_saveamount", f);
               SendMessageToPC(oUser, "Ajustes: Ajuste de Salvacion: "+FloatToString(f));

               f = GetCampaignFloat("dmfi", "dmfi_effectdelay", oUser);
               SetLocalFloat(oUser, "dmfi_effectdelay", f);
               SendMessageToPC(oUser, "Ajustes: Efecto Retraso: "+FloatToString(f));

        }
        else
        {
        FloatingTextStringOnCreature("Ajustes por defecto Inizializados", oUser, FALSE);
        //Setting FOUR campaign variables so 1st use will be slow.
        //Recommend initializing your preferences with no players or
        //while there is NO fighting.
        SetLocalInt(oUser, "dmfi_initialized", 1);
        SetCampaignInt("dmfi", "Settings", 1, oUser);

        SetCustomToken(20781, "5");
        SetLocalInt(oUser, "dmfi_alignshift", 5);
        SetCampaignInt("dmfi", "dmfi_alignshift", 5, oUser);
        SendMessageToPC(oUser, "Ajusts: Cambio alineamiento: 5");

        SetCustomToken(20783, "Single Target");
        SetLocalInt(oUser, "dmfi_buff_party", 0);
        SetCampaignInt("dmfi", "dmfi_buff_party", 0, oUser);
        SendMessageToPC(oUser, "Ajustes: Bendicion a Objetivo Solitario: ");

        SetCustomToken(20782, "Low");
        SetLocalString(oUser, "dmfi_buff_level", "LOW");
        SetCampaignString("dmfi", "dmfi_buff_level", "LOW", oUser);
        SendMessageToPC(oUser, "Ajustes: Nivel de porteccion en BAJO: ");

        SetLocalInt(oUser, "dmfi_dicebag", 0);
        SetCustomToken(20681, "Private");
        SetCampaignInt("dmfi", "dmfi_dicebag", 0, oUser);
        SendMessageToPC(oUser, "Ajustes: Tiradas del cubilete en PRIVADO");

        SetLocalInt(oUser, "", 0);
        SetCampaignInt("dmfi", "dmfi_safe_factions", 0, oUser);
        SendMessageToPC(oUser, "Ajustes: Facciones al estandard de Bioware");

        SetLocalFloat(oUser, "dmfi_reputation", 5.0);
        SetCustomToken(20784, "5");
        SetCampaignFloat("dmfi", "dmfi_reputation", 5.0, oUser);
        SendMessageToPC(oUser, "Ajustess: Ajuste de Reputacion : 5");

        SetCampaignFloat("dmfi", "dmfi_effectduration", 60.0, oUser);
        SetLocalFloat(oUser, "dmfi_effectduration", 60.0);
        SetCampaignFloat("dmfi", "dmfi_sound_delay", 0.2, oUser);
        SetLocalFloat(oUser, "dmfi_sound_delay", 0.2);
        SetCampaignFloat("dmfi", "dmfi_beamduration", 5.0, oUser);
        SetLocalFloat(oUser, "dmfi_beamduration", 5.0);
        SetCampaignFloat("dmfi", "dmfi_stunduration", 1000.0,  oUser);
        SetLocalFloat(oUser, "dmfi_stunduration", 1000.0);
        SetCampaignFloat("dmfi", "dmfi_saveamount", 5.0, oUser);
        SetLocalFloat(oUser, "dmfi_saveamount", 5.0);
        SetCampaignFloat("dmfi", "dmfi_effectdelay", 1.0, oUser);
        SetLocalFloat(oUser, "dmfi_effectdelay", 1.0);

        SendMessageToPC(oUser, "Ajustes: Duracion Efecto: 60.0");
        SendMessageToPC(oUser, "Ajustes: Retraso Efecto: 1.0");
        SendMessageToPC(oUser, "Ajustes: Duracion Rayo: 5.0");
        SendMessageToPC(oUser, "Ajustes: Duracion Aturde: 1000.0");
        SendMessageToPC(oUser, "Ajustes: Retraso de Sonido: 0.2");
        SendMessageToPC(oUser, "Ajustes: Ajuste de salvacion: 5.0");

        }
    }
//********************************END INITIALIZATION***************************

    dmw_CleanUp(oUser);

    if (GetStringLeft(sItemTag, 8) == "dmfi_pc_")
    {
        SetLocalObject(oUser, "dmfi_univ_target", oUser);
        SetLocalLocation(oUser, "dmfi_univ_location", lLocation);
        SetLocalString(oUser, "dmfi_univ_conv", GetStringRight(sItemTag, GetStringLength(sItemTag) - 5));
        AssignCommand(oUser, ClearAllActions());
        AssignCommand(oUser, ActionStartConversation(OBJECT_SELF, "dmfi_universal", TRUE));
        return;
    }

    if (GetStringLeft(sItemTag, 5) == "dmfi_")
    {
        int iPass = FALSE;

        if (GetIsDM(oUser) || GetIsDMPossessed(oUser))
            iPass = TRUE;

        if (!GetIsPC(oUser))
            iPass = TRUE;

        if (!iPass)
        {
            FloatingTextStringOnCreature("No puedes usar este objeto" ,oUser, FALSE);
            SendMessageToAllDMs(GetName(oUser, TRUE)+ " está intentando usar un objeto de DM.");
            return;
        }

        if (sItemTag == "dmfi_exploder")
        {
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_afflict"))) CreateItemOnObject("dmfi_afflict", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_pc_emote"))) CreateItemOnObject("dmfi_pc_emote", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_server"))) CreateItemOnObject("dmfi_server", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_emote"))) CreateItemOnObject("dmfi_emote", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_fx"))) CreateItemOnObject("dmfi_fx", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_sound"))) CreateItemOnObject("dmfi_sound", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_voice"))) CreateItemOnObject("dmfi_voice", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_mute"))) CreateItemOnObject("dmfi_mute", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_peace"))) CreateItemOnObject("dmfi_peace", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_voicewidget"))) CreateItemOnObject("dmfi_voicewidget", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_dmw"))) CreateItemOnObject("dmfi_dmw", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_target"))) CreateItemOnObject("dmfi_target", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_buff"))) CreateItemOnObject("dmfi_buff", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_faction"))) CreateItemOnObject("dmfi_faction", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_onering"))) CreateItemOnObject("dmfi_onering", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "sly_musicwand"))) CreateItemOnObject("sly_musicwand", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "pb_seg"))) CreateItemOnObject("pb_seg", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "brouillard"))) CreateItemOnObject("batonmeteo", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "sf_wingwand"))) CreateItemOnObject("sf_wingwand", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "varitadeidad"))) CreateItemOnObject("varitadeaveri001", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "mti_desbloqueos"))) CreateItemOnObject("mti_desbloqueos", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "act_drow_spf"))) CreateItemOnObject("varitaactivadora", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "ms_semidrowspf"))) CreateItemOnObject("ms_semidrowspf", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "Mali_DM_PAA"))) CreateItemOnObject("mali_dm_paa", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "mali_dm_stage"))) CreateItemOnObject("mali_dm_stage", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "ZEP_CW_IT"))) CreateItemOnObject("zep_cw_it", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "mali_enc"))) CreateItemOnObject("mali_enc", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "mali_enc_ditto"))) CreateItemOnObject("mali_enc_ditto", oOther);
            if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dm_vfx_item"))) CreateItemOnObject("dm_vfx_item", oOther);
            return;
        }
        if (sItemTag == "dmfi_peace")
        {   //This widget sets all creatures in the area to a neutral stance and clears combat.
            object oArea = GetFirstObjectInArea(GetArea(oUser));
            object oP;
            while (GetIsObjectValid(oArea))
            {
                if (GetObjectType(oArea) == OBJECT_TYPE_CREATURE && !GetIsPC(oArea))
                {
                    AssignCommand(oArea, ClearAllActions());
                    oP = GetFirstPC();
                    while (GetIsObjectValid(oP))
                    {
                        if (GetArea(oP) == GetArea(oUser))
                        {
                            ClearPersonalReputation(oArea, oP);
                            SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 25, oP);
                            SetStandardFactionReputation(STANDARD_FACTION_COMMONER, 91, oP);
                            SetStandardFactionReputation(STANDARD_FACTION_MERCHANT, 91, oP);
                            SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 91, oP);
                        }
                        oP = GetNextPC();
                    }
                    AssignCommand(oArea, ClearAllActions());
                }
                oArea = GetNextObjectInArea(GetArea(oUser));
            }
        }
        if (sItemTag == "dmfi_voicewidget")
        {
            object oVoice;
            //Destroy any existing Voice attached to the user
            if (GetIsObjectValid(GetLocalObject(oUser, "dmfi_MyVoice")))
            {
                DestroyObject(GetLocalObject(oUser, "dmfi_MyVoice"));
                FloatingTextStringOnCreature("Has destruido la Voz Previa", oUser, FALSE);
            }
            if (GetIsObjectValid(oOther))
            {
                if (GetObjectSeen(oUser, oOther)!=TRUE)
                    {
                    FloatingTextStringOnCreature("Debes ser visible al objetivo para apuntar a una criatura con esta herramienta.", oUser);
                    return;
                    }

                SetListening(oOther, TRUE);
                SetListenPattern(oOther, "**", 20600);
                SetLocalInt(oOther, "hls_Listening", 1); //listen to all text
                SetLocalObject(oUser, "dmfi_VoiceTarget", oOther);

                FloatingTextStringOnCreature("Has apuntado a  " + GetName(oOther, TRUE) + " con la herramienta de Voz", oUser, FALSE);
                if(!GetIsObjectValid(GetItemPossessedBy(oOther, "dmfi_voicewidget"))) CreateItemOnObject("dmfi_voicewidget", oOther);

                if (GetLocalInt(GetModule(), "dmfi_voice_initial")!=1)
                    {
                    SetLocalInt(GetModule(), "dmfi_voice_initial", 1);
                    SendMessageToAllDMs("Escucha iniciada:  .commands, .skill checks, y mas disponibles.");
                    DelayCommand(4.0, FloatingTextStringOnCreature("Escucha iniciada:  .commands, .skill checks, and mas disponibles", oUser));
                    }

                object oArea = GetFirstObjectInArea(GetArea(oUser));
                while (GetIsObjectValid(oArea))
                {
                    if (GetObjectType(oArea) == OBJECT_TYPE_CREATURE &&
                    !GetIsDead(oArea) &&
                    GetLocalInt(oArea, "hls_Listening") &&
                    GetDistanceBetween(oUser, oArea) < 20.0f &&
                    oArea != GetLocalObject(oUser, "dmfi_MyVoice"))
                    {
                        DeleteLocalObject(oUser, "dmfi_MyVoice");
                        return;
                    }
                oArea = GetNextObjectInArea(GetArea(oUser));
                }
                //Create the Voice
                object oVoice = CreateObject(OBJECT_TYPE_CREATURE, "dmfi_voice", GetLocation(oUser));
                //Set Ownership of the Voice to the User
                AssignCommand(oVoice, ActionForceFollowObject(oUser, 3.0f));
                SetLocalObject(oUser, "dmfi_MyVoice", oVoice);
                return;
            }
            else
            {
                //Create the Voice
                oVoice = CreateObject(OBJECT_TYPE_CREATURE, "dmfi_voice", lLocation);
                AssignCommand(oVoice, ActionForceFollowObject(oUser, 3.0f));
                SetLocalObject(oUser, "dmfi_VoiceTarget", oVoice);
                //Set Ownership of the Voice to the User
                SetLocalObject(oUser, "dmfi_MyVoice", oVoice);
                DelayCommand(1.0f, FloatingTextStringOnCreature("La Voz esta operativa", oUser, FALSE));
                return;
            }
            return;
        }
        if (sItemTag == "dmfi_mute")
        {
            SetLocalObject(oUser, "dmfi_univ_target", oUser);
            SetLocalString(oUser, "dmfi_univ_conv", "voice");
            SetLocalInt(oUser, "dmfi_univ_int", 8);
            ExecuteScript("dmfi_execute", oUser);
            return;
        }
        if (sItemTag == "dmfi_target")
            {
            SetLocalObject(oUser, "dmfi_univ_target", oOther);
            FloatingTextStringOnCreature("DMFI Target set to " + GetName(oOther, TRUE),oUser);
        }
        if (sItemTag == "dmfi_afflict")
        {
        int nDNum;

        nDNum = GetLocalInt(oUser, "dmfi_damagemodifier");
        SetCustomToken(20780, IntToString(nDNum));
        }

        SetLocalObject(oUser, "dmfi_univ_target", oOther);
        SetLocalLocation(oUser, "dmfi_univ_location", lLocation);
        SetLocalString(oUser, "dmfi_univ_conv", GetStringRight(sItemTag, GetStringLength(sItemTag) - 5));
        AssignCommand(oUser, ClearAllActions());
        AssignCommand(oUser, ActionStartConversation(OBJECT_SELF, "dmfi_universal", TRUE, FALSE));
    }
}
