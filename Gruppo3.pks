create or replace package Gruppo3 as
	u_user constant varchar(100) := 'http://131.114.73.203:8080/apex/g_giannessi';
	u_root constant varchar(100) := u_user || '.Gruppo3';

    procedure visualizzabustepaga (
        idSess in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_Dipendente in BUSTEPAGA.FK_DIPENDENTE%TYPE default null,
        r_Contabile  in BUSTEPAGA.FK_CONTABILE%TYPE default null,
        r_Data       in varchar2 default null,
        r_Importo    in BUSTEPAGA.IMPORTO%TYPE default null,
        r_Bonus      in BUSTEPAGA.BONUS%TYPE default null,
        r_PopUp      in varchar2 default null
    );

    procedure modificabustapaga (
        idSess in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_FkDipendente in BUSTEPAGA.FK_CONTABILE%TYPE,
        r_Data in BUSTEPAGA.DATA%TYPE,
        r_PopUp in varchar2 default null,
        new_Importo in varchar2 default null,
        new_Data in varchar2 default null
    );

    procedure visualizzabustepagadipendente (
        idSess in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_Data       in varchar2 default null,
        r_Importo    in BUSTEPAGA.IMPORTO%TYPE default null,
        r_Bonus      in BUSTEPAGA.BONUS%TYPE default null
    );
    procedure inserimentobustapaga (
        idSess in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_FkDipendente in BUSTEPAGA.FK_DIPENDENTE%TYPE default null,
        r_Data       in varchar2 default null,
        r_Importo    in BUSTEPAGA.IMPORTO%TYPE default null,
        r_PopUp     in varchar2 default null
    );

	procedure dettagliStipendiPersonale(
        idSess in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_dataInizio in varchar2 default null,
        r_dataFine in varchar2 default null
    );

	procedure dettagliRicaricheClienti(
        idSess in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_DataInizio in varchar2 default null,
        r_DataFine in varchar2 default null
    );

    procedure visualizzaricarichecliente (
        idSess in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_Data       in varchar2 default null,
        r_Importo    in RICARICHE.IMPORTO%TYPE default null,
        r_PopUp in varchar2 default null
    );
    procedure inserimentoricarica (
        idSess in SESSIONIDIPENDENTI.IDSESSIONE%TYPE,
        r_Importo    in RICARICHE.IMPORTO%TYPE default null,
        r_PopUp in varchar2 default null
    );

	procedure registrazionecliente;

	procedure inseriscidati (
		nome     varchar2 default null,
		cognome  varchar2 default null,
		email    varchar2 default null,
		password varchar2 default null,
		telefono varchar2 default null,
		day      varchar2 default null,
		month    varchar2 default null,
		year     varchar2 default null,
		gender   varchar2 default null
	);

	procedure modificacliente (
		idsess      varchar default null,  -- identifica chi sta facendo l'accesso
		cl_id       varchar2 default null, -- identifica l'id del cliente a cui facciamo le modifiche
		cl_email    varchar2 default null,
		cl_password varchar2 default null,
		cl_telefono varchar2 default null,  -- questi parametri servono per le update dei campi
		err_popup   varchar2 default null
	);

	procedure visualizzaclienti (
		idsess        varchar default null,
		c_nome        varchar2 default null,
		c_cognome     varchar2 default null,
		c_datanascita varchar2 default null,
		c_sesso         varchar2 default null
	);

	procedure visualizzaprofilo (
		idsess varchar default '-1', --id della sessione (cliente o manager)
        id varchar2 default null --id del cliente 
	);
	----------------------------------------

	--procedure convenzioni

	procedure inserisciConvenzione (
		idsess varchar, --per accedere devi essere loggato (e ruolo = operatore)
		popup varchar2 default null
	);

	procedure inseriscidaticonvenzione (
        idSess 			varchar2,
		r_nome          varchar2 default null,
		r_ente          varchar2 default null,
		r_sconto        varchar2 default null,
		r_codiceaccesso varchar2 default null,
		r_datainizio    varchar2 default null,
		r_datafine      varchar2 default null,
		r_cumulabile    varchar2 default null
	);

	procedure visualizzaconvenzioni (
		idSess varchar DEFAULT NULL, 
		c_datainizio varchar2 default null,
		c_datafine   varchar2 default null,
		c_ente       varchar2 default null,
		c_cumulabile VARCHAR2 DEFAULT NULL
	);

	procedure associaConvenzione (
		idSess varchar default null,
		c_Nome varchar2 default null,
		err_popup varchar2 default null
	); 

	procedure modificaConvenzione (
		idSess varchar default null,
        c_id varchar2, 
        c_sconto varchar2 default null, 
        c_dataInizio varchar2 default null, 
        c_dataFine varchar2 default null,
        c_cumulabile varchar2 default null
	); 

	procedure dettagliConvenzioni (
		idSess varchar default null,
		c_nome CONVENZIONI.NOME%TYPE default null
	); 

	---------------------------------------------
	procedure inserimentocontabile (
		idSessmanager varchar2 default null,
		r_fkdipendente      varchar2 default null
	);

    function existdipendente (
        r_IdDipendente in DIPENDENTI.MATRICOLA%TYPE
    ) return number;

	--function checkContabile(r_IdContabile in varchar2 default null) return boolean;

    function existbustapaga (
        r_FkDipendente in BUSTEPAGA.FK_DIPENDENTE%TYPE,
        r_Data in BUSTEPAGA.DATA%TYPE
    ) return boolean;

end Gruppo3;