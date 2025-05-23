// Execute the custom script attached assigned to the caller

void main()
{
    string sScript = GetLocalString(OBJECT_SELF, "Q_TrapScript");
    ExecuteScript(sScript, OBJECT_SELF);
}
