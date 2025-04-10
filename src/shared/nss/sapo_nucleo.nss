//SAPO-PB
//Sistema de Atesenaias, Profesiones y Oficios - Puerta de Baldur.
//Sistema Generico de profesion - Puerta de Baldur
//Script generico que permite implementar profesiones que se basen en los tres siguientes eventos
//1.- Usar un objeto sobre otro
//2.- Atacar un objeto
//3.- Cerrar un contenedor.

#include "NW_I0_GENERIC"
#include "nw_i0_2q4luskan"
#include "sapo_constantes"
#include "sapo_func_receta"
#include "mti_libreria"

//Prototipos
void Fabricar(object oPJ, object oProcesado);
int ComprobarRequisitos(object oPJ, object oProcesado, int iHabilidad, int iProfesion);
int ComprobarRequisito(int iTipo, object oPJ, object oProcesado, int iRequisitosTodos, string sVariable, int iTipoVariable, string MensajeNoCumple);
int Compara(int iTipo, int iElemento, string sVariable, object oPJ, object oProcesado);
int GastarHerramientasEnPJ(object oPJ, object oProcesado);
int GastoPorUsoHerramienta(object oHerramienta, object oProcesado, object oPJ);
int GastoPorUsoProcesado(object oProcesado, object oPJ);
int GastoPorUso(object oObjeto, object oPJ, int iDano);
int ObjetoEquipado(string sResRef, object oPJ);
object DevuelveObjetoEquipado(string sResRef, object oPJ);
int ComprobarExito(object oPJ, object oProcesado, int iHabilidad);
float PorcentajeExito(object oPJ, object oProcesado, int iHabilidad);
void ProcesarExito(object oPJ, object oProcesado, int iHabilidad);
void ProcesarFracaso(object oPJ, object oProcesado);
void ConsumeRequisitos(int iTipo, object oPJ, object oProcesado, int iRequisitosTodos, string sVariable, int iTipoVariable);
void ConsumeRequisito(int iTipo, int iElemento, object oPJ);
int GetCharacterLevel(object oCriatura);
int ContinuarBucleRequisitos(int iElemento, string sVariable, int iTipoVariable, object oProcesado);
void AnimacionPJ(object oPJ, object oProcesado);
void AnimacionProcesado(object oPJ, object oProcesado);
int SufirLesion(object oPJ, object oProcesado);
effect EfectoEspecialLesion(int iEfectoEspecial, int iEfectoNivel, int iEfectoTipoDuracion, float iEfectoDuracion);
void EfectoEspecialPropio(int iEfecto, object oUbicado, object oPJ, int iNumLesion, int iSubNumLesion);
int AccesoFormula(int iHabilidad, object oPJ);
int BonoRacial(object oPJ, object oProcesado);
int BonoAtributo(object oPJ, object oProcesado);
void CrearObjeto(object oPJ, object oProcesado, string sObjetoCrear, string sRecetaCrear, string sContenedorCrear, int iVentaOro, int iHabilidad, int iRenombrable);
int ComprobarAprendizaje(object oPJ, object oProcesdo, int iHabilidad, int iProfesion);
void ProcesarAprendizaje(object oPJ, int iHabilidad, int iProfesion);
float PorcentajeAprendizaje(object oPJ, object oProcesado, int iHabilidad);
int GastarHerramientasEnInventario(object oPJ, object oProcesado);
void MensajeNoCumpleRequisito(int iTipo, object oPJ, object oProcesado, int iElemento, string sVariable);
void AnimacionExito(object oPJ, object oProcesado);
void AnimacionFracaso(object oPJ, object oProcesado);
int ObjetoEsCreable(object oProcesado, object oPJ);

//-------------------FUNCION PRINCIPAL
void Fabricar(object oPJ, object oProcesado) {

//Cargar Variables iniciales



    //SEMAFORO
    if(GetLocalInt(oProcesado,"Semaforo") == 1) {

        return;
    }
    SetLocalInt(oProcesado, "Semaforo", 1);
    DelayCommand(3.0, DeleteLocalInt(oProcesado, "Semaforo"));

    int iProfesion = GetLocalInt(oProcesado,"Profesion");

    if (iProfesion==0) return;

    //recoger habilidad siguiendo el sistema varita de monti, descomentar cuando se haga
    int iHabilidad =ObtenerIntPersistente(oPJ, "Profesion" + IntToString(iProfesion));
    //int iHabilidad = GetLocalInt(oPJ, "Profesion" + IntToString(iProfesion));


//  Requisito tener como minimo un punto de habildiad
    if (iHabilidad==0) {
        SendMessageToPC(oPJ, "*Quizás debería hablar con algún maestro " + NombreMaestro(iProfesion) + " antes de nada*");
        return;
    }

    int iPreservarSiFracaso=GetLocalInt(oProcesado,"PreservarSiFracaso");

//Comprobar si la formula puede crear algun objeto
    if(ObjetoEsCreable(oProcesado, oPJ)==FALSE) {
        SendMessageToPC(oPJ,"*En teoria estos materiales deberian fabricar algo pero nadie sabe aun como... tal ven en el futuro...*");
        return;
    }

//Aplicar daño a las herramientas
    if (GastarHerramientasEnPJ(oPJ, oProcesado) == TRUE) return;
    if (GastarHerramientasEnInventario(oPJ, oProcesado) == TRUE) return;

//Animacion PJ
    AnimacionPJ(oPJ, oProcesado);

//Animacion Procesado
    AnimacionProcesado(oPJ, oProcesado);

//Comprobar requisitos
    if (ComprobarRequisitos(oPJ, oProcesado, iHabilidad, iProfesion)==FALSE) return;

//Comprobar Lesion
    if (SufirLesion(oPJ, oProcesado)==TRUE) {
        if (iPreservarSiFracaso!=1) BorrarInventario(oProcesado);
        return;
    }

//Comprobar Acceso
    if (AccesoFormula(iHabilidad, oPJ)!=TRUE) {
        SendMessageToPC(oPJ,"*Algun problema fortuito ha echado a perder el proceso*");
        ProcesarFracaso(oPJ, oProcesado);
        return;
    }

//Comprobar exito
    if (ComprobarExito(oPJ, oProcesado, iHabilidad)==TRUE) {
        ProcesarExito(oPJ, oProcesado, iHabilidad);
        if (ComprobarAprendizaje(oPJ, oProcesado, iHabilidad, iProfesion)==TRUE)  {
            ProcesarAprendizaje(oPJ, iHabilidad, iProfesion);
        }
    } else {
        ProcesarFracaso(oPJ, oProcesado);
    }

//Aplicar daño al objeto procesado
    GastoPorUsoProcesado(oProcesado, oPJ);

//Una vez fabricado limpiamos las variables locales de la mesa de procesado que se hayan podido utilizar
    DeleteLocalInt(oProcesado,"NivelPJMinimo");
    DeleteLocalInt(oProcesado,"OroGastar");
    DeleteLocalInt(oProcesado,"XpGastar");
    DeleteLocalObject(oProcesado, "ObjetoCreado");
    DeleteLocalInt(oProcesado,"NivelPJMinimo");
    DeleteLocalInt(oProcesado,"OROVENTA");
    DeleteLocalInt(oProcesado,"Dificultad");
    DeleteLocalString(oProcesado,"RecetaCrear");

    int x;
    for (x=0; x < 10; x++) {
              DeleteLocalInt(oProcesado,"Habilidad" + IntToString(x));
              DeleteLocalInt(oProcesado,"HabilidadRango" + IntToString(x));
              DeleteLocalInt(oProcesado,"Talento" + IntToString(x));
              DeleteLocalInt(oProcesado,"Clase" + IntToString(x));
              DeleteLocalInt(oProcesado,"ClaseRango" + IntToString(x));
              DeleteLocalInt(oProcesado,"BonoAtributo" + IntToString(x));
              DeleteLocalInt(oProcesado,"BonoRacial" + IntToString(x));
              DeleteLocalString(oProcesado,"BonoRacial" + IntToString(x));
    }
////////////////////////////////////////////


}





