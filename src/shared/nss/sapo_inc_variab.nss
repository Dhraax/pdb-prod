#include "sapo_constantes"

//funciones para facilitar definir las varibales de un ubicado

//Funciones para facilitar la definicion de lesiones

void LesionesPorcentaje(object oUbicado, int iPorcentaje) {

    SetLocalInt(oUbicado,"PorcentajeLesion",iPorcentaje);
}

void LesionMensaje(object oUbicado, int iNumeroLesion, string sMensaje) {

    SetLocalString(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "Mensaje",sMensaje);

}

void LesionVelocidad(object oUbicado, int iNumeroLesion, int iVelocidad) {

    SetLocalInt(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "ReducirVelocidad",iVelocidad);

}

void LesionHabilidad(object oUbicado, int iNumeroLesion, int iNumeroSubLesion, int iHabilidad, int iDano) {

    if (iHabilidad==ABILITY_STRENGTH)
        SetLocalInt(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "DañoHabilidad" + IntToString(iNumeroSubLesion) ,CONST_ESPECIAL_ATRIBUTO_FUERZA);
    else
        SetLocalInt(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "DañoHabilidad" + IntToString(iNumeroSubLesion) ,iHabilidad);

    SetLocalInt(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "DañoHabilidad" + IntToString(iNumeroSubLesion) + "Nivel",iDano);


}

void LesionEfectoEspecial(object oUbicado, int iNumeroLesion, int iNumeroSubLesion, int iEfectoEspecial, int iTipoDuracion=DURATION_TYPE_TEMPORARY, float fDuracion=10.0, string sVariable="") {

    SetLocalInt(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "EfectoEspecial" + IntToString(iNumeroSubLesion), iEfectoEspecial);
    SetLocalInt(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "EfectoEspecial" + IntToString(iNumeroSubLesion) + "TipoDuracion", iTipoDuracion);
    SetLocalFloat(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "EfectoEspecial" + IntToString(iNumeroSubLesion) + "Duracion", fDuracion);
    SetLocalString(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "EfectoEspecial" + IntToString(iNumeroSubLesion) + "Variable", sVariable);

}

void LesionEfectoVisual(object oUbicado, int iNumeroLesion, int iNumeroSubLesion, int iEfectoVisual) {

    SetLocalInt(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "Visual" + IntToString(iNumeroSubLesion),iEfectoVisual);
}

void LesionSonido(object oUbicado, int iNumeroLesion, int iNumeroSubLesion, string sSonido) {

    SetLocalString(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "Sonido" + IntToString(iNumeroSubLesion),sSonido);
}

void LesionDano(object oUbicado, int iNumeroLesion, int iNumeroSubLesion, int iTipoDano, int iDivisor) {

    SetLocalInt(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "DañoFisicoTipo" + IntToString(iNumeroSubLesion),iTipoDano);
    SetLocalInt(oUbicado,"Lesion" + IntToString(iNumeroLesion) + "DañoFisico" + IntToString(iNumeroSubLesion) + "Divisor",iDivisor);

}


//Funcion para bono racial

void BonoRacial(object oUbicado, int iNumeroBono, int iRaza, string sBono) {

    if (iRaza==RACIAL_TYPE_DWARF)
        SetLocalInt(oUbicado,"BonoRacial" + IntToString(iNumeroBono), CONST_ESPECIAL_RAZA_ENANO);
    else
        SetLocalInt(oUbicado,"BonoRacial" + IntToString(iNumeroBono), iRaza);

    SetLocalString(oUbicado,"BonoRacial" + IntToString(iNumeroBono) + "Dado",sBono);


}

//Funcion para bono atributo
void BonoAtributo(object oUbicado, int iNumeroBono, int iHabilidad) {

    if (iHabilidad==ABILITY_STRENGTH)
        SetLocalInt(oUbicado,"BonoAtributo" + IntToString(iNumeroBono), CONST_ESPECIAL_ATRIBUTO_FUERZA);
    else
        SetLocalInt(oUbicado,"BonoAtributo" + IntToString(iNumeroBono), iHabilidad);


}


