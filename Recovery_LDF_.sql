
--Script Created on 2014 Feb 28
--Script Created by Rajesh Prajapati
--Purpose : To delete the log file when scrub is running on the server
--NOTE: THIS TEMPLATE IS 


---------------------------------------SCRUB SECTION START----------------------------------------
BEGIN TRANSACTION T1
----------------------------------------PASTE YOUR SCRUB HERE---------------------------------------





----------------------------------------------------------------------------------------------------
COMMIT TRANSACTION T1
---------------------------------------SCRUB SECTION END----------------------------------------

DECLARE @databaselogfile varchar(max),@databasemdffile varchar(max)
Declare @databaseName VARCHAR(255)
set @databaseName='old_p'

--LDF FILE
SELECT @databaselogfile=physical_name FROM sys.master_files
				WHERE database_id
				IN
					(
						SELECT database_id FROM sys.databases
						WHERE name =@databaseName
					)
				AND type_desc='LOG'
		
--MDF FILE
				SELECT @databasemdffile=physical_name FROM sys.master_files
				WHERE database_id
				IN
					(
						SELECT database_id FROM sys.databases
						WHERE name =@databaseName
					)
				AND type_desc='ROWS'


exec ('alter database '+ @databaseName +' set single_user with rollback immediate')
			--go
			use master
			--go
			exec sp_detach_db @databaseName
			--GO
			PRINT 'Database Dettached successfully'
			

		DECLARE @name VARCHAR(MAX)
		SET @name='EXECUTE master.dbo.xp_cmdshell ''del '+@databaselogfile+''''
		EXEC(@name) 
		PRINT 'Database Log File deleted successfully'
		EXEC SP_ATTACH_DB @databaseName,@databasemdffile
		PRINT 'Database attached successfully'