//-------------------COMPRUEBA TODOS LOS REQUISITOS PARA LAS FORMULAS
int ComprobarRequisitos(object oPJ, object oProcesado, int iHabilidad, int iProfesion) {

//Requisito nivel PJ
    int iNivelPJ=GetCharacterLevel(oPJ);
    int iNivelPJMinimo=GetLocalInt(oProcesado,"NivelPJMinimo");
    if (iNivelPJ<iNivelPJMinimo) {
                SendMessageToPC(oPJ, "*No tienes la experiencia suficiente.*");
                return FALSE;
        }

//Requisito Oro
    int iOroPJ=GetGold(oPJ);
    int iOroGastar=GetLocalInt(oProcesado,"OroGastar");
    if (iOroPJ<iOroGastar) {
        SendMessageToPC(oPJ, "*No tienes suficente oro.*");
        return FALSE;
        }

//Requisito XP
    int iXpPJ=GetXP(oPJ);
    int iXpGastar=GetLocalInt(oProcesado,"XpGastar");
    if (iXpPJ<iXpGastar) {
        SendMessageToPC(oPJ, "*No tienes suficente experiencia que gastar.*");
        return FALSE;
    }

//  Bucle requisitos herramienta

    if (ComprobarRequisito(TIPO_HERRAMIENTA, oPJ, oProcesado, GetLocalInt(oProcesado,"HerramientasTodo"), "Herramienta", TIPOVAR_STR, "*No tienes la herramienta adecuada.*")==FALSE) return FALSE;
//  Bucle requisitos Raza (cumplir al menos una)

    if (ComprobarRequisito(TIPO_RAZA, oPJ, oProcesado, FALSE, "Raza", TIPOVAR_INT, "*Tu raza no sabe como manejar esto.*")==FALSE) return FALSE;
//  Bucle requisitos talento

    if (ComprobarRequisito(TIPO_TALENTO, oPJ, oProcesado, GetLocalInt(oProcesado,"TalentosTodo"), "Talento", TIPOVAR_INT, "*No tienes el talento para manejar esto.*")==FALSE) return FALSE;
//  Bucle requisitos habilidades

    if (ComprobarRequisito(TIPO_HABILIDAD, oPJ, oProcesado, GetLocalInt(oProcesado,"HabilidadesTodo"), "Habilidad", TIPOVAR_INT, "*No tienes la habilidad para manejar esto.*")==FALSE) return FALSE;
//  Bucle requisitos Clases

    if (ComprobarRequisito(TIPO_CLASE, oPJ, oProcesado, GetLocalInt(oProcesado,"ClasesTodo"), "Clase", TIPOVAR_INT, "*No tienes la experiencia suficiente en una clase.*")==FALSE) return FALSE;
//  Bucle requisitos conjuros

    if (ComprobarRequisito(TIPO_CONJURO, oPJ, oProcesado, GetLocalInt(oProcesado,"ConjurosTodo"), "Conjuro", TIPOVAR_INT, "*No tienes aprendido un conjuro necesario.*")==FALSE) return FALSE;

    return TRUE;

}




//-------------------COMPRUEBA UN REQUISITO EN PARTICULAR DE TIPO BUCLE (VARIOS POSIBLES REQUISITOS DE UN TIPO EN PARTICULAR).
int ComprobarRequisito(int iTipo, object oPJ, object oProcesado, int iRequisitosTodos, string sVariable, int iTipoVariable, string MensajeNoCumple) {



    int iElemento=1;
    int iCumpleRequisito=TRUE;
    int iCumple;
    while(ContinuarBucleRequisitos(iElemento, sVariable, iTipoVariable, oProcesado)) {
        iCumple=Compara(iTipo, iElemento, sVariable, oPJ, oProcesado);
        if (iCumple) {
            iCumpleRequisito=TRUE;
            if (iRequisitosTodos==FALSE) break;
        } else {
            iCumpleRequisito=FALSE;
            if (iRequisitosTodos==TRUE) break;
        }
        iElemento++;
    };

    if(iCumpleRequisito==FALSE)     {
        if (iRequisitosTodos==TRUE)
            MensajeNoCumpleRequisito(iTipo, oPJ, oProcesado, iElemento, sVariable);
        else
            MensajeNoCumpleRequisito(iTipo, oPJ, oProcesado, 1, sVariable);

        return FALSE;
    } else {

        return TRUE;
    }

}

void MensajeNoCumpleRequisito(int iTipo, object oPJ, object oProcesado, int iElemento, string sVariable) {



    int iNoDarPistas=GetLocalInt(oProcesado,"NoDarPistas");
    if (iNoDarPistas==1) {
        SendMessageToPC(oPJ,"*Te falta algo... pero no sabes muy bien que es*");

        return;
    }

    int iRequisito;
    int iRango;
    string sRequisito;
    string sStrRef;
    int iStrRef;
    string sNombre;
    string sMensaje;

    switch (iTipo) {
    case TIPO_RAZA:
        iRequisito=GetLocalInt(oProcesado, sVariable + IntToString(iElemento));
        if (iRequisito==CONST_ESPECIAL_RAZA_ENANO)
            iRequisito=RACIAL_TYPE_DWARF;
        iRango=GetLocalInt(oProcesado, sVariable + "Rango" + IntToString(iElemento));
        sStrRef=Get2DAString("racialtypes","Name",iRequisito);
        iStrRef=StringToInt(sStrRef);
        sNombre=GetStringByStrRef(iStrRef);
        sMensaje="*Tu raza no sabe como hacer esto*";
        break;
    case TIPO_TALENTO:
        iRequisito=GetLocalInt(oProcesado, sVariable + IntToString(iElemento));
        if (iRequisito==CONST_ESPECIAL_TALENTO_ALERTA)
            iRequisito=FEAT_ALERTNESS;
        iRango=GetLocalInt(oProcesado, sVariable + "Rango" + IntToString(iElemento));
        sStrRef=Get2DAString("feat","FEAT",iRequisito);
        iStrRef=StringToInt(sStrRef);
        sNombre=GetStringByStrRef(iStrRef);
        sMensaje="*Necesitas algun talento. Tal vez " + sNombre + "... Pero puede que haya otros talentos que tambien sirvan.*";
        break;
    case TIPO_HABILIDAD:
        iRequisito=GetLocalInt(oProcesado, sVariable + IntToString(iElemento));
        if (iRequisito==CONST_ESPECIAL_HABILIDAD_EMPATIA_ANIMAL)
            iRequisito=SKILL_ANIMAL_EMPATHY;
        iRango=GetLocalInt(oProcesado, sVariable + "Rango" + IntToString(iElemento));
        sStrRef=Get2DAString("skills","Name",iRequisito);
        iStrRef=StringToInt(sStrRef);
        sNombre=GetStringByStrRef(iStrRef);
        sMensaje="*Deberias estudiar un poco mas. Tal vez estudiando la habilidad " + sNombre + "... Pero puede que haya otras habilidades que tambien sirvan.*";
        break;
    case TIPO_CLASE:
        iRequisito=GetLocalInt(oProcesado, sVariable + IntToString(iElemento));
        if (iRequisito==CONST_ESPECIAL_CLASE_BARBARO)
            iRequisito=CLASS_TYPE_BARBARIAN;
        iRango=GetLocalInt(oProcesado, sVariable + "Rango" + IntToString(iElemento));
        sStrRef=Get2DAString("classes","Name",iRequisito);
        iStrRef=StringToInt(sStrRef);
        sNombre=GetStringByStrRef(iStrRef);
        sMensaje="*Esto es solo para algunas clases. Tal vez " + sNombre + "... Pero puede que haya otras clases que tambien sirvan.*";
        break;
    case TIPO_CONJURO:
        iRequisito=GetLocalInt(oProcesado, sVariable + IntToString(iElemento));
        if (iRequisito==CONST_ESPECIAL_CONJURO_NIEBLA_ACIDA)
            iRequisito=SPELL_ACID_FOG;
        sStrRef=Get2DAString("Spells","Name",iRequisito);
        iStrRef=StringToInt(sStrRef);
        sNombre=GetStringByStrRef(iStrRef);
        sMensaje="*Deberias aprender algun conjuro. Tal vez " + sNombre + "... Pero puede que haya otros conjuros que tambien sirvan.*";
        break;
    case TIPO_HERRAMIENTA:
        sMensaje="*Necesitas una herramienta*";
        break;
    }




    SendMessageToPC(oPJ, sMensaje);



}

