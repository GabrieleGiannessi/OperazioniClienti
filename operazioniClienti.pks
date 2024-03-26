create or replace PACKAGE operazioniClienti as

procedure visualizzaBustePaga; 
procedure visualizzaBustePagaDipendente(IDDipendente NUMBER); 
procedure visualizzaRicarica; 
procedure visualizzaRicaricheCliente(IDcliente NUMBER); 
procedure visualizzazioneClienti;
procedure visualizzazioneConvenzioni;  

end operazioniClienti; 