void main()
{
SetCutsceneMode(GetPCSpeaker(),TRUE);

FadeToBlack(GetPCSpeaker(),FADE_SPEED_MEDIUM);
CreateItemOnObject("animarlibro", GetPCSpeaker(), 1);
GiveXPToCreature(GetPCSpeaker(),300);
DelayCommand(4.0,FadeFromBlack(GetPCSpeaker(),FADE_SPEED_MEDIUM));
DelayCommand(4.5,SetCutsceneMode(GetPCSpeaker(),FALSE));
}