//-------------------COMPARA SI EL PJ TIENE UN REQUISITO EN PARTICULAR SEGUN EL TIPO
int Compara(int iTipo, int iElemento, string sVariable, object oPJ, object oProcesado) {

    int iRequisito;
    int iRango;
    string sRequisito;



    switch (iTipo) {
    case TIPO_RAZA:
        iRequisito=GetLocalInt(oProcesado, sVariable + IntToString(iElemento));
        if (iRequisito==CONST_ESPECIAL_RAZA_ENANO)
            iRequisito=RACIAL_TYPE_DWARF;
        return (iRequisito==GetRacialType(oPJ));
    case TIPO_TALENTO:
        iRequisito=GetLocalInt(oProcesado, sVariable + IntToString(iElemento));
        if (iRequisito==CONST_ESPECIAL_TALENTO_ALERTA)
            iRequisito=FEAT_ALERTNESS;
        return GetHasFeat(iRequisito, oPJ);
    case TIPO_HABILIDAD:
        iRequisito=GetLocalInt(oProcesado, sVariable + IntToString(iElemento));
        if (iRequisito==CONST_ESPECIAL_HABILIDAD_EMPATIA_ANIMAL)
            iRequisito=SKILL_ANIMAL_EMPATHY;
        iRango=GetLocalInt(oProcesado, sVariable + "Rango" + IntToString(iElemento));
        return (GetSkillRank(iRequisito, oPJ, TRUE)>=iRango);
    case TIPO_CLASE:
        iRequisito=GetLocalInt(oProcesado, sVariable + IntToString(iElemento));
        if (iRequisito==CONST_ESPECIAL_CLASE_BARBARO)
            iRequisito=CLASS_TYPE_BARBARIAN;
        iRango=GetLocalInt(oProcesado, sVariable + "Rango" + IntToString(iElemento));

        return (GetLevelByClass(iRequisito, oPJ)>=iRango);
    case TIPO_CONJURO:
        iRequisito=GetLocalInt(oProcesado, sVariable + IntToString(iElemento));
        if (iRequisito==CONST_ESPECIAL_CONJURO_NIEBLA_ACIDA)
            iRequisito=SPELL_ACID_FOG;
        return GetHasSpell(iRequisito, oPJ);
    case TIPO_HERRAMIENTA:
        sRequisito=GetLocalString(oProcesado, sVariable + IntToString(iElemento));
        object oObjeto = ObjetoEnInventario(oPJ, sRequisito);

        if (oObjeto==OBJECT_INVALID) return ObjetoEquipado(sRequisito, oPJ);;
        if (ObjetoEquipable(oObjeto)==TRUE)
            return ObjetoEquipado(sRequisito, oPJ);
        else
            return TRUE;
    }
    return FALSE;

}




//-------------------FUNCION DE CONTROL PARA VER SI AUN QUEDAN REQUISITOS POR COMPROBAR
int ContinuarBucleRequisitos(int iElemento, string sVariable, int iTipoVariable, object oProcesado) {


    switch (iTipoVariable) {
    case TIPOVAR_INT:
        return (GetLocalInt(oProcesado, sVariable + IntToString(iElemento)) != 0);
    case TIPOVAR_STR:
        return (GetLocalString(oProcesado, sVariable + IntToString(iElemento)) != "");
    }
    return FALSE;

}




//-------------------GASTA TODAS LAS HERRAMIENTAS USADAS
//-------------------SI NO SE REQUIEREN TODAS GASTA LA PRIMERA QUE ENCUENTRA
//-------------------DEVUELVE TRUE SI ALGUNA SE ROMPE
int GastarHerramientasEnPJ(object oPJ, object oProcesado) {



    int x=1;
    int iRetorno = FALSE;
    object oHerramienta;
    int iRequisitosTodos=GetLocalInt(oProcesado,"HerramientasTodo");
    string sResRef=GetLocalString(oProcesado, "Herramienta" + IntToString(x));


    while(sResRef!="") {
        oHerramienta = ObjetoEnInventario(oPJ, sResRef);
        if (oHerramienta==OBJECT_INVALID || ObjetoEquipable(oHerramienta)==TRUE)
            oHerramienta=DevuelveObjetoEquipado(sResRef, oPJ);
        if (oHerramienta!=OBJECT_INVALID) {
            //hay un problema con las herramientas que hace que al ser vendidas en tienda
            //se pierdan las variables internas, asi que inicializamos valores
            if (sResRef=="sapo_herr_aguja")
            {    string sIDM=GetLocalString(oHerramienta, "InicializaDañoMaximo");
                 if (sIDM=="")
                 {SetLocalString(oHerramienta,"InicializaDañoMaximo","20+d6()");
                 }
            }
            if (sResRef=="sapo_herr_esenci")
            {    string sIDM=GetLocalString(oHerramienta, "InicializaDañoMaximo");
                 if (sIDM=="")
                 {SetLocalString(oHerramienta,"InicializaDañoMaximo","20+d6()");
                 }
            }

            ///////////////////

            iRetorno=GastoPorUsoHerramienta(oHerramienta, oProcesado, oPJ) || iRetorno;
            if (iRetorno==TRUE)     DelayCommand(0.5, AssignCommand(oPJ,ClearAllActions(TRUE)));
            if (iRequisitosTodos==FALSE) {

                return iRetorno;
            }
        }
        x=x+1;
        sResRef=GetLocalString(oProcesado, "Herramienta" + IntToString(x));
    };


    return iRetorno;

}