//Funcion para requisitos
void RequisitoClasesTodos(object oUbicado, int iTodos) {

    if (iTodos==TRUE)
        SetLocalInt(oUbicado,"ClasesTodo", 1);
    else
        DeleteLocalInt(oUbicado,"ClasesTodo");

}

void RequisitoClase(object oUbicado, int iNumeroRequisito, int iClase, int iNivel) {

    if (iClase==CLASS_TYPE_BARBARIAN)
        SetLocalInt(oUbicado,"Clase" + IntToString(iNumeroRequisito), CONST_ESPECIAL_CLASE_BARBARO);
    else
        SetLocalInt(oUbicado,"Clase" + IntToString(iNumeroRequisito), iClase);

    SetLocalInt(oUbicado,"ClaseRango" + IntToString(iNumeroRequisito), iNivel);

}

void RequisitoTalentosTodos(object oUbicado, int iTodos) {

    if (iTodos==TRUE)
        SetLocalInt(oUbicado,"TalentosTodo", 1);
    else
        DeleteLocalInt(oUbicado,"TalentosTodo");

}

void RequisitoTalento(object oUbicado, int iNumeroRequisito, int iTalento) {

    if (iTalento==FEAT_ALERTNESS)
        SetLocalInt(oUbicado,"Talento" + IntToString(iNumeroRequisito), CONST_ESPECIAL_TALENTO_ALERTA);
    else
        SetLocalInt(oUbicado,"Talento" + IntToString(iNumeroRequisito), iTalento);


}

void RequisitoHabilidadesTodos(object oUbicado, int iTodos) {

    if (iTodos==TRUE)
        SetLocalInt(oUbicado,"HabilidadesTodo", 1);
    else
        DeleteLocalInt(oUbicado,"HabilidadesTodo");

}

void RequisitoHabilidad(object oUbicado, int iNumeroRequisito, int iHabilidad, int iNivel) {

    if (iHabilidad==SKILL_ANIMAL_EMPATHY)
        SetLocalInt(oUbicado,"Habilidad" + IntToString(iNumeroRequisito), CONST_ESPECIAL_HABILIDAD_EMPATIA_ANIMAL);
    else
        SetLocalInt(oUbicado,"Habilidad" + IntToString(iNumeroRequisito), iHabilidad);

    SetLocalInt(oUbicado,"HabilidadRango" + IntToString(iNumeroRequisito), iNivel);

}

void RequisitoConjurosTodos(object oUbicado, int iTodos) {

    if (iTodos==TRUE)
        SetLocalInt(oUbicado,"ConjurosTodo", 1);
    else
        DeleteLocalInt(oUbicado,"ConjurosTodo");

}

void RequisitoConjuro(object oUbicado, int iNumeroRequisito, int iConjuro) {

    if (iConjuro==TRUE)
        SetLocalInt(oUbicado,"Conjuro" + IntToString(iNumeroRequisito), CONST_ESPECIAL_CONJURO_NIEBLA_ACIDA);
    else
        SetLocalInt(oUbicado,"Conjuro" + IntToString(iNumeroRequisito), iConjuro);

}
//Agregar sonidos y animaciones
void SonidoProcesado(object oUbicado, int iNumeroSonido, string sSonido) {

    SetLocalString(oUbicado,"SonidoProcesado" + IntToString(iNumeroSonido),sSonido);

}

void AnimacionProcesado(object oUbicado, int iNumeroAnimacion, int iAnimacion) {

    SetLocalInt(oUbicado,"AnimacionProcesado" + IntToString(iNumeroAnimacion), iAnimacion);

}

void SonidoAnimacionProcesadoEmparejado(object oUbicado, int iNumero, string sSonido, int iAnimacion) {

    SetLocalString(oUbicado,"SonidoProcesado" + IntToString(iNumero),sSonido);
    SetLocalInt(oUbicado,"AnimacionProcesado" + IntToString(iNumero), iAnimacion);

}

