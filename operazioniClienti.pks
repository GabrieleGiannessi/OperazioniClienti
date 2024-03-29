create or replace PACKAGE operazioniClienti as

procedure registrazioneCliente; 
procedure visualizzaBustePaga; 
procedure visualizzaBustePagaDipendente(IDDipendente NUMBER); 
procedure visualizzaRicarica(r_Cliente in varchar2 default null, r_Data in varchar2 default null, r_Importo in varchar2 default null); 
procedure visualizzaRicaricheCliente(IDcliente NUMBER); 
procedure visualizzazioneClienti;
procedure visualizzazioneConvenzioni (DataInizio VARCHAR2 DEFAULT NULL,
    DataFine VARCHAR2 DEFAULT NULL, 
    Ente VARCHAR2 DEFAULT NULL);

end operazioniClienti; 