//-------------------GASTA TODAS LAS HERRAMIENTAS USADAS
//-------------------DEVUELVE TRUE SI ALGUNA SE ROMPE
int GastarHerramientasEnInventario(object oPJ, object oProcesado) {


    if(GetHasInventory(oProcesado)==FALSE) {

        return FALSE;
    }
    int iRetorno;
    int x=1;
    object oHerramienta;

    oHerramienta=GetFirstItemInInventory(oProcesado);
    while(oHerramienta!=OBJECT_INVALID) {
    //hay un problema con perdida de variables internas en las herramientas
        //al ser vendido por comerciante, por si acaso se inicializan
        string sTag=GetTag(oHerramienta);
        string sRes=GetResRef(oHerramienta);
        if (sTag=="sapo_kitcuero"||sRes=="sapo_kitcuero")
        {  if (GetLocalInt(oHerramienta,"Herramienta")!=1)
           {  SetLocalInt(oHerramienta,"Herramienta",1);
           }
           string sIDM=GetLocalString(oHerramienta, "InicializaDañoMaximo");
           if (sIDM=="")
                 {SetLocalString(oHerramienta,"InicializaDañoMaximo","20+d6()");
                 }
        }
        if (sTag=="sapo_ing_tanino"||sRes=="sapo_ing_tanino")
        {  if (GetLocalInt(oHerramienta,"Herramienta")!=1)
           {  SetLocalInt(oHerramienta,"Herramienta",1);}
           string sIDM=GetLocalString(oHerramienta, "InicializaDañoMaximo");
           if (sIDM=="")
              {SetLocalString(oHerramienta,"InicializaDañoMaximo","10+d6()");
              }

        }
        if (sTag=="sapo_ing_sal"||sRes=="sapo_ing_sal")
        {  if (GetLocalInt(oHerramienta,"Herramienta")!=1)
           {  SetLocalInt(oHerramienta,"Herramienta",1);}
           string sIDM=GetLocalString(oHerramienta, "InicializaDañoMaximo");
           if (sIDM=="")
                 {SetLocalString(oHerramienta,"InicializaDañoMaximo","50+d6()");
                 }

        }
        if (sTag=="sapo_ing_cera"||sRes=="sapo_ing_cera")
        {  if (GetLocalInt(oHerramienta,"Herramienta")!=1)
           {  SetLocalInt(oHerramienta,"Herramienta",1);}
           string sIDM=GetLocalString(oHerramienta, "InicializaDañoMaximo");
           if (sIDM=="")
                 {SetLocalString(oHerramienta,"InicializaDañoMaximo","20+d6()");
                 }

        }
        ///////////////////////
        if (GetLocalInt(oHerramienta,"Herramienta")==TRUE) {

            iRetorno=GastoPorUsoHerramienta(oHerramienta, oProcesado, oPJ) || iRetorno;
            if (iRetorno==TRUE)     DelayCommand(0.5, AssignCommand(oPJ,ClearAllActions(TRUE)));
        }
        oHerramienta=GetNextItemInInventory(oProcesado);
    };


    return iRetorno;

}

//-------------------GASTA UNA HERRAMIENTA EN PARTICULAR
int GastoPorUsoHerramienta(object oHerramienta, object oProcesado, object oPJ) {
//Gasta objeto sobre el que se hace la profesion



    string sDanoPorUso=GetLocalString(oProcesado,"DañoHerramientaPorUso");
    int iDano=DevolverValorSegunDado(sDanoPorUso);



    int iHerramientaDestruida=GastoPorUso(oHerramienta, oPJ, iDano);

    return iHerramientaDestruida;

}

//-------------------GASTA UNA OBJETO PROCESADO EN PARTICULAR
int GastoPorUsoProcesado(object oProcesado, object oPJ) {
//Gasta objeto sobre el que se hace la profesion



    string sDanoPorUso=GetLocalString(oProcesado,"DañoPorUso");
    int iDano=DevolverValorSegunDado(sDanoPorUso);


    location lPosicion=GetLocation(oProcesado);

    int iProcesadoDestruido=GastoPorUso(oProcesado, oPJ, iDano);

    if (iProcesadoDestruido==TRUE) {
        string sObjetoSustituto=GetLocalString(oProcesado,"ObjetoSustitutoSiConsumido");
        int iPorcentajeCreacion=GetLocalInt(oProcesado,"PorcentajeCreacionObjetoSustituto");
        if (iPorcentajeCreacion==0 || iPorcentajeCreacion>d100()) {
                CreateObject(OBJECT_TYPE_PLACEABLE,sObjetoSustituto,lPosicion,FALSE);
        }
    }


    return iProcesadoDestruido;

}

//-------------------GASTA UNA OBJETO
int GastoPorUso(object oObjeto, object oPJ, int iDano) {
//Gasta objeto sobre el que se hace la profesion



    if (iDano==0) {

        return FALSE;
    }

    int iDanoActual=GetLocalInt(oObjeto,"DañoActual");
    int iDanoMaximo=GetLocalInt(oObjeto,"DañoMaximo");
    string sInicializaDanoMaximo=GetLocalString(oObjeto, "InicializaDañoMaximo");

    if (iDanoMaximo==0 && sInicializaDanoMaximo=="") {


        return FALSE;
    }

    if (iDanoMaximo==0 && sInicializaDanoMaximo!="") {

        iDanoMaximo=DevolverValorSegunDado(sInicializaDanoMaximo);
        SetLocalInt(oObjeto,"DañoMaximo",iDanoMaximo);
    }






    int iDestruido=FALSE;
    if (iDanoActual + iDano >= iDanoMaximo) {

        string sNomObjeto=GetName(oObjeto);
        DelayCommand(1.5, FloatingTextStringOnCreature("*¡" + sNomObjeto + " termina por gastarse de tanto uso!*", oPJ));
        DestroyObject(oObjeto);
        iDestruido=TRUE;
    } else {

        SetLocalInt(oObjeto,"DañoActual",iDanoActual+iDano);
    }
    //marca para avisar de gasto
    if ( (iDanoActual + (3 * iDano) >= iDanoMaximo) &&
         iDestruido==FALSE
       )
    {
      string sNomObjeto=GetName(oObjeto);
      DelayCommand(1.5, FloatingTextStringOnCreature("*¡" + sNomObjeto + " esta a punto de agotarse!*", oPJ));
    }

    //

    return iDestruido;
}

//-------------------DEVUELVE SI UN OBJETO QUE COINCIDE CON EL RESREF ESTA EQUIPADO EN CUALQUIER SLOT
int ObjetoEquipado(string sResRef, object oPJ) {

    return (DevuelveObjetoEquipado(sResRef, oPJ)!=OBJECT_INVALID);

}

//-------------------DEVUELVE EL OBJETO EQUIPADO QUE COINCIDE CON EL RESREF
object DevuelveObjetoEquipado(string sResRef, object oPJ) {

    object oObjeto;
    int x;
    for (x=0; x < NUM_INVENTORY_SLOTS; x++) {
        oObjeto=GetItemInSlot(x,oPJ);
        if (oObjeto!=OBJECT_INVALID) {

            if (GetResRef(oObjeto)==sResRef) return oObjeto;
            if (GetTag(oObjeto)==sResRef) return oObjeto;
        }
    }
    return OBJECT_INVALID;

}

//-------------------COMPRUEBA SI HA TENIDO EXITO
int ComprobarExito(object oPJ, object oProcesado, int iHabilidad) {


    float fExito=PorcentajeExito(oPJ, oProcesado, iHabilidad);
    //Sumamos artesania al porcentaje de la tirada para tener mas exito
    fExito=fExito + IntToFloat(GetSkillRank(22,oPJ));
    float fTirada=IntToFloat(d100());

    if (fTirada > fExito) {

        return FALSE;
    } else {

        return TRUE;
    }


}