void EjecutaTodosLosSonidosProcesado(object oUbicado, int iEjecutaTodos) {

    if(iEjecutaTodos==TRUE)
        SetLocalInt(oUbicado,"EjecutarTodosLosSonidos",1);
    else
        DeleteLocalInt(oUbicado,"EjecutarTodosLosSonidos");

}

void EjecutaTodasLasAnimacionesProcesado(object oUbicado, int iEjecutaTodos) {

    if(iEjecutaTodos==TRUE)
        SetLocalInt(oUbicado,"EjecutarTodasLasAnimaciones",1);
    else
        DeleteLocalInt(oUbicado,"EjecutarTodasLasAnimaciones");

}

void AnimacionExito(object oUbicado, int iNumeroAnimacion, int iAnimacion) {

    SetLocalInt(oUbicado,"AnimacionExito" + IntToString(iNumeroAnimacion),iAnimacion);

}

void AnimacionFracaso(object oUbicado, int iNumeroAnimacion, int iAnimacion) {

    SetLocalInt(oUbicado,"AnimacionFracaso" + IntToString(iNumeroAnimacion),iAnimacion);

}

void AnimacionPJ(object oUbicado, int iNumeroAnimacion, int iAnimacion) {

    SetLocalInt(oUbicado,"AnimacionPJ" + IntToString(iNumeroAnimacion),iAnimacion);

}

void AnimacionExitoVisual(object oUbicado, int iNumeroAnimacion, int iAnimacion) {

    SetLocalInt(oUbicado,"AnimacionExitoVisual" + IntToString(iNumeroAnimacion),iAnimacion);

}

void AnimacionFracasoVisual(object oUbicado, int iNumeroAnimacion, int iAnimacion) {

    SetLocalInt(oUbicado,"AnimacionFracasoVisual" + IntToString(iNumeroAnimacion),iAnimacion);

}

void AnimacionPJVisual(object oUbicado, int iNumeroAnimacion, int iAnimacion) {

    SetLocalInt(oUbicado,"AnimacionPJVisual" + IntToString(iNumeroAnimacion),iAnimacion);

}

void EmparejarAnimacionYSonido(object oUbicado, int iEmparejar) {

    if(iEmparejar==TRUE)
        SetLocalInt(oUbicado,"EmparejarAnimacionYSonido",1);
    else
        DeleteLocalInt(oUbicado,"EmparejarAnimacionYSonido");

}

//Herramienta

void Herramienta(object oUbicado, int iNumeroHerramienta, string sHerramienta) {

    SetLocalString(oUbicado,"Herramienta" + IntToString(iNumeroHerramienta),sHerramienta);

}

//Relacionado con Dano Herramientas

void DanoHerramientaPorUso(object oUbicado, string sDano) {

    SetLocalString(oUbicado,"DañoHerramientaPorUso",sDano);

}


//Relacionado con la creacion del objeto
void ObjetoCrearCantidad(object oUbicado, string sCantidad) {

    SetLocalString(oUbicado,"ObjetoCrearCantidad",sCantidad);

}

void ObjetoCrear(object oUbicado, string sObjetoCrear) {

    SetLocalString(oUbicado,"ObjetoCrear",sObjetoCrear);

}

void ContenedorCrear(object oUbicado, string sContenedorCrear) {

    SetLocalString(oUbicado,"ContenedorCrear",sContenedorCrear);

}

void RecetaCrear(object oUbicado, string sRecetaCrear) {

    SetLocalString(oUbicado,"RecetaCrear",sRecetaCrear);

}

//Dificultad y Oro venta
void DificultadFormula(object oUbicado, int iDificultad) {

    SetLocalInt(oUbicado,"Dificultad",iDificultad);
}

void OroVenta(object oUbicado, int iOroVenta) {

    SetLocalInt(oUbicado,"OROVENTA",iOroVenta);
}

