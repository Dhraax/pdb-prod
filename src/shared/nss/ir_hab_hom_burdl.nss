void main()
{
object oPC = GetPCSpeaker();
object oPuta = GetObjectByTag("gigolo_esmel_bg");
object oTarget = GetWaypointByTag("bg_p_hombre_entrada");
object oMod= GetModule();
DelayCommand(0.5, TakeGoldFromCreature(100, oPC));
DelayCommand(1.0, SetLocalInt(oMod, "ESTAR_CON_HOMBRE", 1));
DelayCommand(1.5, AssignCommand(oPC, JumpToObject(oTarget)));
DelayCommand(2.0, SetCommandable(FALSE, oPC));
DelayCommand(2.5, FloatingTextStringOnCreature("*Entras en la habitación y se cierra la puerta*", oPC));
DelayCommand(5.0, FloatingTextStringOnCreature("*El hombre te mira con cara de seducción y sonríe picarón*", oPC));
DelayCommand(10.0, FloatingTextStringOnCreature("*Se mete un dedo en la boca y muerde su uña, seductoramente*", oPC));
DelayCommand(15.0, FloatingTextStringOnCreature("*Te quita la ropa poco a poco*", oPC));
DelayCommand(16.0, SetCommandable(TRUE, oPC));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_BELT, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_NECK, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))));
DelayCommand(17.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC))));
DelayCommand(18.0, AssignCommand(oPC, FadeToBlack(oPC, FADE_SPEED_FASTEST)));
DelayCommand(19.0, AssignCommand(oPuta, SpeakString("*¡¡¡Uiiiiii, siiiiií, siiiiiiiiiiiiií, asiiiiiiii!!!*")));
DelayCommand(21.0, PlaySound("vs_fx2fighm_haha"));
DelayCommand(22.0, AssignCommand(oPuta, SpeakString("*¡¡¡Asiiiii siiiu uhhhhhh ahhhhhhh!!!*")));
DelayCommand(24.0, PlaySound("vs_fx2fighm_haha"));
DelayCommand(25.0, AssignCommand(oPuta, SpeakString("*¡¡¡Ahoraaa siiiiiií asiiiiiií!!!*")));
DelayCommand(27.0, PlaySound("vs_fx2fighm_haha"));
DelayCommand(28.0, FadeFromBlack(oPC, FADE_SPEED_FASTEST));
DelayCommand(30.0, PlaySound("vs_fx2fighm_haha"));
DelayCommand(31.0, AssignCommand(oPuta, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 2.0)));
DelayCommand(31.0, AssignCommand(oPuta, SpeakString("Ha estado bien *sonríe*, vuelve cuando quieras*")));
}