//-------------------COMPRUEBA SI APRENDE
int ComprobarAprendizaje(object oPJ, object oProcesado, int iHabilidad, int iProfesion) {



    int iNivelMaximoProfesion=DevolverNivelMaximoProfesion(iProfesion);
    if (iHabilidad>=iNivelMaximoProfesion) {


        return FALSE;
    };

    float fAprendizaje=PorcentajeAprendizaje(oPJ, oProcesado, iHabilidad);
    float fTirada=IntToFloat(d100());



    if (fTirada > fAprendizaje) {

        return FALSE;
    } else {

        return TRUE;
    }


}

//-------------------DEVUELVE EL PORCENTAJE DE EXITO
float PorcentajeExito(object oPJ, object oProcesado, int iHabilidad) {



    int iDificultad=GetLocalInt(oProcesado,"Dificultad");
    int iBonoRacial = BonoRacial(oPJ, oProcesado);
    int iBonoAtributo = BonoAtributo(oPJ, oProcesado);
    //
    //int iPenalizador = ObtenerPenalizadorHabilidadTotal(oPJ);
    //SendMessageToPC(oPJ,"kk:"+IntToString(iPenalizador));
    //if (iPenalizador<0) SendMessageToPC(oPJ,"*¿Llevas armadura o escudo? Te sientes un poco torpe*");


    float fExito=(1-((IntToFloat(iDificultad-(iHabilidad*5 + iBonoAtributo + iBonoRacial)))/80))*100;
    //float fExito=(1-((IntToFloat(iDificultad-(iHabilidad*5 + iBonoAtributo + iBonoRacial + iPenalizador)))/80))*100;


    if(fExito<20.0) {

        SendMessageToPC(oPJ,"*Esto parece algo complicado*");

    }
    if(fExito<5.0) {
        int iNoDarPistas=GetLocalInt(OBJECT_SELF,"NoDarPistas");
        if (iNoDarPistas!=1)
            if(fExito<1.0)
                SendMessageToPC(oPJ,"*Esto es imposible para ti*");
            else
                SendMessageToPC(oPJ,"*Esto es muy complicado para ti*");
    }
    return fExito;

}

//-------------------DEVUELVE EL PORCENTAJE DE APRENDIZAJE
float PorcentajeAprendizaje(object oPJ, object oProcesado, int iHabilidad) {



    int iDificultad=GetLocalInt(oProcesado,"Dificultad");
    int iBonoInt = BonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oPJ);

    float fExito=(((IntToFloat(iDificultad-(iHabilidad*5 + iBonoInt)))/80))*100;
    //al menos un 1% de aprendizaje
    if (fExito<1.0) {fExito=1.0;}
    //


    return fExito;

}

//-------------------DEVUELVE EL BONO A LA TIRARA DE EXITO SEGUN LA RAZA
int BonoRacial(object oPJ, object oProcesado) {



    int x=1;
    int iRazaPJ=GetRacialType(oPJ);
    int iRazaBono=GetLocalInt(oProcesado,"BonoRacial" + IntToString(x));
    while (iRazaBono!=0) {
        if (iRazaBono==CONST_ESPECIAL_RAZA_ENANO) iRazaBono=RACIAL_TYPE_DWARF;
        if (iRazaBono==iRazaPJ) {
            string sBonoPorRaza=GetLocalString(oProcesado ,"BonoRacial" + IntToString(x) + "Dado");
            int iBonoPorRaza = DevolverValorSegunDado(sBonoPorRaza);

            return iBonoPorRaza;
        }
        x++;
        iRazaBono=GetLocalInt(oProcesado,"BonoRacial" + IntToString(x));
    }


    return 0;

}

//-------------------DEVUELVE EL BONO A LA TIRARA DE EXITO SEGUN LOS ATRIBUTOS
int BonoAtributo(object oPJ, object oProcesado) {



    int x=1;
    int iBonoAtributo=0;
    int iAtributo=GetLocalInt(oProcesado,"BonoAtributo" + IntToString(x));
    while (iAtributo!=0) {
        if (iAtributo==-1) iAtributo=0;
        iBonoAtributo = iBonoAtributo + BonoRealCaracteristicaPJ(iAtributo, oPJ);

        x++;
        iAtributo=GetLocalInt(oProcesado,"BonoAtributo" + IntToString(x));
    }


    return iBonoAtributo;

}

//-------------------SI HA TENIDO EXITO LO PROCESA
void ProcesarExito(object oPJ, object oProcesado, int iHabilidad) {



//Animacion exito
    AnimacionExito(oPJ, oProcesado);


//---Consumir
//Bucle consume conjuros (consumir todas o al menos una segun variable)

//Cosume conjuros

    ConsumeRequisitos(TIPO_CONJURO, oPJ, oProcesado, GetLocalInt(oProcesado,"ConjurosTodo"), "conjuro", TIPOVAR_INT);

//Gasta Oro y XP


    int iOroGastar=GetLocalInt(oProcesado,"OroGastar");
    if (iOroGastar>0) TakeGoldFromCreature(iOroGastar, oPJ);
    DeleteLocalInt(oProcesado,"OroGastar");

    int iXpGastar=GetLocalInt(oProcesado,"XpGastar");
    int iXpPJ=GetXP(oPJ);
    if (iXpGastar>0) SetXP(oPJ,iXpPJ-iXpGastar);
    DeleteLocalInt(oProcesado,"XpGastar");


//---Crear
    string sObjetoCrear=GetLocalString(oProcesado,"ObjetoCrear");
    string sRecetaCrear=GetLocalString(oProcesado,"RecetaCrear");
    string sContenedorCrear=GetLocalString(oProcesado,"ContenedorCrear");


    int iObjetoCrearCantidad=DevolverValorSegunDado(GetLocalString(oProcesado,"ObjetoCrearCantidad"));
    if (iObjetoCrearCantidad==0) iObjetoCrearCantidad=1;



    if(GetHasInventory(oProcesado)==TRUE) {
        BorrarInventario(oProcesado);
    }
    int x;
    int iVentaOro=GetLocalInt(oProcesado,"VentaOro");
    int iRenombrable=GetLocalInt(oProcesado,"Renombrable");
    for (x=0; x<iObjetoCrearCantidad; x++) {

        CrearObjeto(oPJ, oProcesado, sObjetoCrear, sRecetaCrear, sContenedorCrear, iVentaOro, iHabilidad, iRenombrable);
        x=x+1;
    }



}

