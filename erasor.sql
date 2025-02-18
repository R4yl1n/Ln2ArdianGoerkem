
USE ERP
GO
CREATE PROCEDURE usp_DropDatabase
    @DatabaseName NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @KillCommand NVARCHAR(MAX);
    DECLARE @Sql NVARCHAR(MAX);

    -- Initialize the command to kill active connections
    SET @KillCommand = '';

    -- Build the kill command for each active connection, excluding the current session
    SELECT @KillCommand = @KillCommand + 'KILL ' + CONVERT(NVARCHAR(10), session_id) + ';'
    FROM sys.dm_exec_sessions
    WHERE database_id = DB_ID(@DatabaseName) AND session_id <> @@SPID;

    -- Execute the kill commands
    EXEC sp_executesql @KillCommand;

    -- Drop the database
    SET @Sql = N'DROP DATABASE IF EXISTS [' + @DatabaseName + ']';
    EXEC sp_executesql @Sql;
END

GO

/*
Anlegen der grundsätzlichen Datenbankobjekte (Datenbank, Schema)
*/

-- Ausführen der Helper Stored Procedure um die Datenbank zu löschen
EXEC usp_DropDatabase 'dwh'

CREATE DATABASE dwh COLLATE SQL_Latin1_General_CP1_CI_AS; -- Gleiche Collation wie die ERP Datenbank
