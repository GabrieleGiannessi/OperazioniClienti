create or replace PACKAGE operazioniClienti as

procedure registrazioneCliente; 
procedure visualizzaBustePaga; 
procedure visualizzaBustePagaDipendente(IDDipendente NUMBER); 
procedure visualizzaRicarica; 
procedure visualizzaRicaricheCliente(IDcliente NUMBER); 
procedure visualizzazioneClienti;
procedure visualizzazioneConvenzioni (DataInizio VARCHAR2 DEFAULT NULL,
    DataFine VARCHAR2 DEFAULT NULL, 
    Ente VARCHAR2 DEFAULT NULL);

end operazioniClienti; 