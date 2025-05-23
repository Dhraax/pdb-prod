void main()
{
  object oPC = GetPCSpeaker();
  object oPuta = GetObjectByTag("atk_bdiandra");
  object oTarget = GetNearestObjectByTag("atk_burdel1");
  object oMod = GetModule();

  TakeGoldFromCreature(100, oPC);
  SetLocalInt(oMod, "ATK_BURDELMUJER", 1);

  DelayCommand(0.5, AssignCommand(oPC, FadeToBlack(oPC, FADE_SPEED_FASTEST)));
  DelayCommand(2.0, FadeFromBlack(oPC, FADE_SPEED_FASTEST));

  DelayCommand(1.0, AssignCommand(oPC, ClearAllActions(TRUE)));
  DelayCommand(1.1, AssignCommand(oPC, JumpToObject(oTarget)));

  DelayCommand(1.5, SetCommandable(FALSE, oPC));
  DelayCommand(2.5, FloatingTextStringOnCreature("*Entras en la habitación y se cierra la puerta*", oPC, FALSE));
  DelayCommand(5.0, FloatingTextStringOnCreature("*La mujer te mira con cara de seducción y sonríe picarona*", oPC, FALSE));
  DelayCommand(10.0, FloatingTextStringOnCreature("*Se mete un dedo en la boca y muerde su uña, seductoramente*", oPC, FALSE));
  DelayCommand(15.0, FloatingTextStringOnCreature("*Te quita la ropa poco a poco*", oPC, FALSE));
  DelayCommand(15.5, SetCommandable(TRUE,oPC));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_BELT, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_NECK, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))));
  DelayCommand(16.0, AssignCommand(oPC, ActionUnequipItem(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC))));
  DelayCommand(18.0, AssignCommand(oPC, FadeToBlack(oPC, FADE_SPEED_FASTEST)));
  DelayCommand(19.0, AssignCommand(oPuta, SpeakString("¡Uiiiiii, siiiiií, siiiiiiiiiiiiií, asiiiiiiii!")));
  DelayCommand(21.0, AssignCommand(oPC, PlaySound("vs_fseductf_haha")));
  DelayCommand(22.0, AssignCommand(oPuta, SpeakString("¡Asiiiii siiiu uhhhhhh ahhhhhhh!")));
  DelayCommand(24.0, AssignCommand(oPC, PlaySound("vs_fseductf_haha")));
  DelayCommand(25.0, AssignCommand(oPuta, SpeakString("¡Ahoraaa siiiiiií asiiiiiií!")));
  DelayCommand(27.0, AssignCommand(oPC, PlaySound("vs_fseductf_haha")));
  DelayCommand(30.0, FadeFromBlack(oPC, FADE_SPEED_FASTEST));
  DelayCommand(32.0, AssignCommand(oPC, PlaySound("vs_fseductf_haha")));
  DelayCommand(33.0, AssignCommand(oPuta, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 2.0)));
  DelayCommand(34.0, AssignCommand(oPuta, SpeakString("Ha estado bien *sonríe*, vuelve cuando quieras.")));
}
