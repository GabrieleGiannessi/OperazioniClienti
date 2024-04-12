create or replace package operazioniclienti as

/*
    user CONSTANT VARCHAR(20):='g_giannessi'; 
    root CONSTANT VARCHAR(20):=user||'.operazioniClienti';
  */  
    --capire bene come mai l'integrazione delle costanti causa errori nel pkb

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
		id          varchar2 default null,
		cl_email    varchar2 default null,
		cl_password varchar2 default null,
		cl_telefono varchar2 default null
	);

    procedure visualizzaBustePaga (
        r_IdSessione varchar2,
        r_dipendente in varchar2 default null,
        r_contabile  in varchar2 default null,
        r_data       in varchar2 default null,
        r_importo    in varchar2 default null,
        r_bonus      in varchar2 default null,
        r_PopUp in varchar2 default null
    );

	procedure modificabustapaga (
		r_fkdipendente in varchar2 default null,
		r_fkcontabile  in varchar2 default null,
		r_data         in varchar2 default null,
		r_importo      in varchar2 default null,
		r_bonus        in varchar default null,
		r_popup        in boolean default false,
		new_importo    in varchar2 default null,
		new_bonus      in varchar2 default null
	);

    procedure visualizzabustepagadipendente (
        r_IDsessione in varchar2,
        r_Data       in varchar2 default null,
        r_Importo    in varchar2 default null,
        r_Bonus      in varchar2 default null
    );
    procedure inserimentobustapaga (
        r_IdSessioneContabile in varchar2,
        r_FkDipendente        in varchar2 default null,
        r_Importo             in varchar2 default null
    );
    
    procedure visualizzaricarichecliente (
        r_IdSessioneCliente in varchar2,
        r_Data              in varchar2 default null,
        r_Importo           in varchar2 default null
    );
    procedure inserimentoricarica (
        r_IdSessioneCliente in varchar2,
        r_Importo           in varchar2 default null
    );

	procedure visualizzaclienti (
		c_nome          varchar2 default null,
		c_cognome       varchar2 default null,
		c_datanascita   varchar2 default null,
		c_maschio       varchar2 default null,
		c_femmina       varchar2 default null,
		row_nome        varchar2 default null,
		row_cognome     varchar2 default null,
		row_datanascita varchar2 default null,
		row_sesso       varchar2 default null,
		row_telefono    varchar2 default null,
		row_email       varchar2 default null,
		elimina         varchar2 default null
	);

	procedure inserimentoconvenzione;
	procedure inseriscidaticonvenzione (
		p_nome          in convenzioni.nome%type,
		p_ente          in convenzioni.ente%type,
		p_sconto        in convenzioni.sconto%type,
		p_codiceaccesso in convenzioni.codiceaccesso%type,
		p_datainizio    in convenzioni.datainizio%type,
		p_datafine      in convenzioni.datafine%type,
		p_cumulabile    in convenzioni.cumulabile%type
	);

	procedure visualizzazioneconvenzioni (
		datainizio varchar2 default null,
		datafine   varchar2 default null,
		ente       varchar2 default null
	);
	procedure inserimentocontabile (
		r_idsessionemanager varchar2 default null,
		r_fkdipendente      varchar2 default null
	);

	function checkdipendente (
		r_iddipendente in varchar2 default null
	) return boolean;

	--function checkContabile(r_IdContabile in varchar2 default null) return boolean;

	function existbustapaga (
		r_fkdipendente in varchar2 default null,
		r_fkcontabile  in varchar2 default null,
		r_data         in varchar2 default null
	) return boolean;

end operazioniclienti;