//-------------------CREA EL OBJETO
//-------------------SI oProcesado TIENE INVENTARIO LO CREA EN ESE OBJETO. SI NO EN oPJ
//-------------------SI sObjetoCrear TIENE ALGUN VALOR LO USA COMO RESREF Y LO CREA
//-------------------SI sObjetoCrear NO TIENE ALGUN VALOR LLAMA AL SCRIPT DE LA RECETA Y SE CREA ALLI.
void CrearObjeto(object oPJ, object oProcesado, string sObjetoCrear, string sRecetaCrear, string sContenedorCrear, int iVentaOro, int iHabilidad, int iRenombrable) {



    object oCreado;
    object oPlantilla;
    string sDescripObjetoReceta="";
    string sNombreObjetoReceta="";

    if (sObjetoCrear!="") {
        if (sContenedorCrear=="") {
            if (GetHasInventory(oProcesado)) {

                oCreado=CreateItemOnObject(sObjetoCrear, oProcesado);
            } else {

                oCreado=CreateItemOnObject(sObjetoCrear, oPJ);
            }
        } else {
            object oPlantilla=PlantillaDesdeContenedor(sContenedorCrear, sObjetoCrear);

            if(oPlantilla!=OBJECT_INVALID) {
                if (GetHasInventory(oProcesado)) {

                    oCreado = CopyItem(oPlantilla, oProcesado);
                } else {

                    oCreado = CopyItem(oPlantilla, oPJ);
                }
            }
        }
    } else {
        if (GetHasInventory(oProcesado)) {
            SetLocalInt(oProcesado, "Funcion", FUNCION_CREAR_OBJETO);
            ExecuteScript(sRecetaCrear, oProcesado);
            oPlantilla=GetLocalObject(oProcesado,"ObjetoCreado");
            oCreado=CopyItem(oPlantilla, oProcesado, TRUE);
            sDescripObjetoReceta=GetLocalString(oProcesado,"DescripcionObjeto");
            DeleteLocalString(oProcesado,"DescripcionObjeto");
            sNombreObjetoReceta=GetLocalString(oProcesado,"NombreObjeto");
            DeleteLocalString(oProcesado,"NombreObjeto");
            DestroyObject(oPlantilla);
            DeleteLocalInt(oProcesado,"Funcion");
            DeleteLocalObject(oProcesado,"ObjectoCreado");
            //marco como plot item
            SetPlotFlag(oCreado,TRUE);
            //
        } else {
            SetLocalInt(oPJ, "Funcion", FUNCION_CREAR_OBJETO);
            ExecuteScript(sRecetaCrear, oPJ);
            oPlantilla=GetLocalObject(oPJ,"ObjetoCreado");
            oCreado=CopyItem(oPlantilla, oPJ, TRUE);
            sDescripObjetoReceta=GetLocalString(oProcesado,"DescripcionObjeto");
            DeleteLocalString(oProcesado,"DescripcionObjeto");
            sNombreObjetoReceta=GetLocalString(oProcesado,"NombreObjeto");
            DeleteLocalString(oProcesado,"NombreObjeto");
            DestroyObject(oPlantilla);
            DeleteLocalInt(oPJ,"Funcion");
            DeleteLocalObject(oProcesado,"ObjectoCreado");
            //marco como plot item
            SetPlotFlag(oCreado,TRUE);
            //
        }



    }

    SetLocalInt(oCreado,"VentaOro",iVentaOro + iHabilidad);
    SetLocalInt(oCreado,"Renombrable",iRenombrable);
    SetIdentified(oCreado,TRUE);
    if (sDescripObjetoReceta!="")
    {
       //incluyo firma del artesano segun su habilidad
       string sFirma="";
       int iProfesionAux = GetLocalInt(oProcesado,"Profesion");
       if (iHabilidad > 95)
       {
         string nombreProfesion = NombreMaestro(iProfesionAux);
         if ( FindSubString(nombreProfesion, "artesano") > 0 ) {
             if(GetGender(oPJ) == 1) {sFirma=" Lleva la firma de la reputada maestra artesana urdímbrica " + GetName(oPJ) + ".";}
             else {sFirma=" Lleva la firma del reputado maestro artesano urdímbrico " + GetName(oPJ) + ".";}
         }else{
             if(GetGender(oPJ) == 1) {sFirma=" Lleva la firma de la reputada maestra " + GetSubString(nombreProfesion, 0 , (GetStringLength(nombreProfesion)-1) )+ "a " + GetName(oPJ) + ".";}
             else {sFirma=" Lleva la firma del reputado maestro " + nombreProfesion + " " + GetName(oPJ) + ".";}
         }
         sDescripObjetoReceta = sDescripObjetoReceta + sFirma;
       }
       else if (iHabilidad > 50)
       {
          string nombreProfesion = NombreMaestro(iProfesionAux);
          if ( FindSubString(nombreProfesion, "artesano") > 0){
              if(GetGender(oPJ) == 1) {sFirma=" Lleva la firma de la artesana urdímbrica  " + GetName(oPJ) + ".";}
              else {sFirma=" Lleva la firma del artesano urdímbrico " + GetName(oPJ) + ".";}
          } else{
             if(GetGender(oPJ) == 1) {sFirma=" Lleva la firma de la " + GetSubString(nombreProfesion, 0 , (GetStringLength(nombreProfesion)-1) )+ "a " + GetName(oPJ) + ".";}
             else {sFirma=" Lleva la firma del " + nombreProfesion + " " + GetName(oPJ) + ".";}
          }
          sDescripObjetoReceta = sDescripObjetoReceta + sFirma;
       }
       //fin firma
       SetDescription(oCreado,sDescripObjetoReceta,TRUE);
    }
    if (sNombreObjetoReceta!="")
    {
       SetName(oCreado, sNombreObjetoReceta);
    }
    if (oCreado!=OBJECT_INVALID) DelayCommand(1.5, FloatingTextStringOnCreature("*¡Has conseguido " + GetName(oCreado) + "!*", oPJ));





}

//-------------------SI HA APRENDIDO LO PROCESA
void ProcesarAprendizaje(object oPJ, int iHabilidad, int iProfesion) {

      int iExperiencia = (iHabilidad + 1)/2;
      if(iExperiencia == 0) iExperiencia = 1;
      else if(iExperiencia > 50) iExperiencia = 50;

      DelayCommand(2.5, PlaySound("gui_level_up"));
      DelayCommand(2.5, FloatingTextStringOnCreature("¡Has subido al nivel " + IntToString(iHabilidad + 1) + "!", oPJ));
      DelayCommand(2.5, SetXP(oPJ, GetXP(oPJ) + iExperiencia));

      //para el sistema de monti por varita descomentar la linea comentada
      GuardarIntPersistente(oPJ, "Profesion" + IntToString(iProfesion), iHabilidad + 1);
      //SetLocalInt(oPJ, "Profesion" + IntToString(iProfesion), iHabilidad + 1);

}

//-------------------SI HA FRACASADO...
void ProcesarFracaso(object oPJ, object oProcesado) {

    int iPreservarSiFracaso=GetLocalInt(oProcesado,"PreservarSiFracaso");



    if (iPreservarSiFracaso!=TRUE) {

        if (GetHasInventory(oProcesado)==TRUE) BorrarInventario(oProcesado);
//              Pendiente de decidir como s emaneja este tema.
//            else DestroyObject(oProcesado);
    }

    DelayCommand(2.0, AssignCommand(oPJ,ClearAllActions(TRUE)));
    DelayCommand(2.0, FloatingTextStringOnCreature("*¡Fracasaste!*", oPJ));

    AnimacionFracaso(oPJ, oProcesado);



}

void ConsumeRequisitos(int iTipo, object oPJ, object oProcesado, int iRequisitosTodos, string sVariable, int iTipoVariable) {

    int iElemento=0;
    int iCumple;
    do {
        iCumple=Compara(iTipo, iElemento, sVariable, oPJ, oProcesado);
        if (iCumple) {
            ConsumeRequisito(iTipo, iElemento, oPJ);
            if (iRequisitosTodos==FALSE) return;
                }
        iElemento++;
    } while(ContinuarBucleRequisitos(iElemento, sVariable, iTipoVariable, oProcesado));

}

void ConsumeRequisito(int iTipo, int iElemento, object oPJ) {

    switch (iTipo)  {
    case TIPO_CONJURO:
        DecrementRemainingSpellUses(oPJ, iElemento);
        return;
        }

}


