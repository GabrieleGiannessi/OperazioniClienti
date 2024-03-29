create or replace package body operazioniclienti as

	procedure visualizzaBustePaga (
		r_Dipendente in varchar2 default null,
        r_Contabile in varchar2 default null,
		r_data    in varchar2 default null,
		r_importo in varchar2 default null,
        r_bonus in varchar2 default null
	)
    is
	begin
		gui.apripagina('VisualizzazioneBustePaga');
        gui.apriformfiltro('http://131.114.73.203:8080/apex/l_bindi.OperazioniClienti.visualizzaBustePaga');
		gui.aggiungicampoformfiltro(nome => 'r_Dipendente', placeholder => 'Dipendente');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
		gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
        gui.aggiungicampoformfiltro(nome => 'r_Bonus', placeholder => 'Bonus');
        gui.aggiungicampoformfiltro(nome => 'r_Contabile', placeholder => 'Contabile');
		gui.aggiungicampoformfiltro('submit', '', 'Filtra', '');
		htp.prn('<br>');
		gui.chiudiformfiltro;

		gui.apritabella;
		gui.apriheadertabella;
		gui.aggiungiheadertabella(elemento => 'Dipendente');
		gui.aggiungiheadertabella(elemento => 'Data');
		gui.aggiungiheadertabella(elemento => 'Importo');
		gui.aggiungiheadertabella(elemento => 'Bonus');
		gui.aggiungiheadertabella(elemento => 'Contabile');
		gui.chiudiheadertabella;
		for busta_paga in (
			select *
			from BUSTEPAGA b
			where ( b.FK_DIPENDENTE = r_Dipendente or r_Dipendente is null )
			and ( b.FK_CONTABILE = r_Contabile or r_Contabile is null )
			and ( ( trunc(b.Data) = to_date(r_data,'YYYY-MM-DD') ) or r_data is null )
			and ( b.Importo = to_number(r_importo) or r_importo is null )
			and ( b.Bonus = to_number(r_bonus) or r_bonus is null)
			order by data desc
		) loop
			gui.aggiungirigatabella;
			gui.aggiungielementotabella(elemento => busta_paga.fk_dipendente);
			gui.aggiungielementotabella(elemento => busta_paga.data);
			gui.aggiungielementotabella(elemento => busta_paga.importo);
			gui.aggiungielementotabella(elemento => busta_paga.bonus);
			gui.aggiungielementotabella(elemento => busta_paga.fk_contabile);
			gui.aggiungipulsanteintabella('.','.');
			gui.chiudirigatabella;
		end loop;

		gui.chiuditabella();
		gui.chiudibody();

	end visualizzabustepaga;

	procedure visualizzaBustePagaDipendente (
		r_IdSessione in varchar2 default null,
		r_data    in varchar2 default null,
		r_importo in varchar2 default null,
        r_bonus in varchar2 default null
	) is
	begin

		gui.apripagina;

		gui.apriformfiltro('http://131.114.73.203:8080/apex/l_bindi.OperazioniClienti.visualizzaBustePagaDipendente');
		htp.prn('<input type = "hidden" name = "r_IdSessione" value="'||r_IdSessione||'">');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
        gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
		gui.aggiungicampoformfiltro(nome => 'r_Bonus', placeholder => 'Bonus');
        gui.aggiungicampoformfiltro('submit', '', 'Filtra', '');
		htp.prn('<br>');
		gui.chiudiformfiltro;


		gui.apritabella;
		gui.apriheadertabella;
		gui.aggiungiheadertabella(elemento => 'Data');
		gui.aggiungiheadertabella(elemento => 'Importo');
		gui.aggiungiheadertabella(elemento => 'Bonus');
		gui.chiudiheadertabella;
		for busta_paga in (
			select data, importo, bonus
			from BUSTEPAGA b
			where (b.FK_DIPENDENTE = SessionHandler.GETIDUSER(r_IdSessione))
			and ( ( trunc(b.Data) = to_date(r_data,'YYYY-MM-DD') ) or r_data is null )
			and ( b.Importo = to_number(r_importo) or r_importo is null )
			and ( b.Bonus = to_number(r_bonus) or r_bonus is null)
			order by data desc
		) loop
			gui.aggiungirigatabella;
			gui.aggiungielementotabella(elemento => busta_paga.data);
			gui.aggiungielementotabella(elemento => busta_paga.importo);
			gui.aggiungielementotabella(elemento => busta_paga.bonus);
			gui.chiudirigatabella;
		end loop;

		gui.chiuditabella();
		gui.chiudibody();

	end visualizzabustepagadipendente;

	procedure visualizzaRicarica (
		r_cliente in varchar2 default null,
		r_data    in varchar2 default null,
		r_importo in varchar2 default null
	) is
	begin
		gui.apripagina('VisualizzaRicarica');
		gui.apriformfiltro('http://131.114.73.203:8080/apex/l_bindi.OperazioniClienti.visualizzaRicarica');
		gui.aggiungicampoformfiltro(nome => 'r_Cliente', placeholder => 'Cliente');
		gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
		gui.aggiungicampoformfiltro('submit', '', 'Filtra', '');
		htp.prn('<br>');
		gui.chiudiformfiltro;

		gui.apritabella;
		gui.apriheadertabella;
		gui.aggiungiheadertabella(elemento => 'IDricarica');
		gui.aggiungiheadertabella(elemento => 'Cliente');
		gui.aggiungiheadertabella(elemento => 'Importo');
		gui.aggiungiheadertabella(elemento => 'Data');
		gui.chiudiheadertabella;
		gui.apribodytabella();
        
		for ricarica in (
			select *
            from RICARICHE
			where ( RICARICHE.FK_cliente = r_cliente or r_cliente is null )
			and ( ( trunc(RICARICHE.Data) = to_date(r_data,'YYYY-MM-DD') ) or r_data is null )
			and ( RICARICHE.Importo = to_number(r_importo) or r_importo is null )
		) loop
			gui.aggiungirigatabella;
			gui.aggiungielementotabella(elemento => ricarica.idricarica);
			gui.aggiungielementotabella(elemento => ricarica.fk_cliente);
			gui.aggiungielementotabella(elemento => ricarica.importo);
			gui.aggiungielementotabella(elemento => ricarica.data);
			gui.aggiungipulsanteintabella('.','.');
			gui.chiudirigatabella;
		end loop;

		gui.chiuditabella();
		gui.chiudibody();
	end visualizzaricarica;


	procedure visualizzaRicaricheCliente (
        r_IdSessione in varchar2 default null,
		r_data    in varchar2 default null,
		r_importo in varchar2 default null
	) is
	begin

        gui.apripagina('VisualizzaRicaricheCliente');
		gui.apriformfiltro('http://131.114.73.203:8080/apex/l_bindi.OperazioniClienti.visualizzaRicaricheCliente');
		htp.prn('<input type = "hidden" name = "r_IdSessione" value="'||r_IdSessione||'">');
		gui.aggiungicampoformfiltro(nome => 'r_Importo', placeholder => 'Importo');
		gui.aggiungicampoformfiltro(tipo => 'date', nome => 'r_Data', placeholder => 'Data');
        gui.aggiungicampoformfiltro('submit', '', 'Filtra', '');
		htp.prn('<br>');
		gui.chiudiformfiltro;

		gui.apritabella;
		gui.apriheadertabella;
        gui.aggiungiheadertabella(elemento => 'Identificativo');
		gui.aggiungiheadertabella(elemento => 'Importo');
		gui.aggiungiheadertabella(elemento => 'Data');
		gui.chiudiheadertabella;
        gui.apribodytabella();

		for ricarica in (
			select IDricarica, Importo, Data
			from RICARICHE r
			where (r.FK_cliente = SessionHandler.GETIDUSER(r_IdSessione))
            and ( ( trunc(r.Data) = to_date(r_data,'YYYY-MM-DD') ) or r_data is null )
			and ( r.Importo = to_number(r_importo) or r_importo is null )
			order by data desc
		) loop
			gui.aggiungirigatabella;
			gui.aggiungielementotabella(elemento => ricarica.IDricarica);
			gui.aggiungielementotabella(elemento => ricarica.Importo);
			gui.aggiungielementotabella(elemento => ricarica.Data);
			gui.chiudirigatabella;
		end loop;

        gui.chiuditabella();
		gui.chiudibody();
	end visualizzaricarichecliente;

	procedure visualizzazioneclienti is
    /*DECLARE

    TYPE array_di_stringhe IS VARRAY(10) OF VARCHAR2(100);
    */
	begin
		gui.apripagina;
		gui.apritabella;
		gui.apriheadertabella;
		gui.aggiungiheadertabella(elemento => 'IDCliente');
		gui.aggiungiheadertabella(elemento => 'Nome');
		gui.aggiungiheadertabella(elemento => 'Cognome');
		gui.aggiungiheadertabella(elemento => 'DataNascita');
		gui.aggiungiheadertabella(elemento => 'Sesso');
		gui.aggiungiheadertabella(elemento => 'NTelefono');
		gui.aggiungiheadertabella(elemento => 'Email');
		gui.aggiungiheadertabella(elemento => 'Stato');
		gui.aggiungiheadertabella(elemento => 'Saldo');
		gui.chiudiheadertabella;
		for clienti in (
			select idcliente,
			       nome,
			       cognome,
			       datanascita,
			       sesso,
			       ntelefono,
			       email,
			       stato,
			       saldo
			  from clienti
		) loop
			gui.aggiungirigatabella;
			gui.aggiungielementotabella(elemento => clienti.idcliente);
			gui.aggiungielementotabella(elemento => clienti.nome);
			gui.aggiungielementotabella(elemento => clienti.cognome);
			gui.aggiungielementotabella(elemento => clienti.datanascita);
			gui.aggiungielementotabella(elemento => clienti.sesso);
			gui.aggiungielementotabella(elemento => clienti.ntelefono);
			gui.aggiungielementotabella(elemento => clienti.email);
			gui.aggiungielementotabella(elemento => clienti.stato);
			gui.aggiungielementotabella(elemento => clienti.saldo);
			gui.chiudirigatabella;
		end loop;

	end visualizzazioneclienti;

	procedure visualizzazioneconvenzioni is
	begin
		gui.apripagina;
		htp.prn('<br>');
		gui.apriformfiltro(azione => 'GET'); 

   /*gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataInizio', placeholder => 'Data-inizio'); 
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'DataFine', placeholder => 'Data-fine');  
   gui.AGGIUNGICAMPOFORMFILTRO (nome => 'Submit', tipo => 'submit', value => 'Filtra');
    */
		gui.chiudiformfiltro;
		htp.prn('<br>');
		gui.apritabella;
		gui.apriheadertabella;
		gui.aggiungiheadertabella(elemento => 'IDConvenzione');
		gui.aggiungiheadertabella(elemento => 'Nome');
		gui.aggiungiheadertabella(elemento => 'Ente');
		gui.aggiungiheadertabella(elemento => 'Sconto');
		gui.aggiungiheadertabella(elemento => 'CodiceAccesso');
		gui.aggiungiheadertabella(elemento => 'DataInizio');
		gui.aggiungiheadertabella(elemento => 'DataFine');
		gui.aggiungiheadertabella(elemento => 'Cumulabile');
		gui.chiudiheadertabella;
		for convenzioni in (
			select idconvenzione,
			       nome,
			       ente,
			       sconto,
			       codiceaccesso,
			       datainizio,
			       datafine,
			       cumulabile
			  from convenzioni
		) loop
			gui.aggiungirigatabella;
			gui.aggiungielementotabella(elemento => convenzioni.idconvenzione);
			gui.aggiungielementotabella(elemento => convenzioni.nome);
			gui.aggiungielementotabella(elemento => convenzioni.ente);
			gui.aggiungielementotabella(elemento => convenzioni.sconto);
			gui.aggiungielementotabella(elemento => convenzioni.codiceaccesso);
			gui.aggiungielementotabella(elemento => convenzioni.datainizio);
			gui.aggiungielementotabella(elemento => convenzioni.datafine);
			gui.aggiungielementotabella(elemento => convenzioni.cumulabile);
			gui.chiudirigatabella;
		end loop;

	end visualizzazioneconvenzioni;


end operazioniclienti;