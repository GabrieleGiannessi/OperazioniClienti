create or replace PACKAGE SessionHandler AS
       function getRuolo( idSess IN int) return varchar;
           /*
            idSess esiste-> varchar con ruolo(Ruolo)
            IdSess non esiste-> null
            */
       function getIDuser( idSess IN int) return int;
            /*
            idSess esiste-> int con ID dell'utente
            IdSess non esiste-> null
            */
       function checkRuolo( idSess IN int, ruolo in varchar2) return boolean;
           /*
            ruolo corrisponde a IdSess-> true
            ruolo non corrisponde a idSess-> false
            */
end SessionHandler;