void Animacion(object oPJ, object oProcesado, string sNomVariable) {


    int x=1;
    int iAnimacion=GetLocalInt(oProcesado,sNomVariable + IntToString(x));
    if (iAnimacion!=0) DelayCommand(0.3, AssignCommand(oPJ, ClearAllActions(TRUE)));
    while (iAnimacion!=0) {

        DelayCommand(IntToFloat(x) - 0.5, AssignCommand(oPJ, ActionPlayAnimation(iAnimacion, 1.0, 0.9)));
        x++;
        iAnimacion=GetLocalInt(oProcesado,sNomVariable + IntToString(x));
    }


}

void AnimacionVisual(object oPJ, object oProcesado, string sNomVariable) {


    int x=1;
    effect eEfecto;
    int iAnimacion=GetLocalInt(oProcesado,sNomVariable + "Visual" + IntToString(x));
    while (iAnimacion!=0) {

        eEfecto = EffectVisualEffect(iAnimacion);
        DelayCommand(IntToFloat(x) - 0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto, oPJ));
        x++;
        iAnimacion=GetLocalInt(oProcesado,sNomVariable + "Visual" + IntToString(x));
    }


}

void AnimacionPJ(object oPJ, object oProcesado) {


    Animacion(oPJ, oProcesado, "AnimacionPJ");
    AnimacionVisual(oPJ, oProcesado, "AnimacionPJ");


}

void AnimacionExito(object oPJ, object oProcesado) {


    Animacion(oPJ, oProcesado, "AnimacionExito");
    AnimacionVisual(oPJ, oProcesado, "AnimacionExito");


}

void AnimacionFracaso(object oPJ, object oProcesado) {


    Animacion(oPJ, oProcesado, "AnimacionFracaso");
    AnimacionVisual(oPJ, oProcesado, "AnimacionFracaso");


}


void AnimacionProcesado(object oPJ, object oProcesado) {



    int iTotalAnimaciones=0;
    int iAnimacion;
    int iTotalSonidos=0;
    effect eEfecto;
    string sSonido;
    int x;

    x=1;
    iAnimacion=GetLocalInt(oProcesado,"AnimacionProcesado" + IntToString(x));
    int iEjecutarTodasLasAnimaciones=GetLocalInt(oProcesado,"EjecutarTodasLasAnimaciones");
    while (iAnimacion!=0) {
        iTotalAnimaciones++;
        if (iEjecutarTodasLasAnimaciones==1) {
            eEfecto = EffectVisualEffect(iAnimacion);

            if (GetObjectType(oProcesado)==OBJECT_TYPE_TRIGGER)
                DelayCommand(x - 0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto, oPJ));
            else
                DelayCommand(x - 0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto, oProcesado));
            }
        x++;
        iAnimacion=GetLocalInt(oProcesado,"AnimacionProcesado" + IntToString(x));
    }

    x=1;
    sSonido=GetLocalString(oProcesado,"SonidoProcesado" + IntToString(x));
    int iEjecutarTodosLosSonidos=GetLocalInt(oProcesado,"EjecutarTodosLosSonidos");
    while (sSonido!="") {
        iTotalSonidos++;
        if (iEjecutarTodosLosSonidos==1) {

            DelayCommand(IntToFloat(x) - 0.5, PlaySound(sSonido));
        }
        x++;
        sSonido=GetLocalString(oProcesado,"SonidoProcesado" + IntToString(x));
    }

    int iRandomAnimacion=Random(iTotalAnimaciones)+1;
    if(iRandomAnimacion!=0) iAnimacion=GetLocalInt(oProcesado,"AnimacionProcesado" + IntToString(iRandomAnimacion));

    int iEmparejarAnimacionYSonido=GetLocalInt(oProcesado,"EmparejarAnimacionYSonido");
    if(iTotalAnimaciones==iTotalSonidos && iEmparejarAnimacionYSonido==TRUE) {
        sSonido=GetLocalString(oProcesado,"SonidoProcesado" + IntToString(iRandomAnimacion));
    } else {
        int iRandomSonido=Random(iTotalSonidos)+1;
        sSonido=GetLocalString(oProcesado,"SonidoProcesado" + IntToString(iRandomSonido));
    }

    if (iAnimacion!=0) {
        eEfecto = EffectVisualEffect(iAnimacion);

        if (GetObjectType(oProcesado)==OBJECT_TYPE_TRIGGER)
            DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto, oPJ));
        else
            DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto, oProcesado));
    }

    if (sSonido!="") {

        DelayCommand(0.5, PlaySound(sSonido));
    }




}

int SufirLesion(object oPJ, object oProcesado) {
//Hay un n% de sufir lesion de sufir lesiones.



    int iPorcentajeLesion = GetLocalInt(oProcesado,"PorcentajeLesion");
    int iLesion=d100();



    if (iLesion>iPorcentajeLesion) {

        return FALSE;
    }

    //Si hay lesion le aplicamos primero los efectos de dano a habilidad
    effect eEfecto;
    int x;
    int iEfecto;
    int iEfectoNivel;
    int iEfectoDivisor;
    int iEfectoVisual;
    int iEfectoTipoDuracion;
    float fEfectoDuracion;
    int iHP;

    x=1;
    iEfecto=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "DañoHabilidad" + IntToString(x));
    while (iEfecto!=0) {
        if (iEfecto==-1) iEfecto=0;
        iEfectoNivel=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "DañoHabilidad" + IntToString(x) + "Nivel");
        effect eEfecto = EffectAbilityDecrease(iEfecto, iEfectoNivel);
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEfecto, oPJ));



        x++;
        iEfecto=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "DañoHabilidad" + IntToString(x));
    }

    //Luego los danos fisicos
    x=1;
    iEfecto=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "DañoFisicoTipo" + IntToString(x));
    while (iEfecto!=0) {
        if (iEfecto==-1) iEfecto=0;
        iHP=GetCurrentHitPoints(oPJ);
        iEfectoDivisor=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "DañoFisico" + IntToString(x) + "Divisor");
        effect eEfecto = EffectDamage(iHP/iEfectoDivisor,iEfecto,DAMAGE_POWER_PLUS_TWENTY);
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto, oPJ));



        x++;
        iEfecto=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "DañoFisicoTipo" + IntToString(x));
    }

    //Luego perder velocidad
    int iReducirVelocidad=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "ReducirVelocidad");
    if(iReducirVelocidad!=0) {
        effect eReducirVelocidad = EffectMovementSpeedDecrease(iReducirVelocidad);
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eReducirVelocidad, oPJ));


    }

    //Efectos especiales.
    x=1;
    iEfecto=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "EfectoEspecial" + IntToString(x));
    while (iEfecto!=0) {
        if (iEfecto==-1) iEfecto=0;
        iEfectoNivel=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "EfectoEspecial" + IntToString(x) + "Nivel");
        iEfectoTipoDuracion=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "EfectoEspecial" + IntToString(x) + "TipoDuracion");
        fEfectoDuracion=GetLocalFloat(oProcesado,"Lesion" + IntToString(iLesion) + "EfectoEspecial" + IntToString(x) + "Duracion");

        if(iEfecto>0) {
            eEfecto=EfectoEspecialLesion(iEfecto, iEfectoNivel, iEfectoTipoDuracion, fEfectoDuracion);
            if (GetEffectType(eEfecto)!=EFFECT_TYPE_INVALIDEFFECT) DelayCommand(2.0, ApplyEffectToObject(iEfectoTipoDuracion, eEfecto, oPJ, fEfectoDuracion));
        } else {
            EfectoEspecialPropio(iEfecto, oProcesado, oPJ, iLesion, x);
        }

        if (iEfectoVisual!=0) {
            effect eEfectoEspecialVisual = EffectVisualEffect(iEfectoVisual);
            DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfectoEspecialVisual, oPJ));
        }



        x++;
        iEfecto=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "EfectoEspecial" + IntToString(x));
    }

    //Efectos visuales
    x=1;
    iEfectoVisual=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "Visual" + IntToString(x));
    while (iEfectoVisual!=0) {
        if (iEfectoVisual==-1) iEfectoVisual=0;
        fEfectoDuracion=GetLocalFloat(oProcesado,"Lesion" + IntToString(iLesion) + "Visual" + IntToString(x) + "Duracion");
        if(fEfectoDuracion==0.0) fEfectoDuracion=2.0;

        if (iEfectoVisual!=0) {
            effect eEfectoEspecialVisual = EffectVisualEffect(iEfectoVisual);

            DelayCommand(IntToFloat(x) + 1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfectoEspecialVisual, oPJ, fEfectoDuracion));
        }



        x++;
        iEfectoVisual=GetLocalInt(oProcesado,"Lesion" + IntToString(iLesion) + "Visual" + IntToString(x));
    }

    //Sonidos
    x=1;
    string sSonido=GetLocalString(oProcesado,"Lesion" + IntToString(iLesion) + "Sonido" + IntToString(x));
    while (sSonido!="") {
        DelayCommand(IntToFloat(x) + 1.0, AssignCommand(OBJECT_SELF, PlaySound(sSonido)));


        x++;
        sSonido=GetLocalString(oProcesado,"Lesion" + IntToString(iLesion) + "Sonido" + IntToString(x));
    }

    string sMensajeLesion=GetLocalString(oProcesado, "Lesion" + IntToString(iLesion) + "Mensaje");
    DelayCommand(2.0, FloatingTextStringOnCreature(sMensajeLesion, oPJ, FALSE));


    switch(d3()) {
    case 1:
        DelayCommand(2.5, PlayVoiceChat(VOICE_CHAT_PAIN1, oPJ));
        break;
    case 2:
        DelayCommand(2.5, PlayVoiceChat(VOICE_CHAT_PAIN2, oPJ));
        break;
    case 3:
        DelayCommand(2.5, PlayVoiceChat(VOICE_CHAT_PAIN3, oPJ));
        break;
    }


    return TRUE;

}

