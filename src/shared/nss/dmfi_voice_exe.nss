//DMFI Voice script

 void dmw_CleanUp(object oMySpeaker)
{
   int nCount;
   int nCache;
   //DeleteLocalObject(oMySpeaker, "dmfi_univ_target");
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
    int nMatch = GetListenPatternNumber();
    object oShouter = GetLastSpeaker();
    if (GetIsDM(oShouter))
        SetLocalInt(GetModule(), "dmfi_Admin" + GetPCPublicCDKey(oShouter), 1);

    if (GetIsDMPossessed(oShouter))
        SetLocalObject(GetMaster(oShouter), "dmfi_familiar", oShouter);

    object oIntruder;
    object oTarget = GetLocalObject(oShouter, "dmfi_VoiceTarget");
    object oMaster = OBJECT_INVALID;
    if (GetIsObjectValid(oTarget))
        oMaster = oShouter;

    int iPhrase = GetLocalInt(oShouter, "hls_EditPhrase");

    object oSummon;

    if (nMatch == 20600 && GetIsObjectValid(oShouter) && GetIsDM(oShouter))
    {
    string sSaid = GetMatchedSubstring(0);

    if (GetTag(OBJECT_SELF) == "dmfi_setting" && GetLocalString(oShouter, "EffectSetting") != "")
        {
            string sPhrase = GetLocalString(oShouter, "EffectSetting");
            SetLocalFloat(oShouter, sPhrase, StringToFloat(sSaid));
            SetCampaignFloat("dmfi", sPhrase, StringToFloat(sSaid), oShouter);
            DeleteLocalString(oShouter, "EffectSetting");
            DelayCommand(0.5, ActionSpeakString("The setting " + sPhrase + " ha sido cambiado a " + FloatToString(GetLocalFloat(oShouter, sPhrase))));
            DelayCommand(1.5, DestroyObject(OBJECT_SELF));
            //maybe add a return here
        }
    }

    if (nMatch == 20600 && GetIsObjectValid(oShouter) && GetIsPC(oShouter))
    {
        string sSaid = GetMatchedSubstring(0);

        if (sSaid != GetLocalString(GetModule(), "hls_voicebuffer"))
            SetLocalString(GetModule(), "hls_voicebuffer", sSaid);
        else
            {
            return;
            }
        // DM spy code right at the top - this basically will send the DM what has been spoken anywhere
        if (GetCampaignInt("dmfi", "dmfi_DMSpy"))
            {
                object oTempPC = GetFirstPC();
                while(GetIsObjectValid(oTempPC))
                {
                    if (GetIsDM(oTempPC))
                    {
                        if (GetCampaignInt("dmfi", "dmfi_DMSpy", oTempPC))
                        {
                        if (GetIsPC(GetLocalObject(oTempPC, "dmfi_familiar")))
                            SendMessageToPC(GetLocalObject(oTempPC, "dmfi_familiar"), "(" + GetName(GetArea(oShouter)) + ") " + GetName(oShouter) + ": " + sSaid);
                        else
                            SendMessageToPC(oTempPC, "(" + GetName(GetArea(oShouter)) + ") " + GetName(oShouter) + ": " + sSaid);
                        }
                    }
                oTempPC = GetNextPC();
                }
            }

        PrintString("<Conv>"+GetName(GetArea(oShouter))+ " " + GetName(oShouter) + ": " + sSaid + " </Conv>");
        //if the phrase begins with .MyName, reparse the string as a voice throw
        if (GetStringLeft(sSaid, GetStringLength("." + GetName(OBJECT_SELF))) == "." + GetName(OBJECT_SELF) &&
            (GetLocalInt(GetModule(), "dmfi_Admin" + GetPCPublicCDKey(oShouter)) ||
             GetIsDM(oShouter) || GetIsDMPossessed(oShouter)))

        {
            oTarget = OBJECT_SELF;
            sSaid = GetStringRight(sSaid, GetStringLength(sSaid) - GetStringLength("." + GetName(OBJECT_SELF)));
            if (GetStringLeft(sSaid, 1) == " ") sSaid = GetStringRight(sSaid, GetStringLength(sSaid) - 1);
            sSaid = ":" + sSaid;
            return;
        }

        if (iPhrase)
        {
            SetCustomToken(iPhrase, sSaid);
            SetCampaignString("dmfi", "hls" + IntToString(iPhrase), sSaid);
            DeleteLocalInt(oShouter, "hls_EditPhrase");
            FloatingTextStringOnCreature("Frase " + IntToString(iPhrase) + " ha sido grabada", oShouter, FALSE);

            return;
        }

        if (GetIsObjectValid(GetLocalObject(GetModule(), "hls_NPCControl" + GetStringLeft(sSaid, 1))) && GetLocalInt(GetModule(), "dmfi_Admin" + GetPCPublicCDKey(oShouter)))
        {
            object oControl = GetLocalObject(GetModule(), "hls_NPCControl" + GetStringLeft(sSaid, 1));
            sSaid = GetStringRight(sSaid, GetStringLength(sSaid)-1);

            //This "throws" your voice to an object and properly dumps it into the log
            AssignCommand(oControl, SpeakString(sSaid));
            PrintString("<Conv>"+GetName(GetArea(oControl))+ " " + GetName(oControl) + ": " + sSaid + " </Conv>");
            return;
        }
    }
}
