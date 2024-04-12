create or replace PACKAGE BODY SessionHandler AS
   function getRuolo( idSess IN int)
       RETURN varchar
       IS
        ruoloIdSess Ruoli.Ruolo%TYPE;
        CURSOR c_ruolo IS
            SELECT Ruoli.Ruolo
            FROM Ruoli
            WHERE Ruoli.idRuolo = (
                SELECT Sessioni.Ruolo
                FROM Sessioni
                WHERE Sessioni.IDSessione = idSess
        );
    BEGIN
        OPEN c_ruolo;
        FETCH c_ruolo INTO ruoloIdSess;

        IF c_ruolo%FOUND THEN
            CLOSE c_ruolo;
            RETURN ruoloIdSess;
        ELSE
            CLOSE c_ruolo;
            RETURN NULL;
        END IF;
    END getRuolo;

    function getIDuser(idSess IN int)
       RETURN int
       IS idUser SESSIONI.IDSessione%type;
       CURSOR c_IDuser IS SELECT sessioni.IDUtente into idUser from SESSIONI WHERE SESSIONI.IDSESSIONE=idSess;
    begin
        OPEN c_IDuser;
        FETCH c_IDuser INTO idUser;

        IF c_IDuser%FOUND THEN
            CLOSE c_IDuser;
            RETURN idUser;
        ELSE
            CLOSE c_IDuser;
            RETURN NULL;
        END IF;
    end getIDuser;
    function checkRuolo( idSess IN int, ruolo in varchar2) return boolean
       IS ruoloIdSess Varchar2(20);
    begin
        ruoloIdSess:=SessionHandler.GETRUOLO(idSess);
        return lower(ruolo)=lower(ruoloIdSess);
    end checkRuolo;
end SessionHandler;