effect EfectoEspecialLesion(int iEfectoEspecial, int iEfectoNivel, int iEfectoTipoDuracion, float iEfectoDuracion) {



    switch (iEfectoEspecial) {
    case  EFFECTO_ESPECIAL_CEGERA:
        return EffectBlindness();
    case EFFECTO_ESPECIAL_ATONTADO:
        return EffectStunned();
    case EFFECTO_ESPECIAL_PETRIFICADO:
        return EffectPetrify();
    case EFFECTO_ESPECIAL_ENERVADO:
        return EffectNegativeLevel(iEfectoNivel);
    }


    return EffectVisualEffect(EFFECT_TYPE_INVALIDEFFECT);

}

void EfectoEspecialPropio(int iEfecto, object oUbicado, object oPJ, int iNumLesion, int iNumSubLesion){

    location lLocalizacion;
    vector vLocalizacion;
    string sVariable;

    switch (iEfecto) {
        case EFFECTO_ESPECIAL_ENCUENTRO:
            lLocalizacion = GetLocation(oPJ);
            vLocalizacion=GetPositionFromLocation(lLocalizacion);
            vLocalizacion.x=vLocalizacion.x + (2+IntToFloat(Random(80)-40))/10.0;
            vLocalizacion.y=vLocalizacion.y + (2+IntToFloat(Random(80)-40))/10.0;
            lLocalizacion=Location(GetAreaFromLocation(lLocalizacion), vLocalizacion, 0.0);
            sVariable = GetLocalString(oUbicado,"Lesion" + IntToString(iNumLesion) + "EfectoEspecial" + IntToString(iNumSubLesion)) + "Variable";
            SendMessageToPC(oPJ,"*Oyes unos ruidos sospechosos...*");
            PlayVoiceChat(VOICE_CHAT_ENEMIES, oPJ);
            DelayCommand(10.0,CreateObjectVoid(OBJECT_TYPE_CREATURE,sVariable,lLocalizacion,TRUE));
            break;
        case EFFECTO_ESPECIAL_MATERIAL_DESTRUIDO:

            BorrarInventario(oUbicado);
            break;
        case EFFECTO_ESPECIAL_HERRAMIENTA_DESTRUIDA:
            sVariable = GetLocalString(oUbicado,"Lesion" + IntToString(iNumLesion) + "EfectoEspecial" + IntToString(iNumSubLesion)) + "Variable";
            object oHerramienta= GetItemPossessedBy(oUbicado,sVariable);

            DestroyObject(oHerramienta, 6.0);
            break;
    }
}

int AccesoFormula(int iHabilidad, object oPJ) {

// ACCESO A FORMULA DE EXITO (PRIMERA TIRADA)
    int iTiradaAcceso = d100();
    int iBonoTiradaAcceso = (iHabilidad/4);

    // 70% a nivel 0
    // 75% a nivel 20
    // 85% a nivel 60
    // 95% a nivel 100
    int iRetorno = (iTiradaAcceso + iBonoTiradaAcceso >= 30);


    return iRetorno;
}

//----------------------
int CargarFormula(object oPJ, object oProcesado) {



    int iProfesion=GetLocalInt(oProcesado, "Profesion");
    if (iProfesion==0) {
        SendMessageToPC(oPJ, "El ubicado no esta preparado para trabajar con nnguna profesion");

        return FALSE;
    }

    int iNumFormulas=DevolverNumFormulas(iProfesion);
    int x=1;
    string sNombreScript;

    while(x<=iNumFormulas) {
        sNombreScript="sapo_rect_" + IntToString(iProfesion) + "_" + IntToString(x);
        SetLocalInt(oProcesado,"Funcion",FUNCION_COMPROBAR_Y_CARGAR);

        ExecuteScript(sNombreScript,oProcesado);
        if (GetLocalInt(oProcesado,"fnRetorno")==TRUE) {
            DeleteLocalInt(oProcesado,"fnRetorno");

            return TRUE;
        }
        x++;
    }

    DeleteLocalInt(oProcesado,"fnRetorno");

    return FALSE;
}

int ObjetoEsCreable(object oProcesado, object oPJ) {



    string sObjetoCrear=GetLocalString(oProcesado,"ObjetoCrear");
    string sRecetaCrear=GetLocalString(oProcesado,"RecetaCrear");
    string sContenedorCrear=GetLocalString(oProcesado,"ContenedorCrear");

    object oPlantilla;
    int iRetorno;

    if (sObjetoCrear!="") {
        if (sContenedorCrear=="") {
            oPlantilla=CreateItemOnObject(sObjetoCrear, oProcesado);
            iRetorno=(oPlantilla!=OBJECT_INVALID);
            DestroyObject(oPlantilla);

            return iRetorno;
        } else {
            oPlantilla=PlantillaDesdeContenedor(sContenedorCrear, sObjetoCrear);
            iRetorno=(oPlantilla!=OBJECT_INVALID);

            return iRetorno;
        }
    } else {

        if (sRecetaCrear=="") {

            return FALSE;

        } else {

            return TRUE;
        }
    }


    return FALSE;

}
