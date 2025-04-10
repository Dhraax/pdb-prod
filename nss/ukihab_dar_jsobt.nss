void main()
{
SetCutsceneMode(GetPCSpeaker(),TRUE);

FadeToBlack(GetPCSpeaker(),FADE_SPEED_MEDIUM);
CreateItemOnObject("juegosucio", GetPCSpeaker(), 1);
GiveXPToCreature(GetPCSpeaker(),100);
DelayCommand(4.0,FadeFromBlack(GetPCSpeaker(),FADE_SPEED_MEDIUM));
DelayCommand(4.5,SetCutsceneMode(GetPCSpeaker(),FALSE));
}
