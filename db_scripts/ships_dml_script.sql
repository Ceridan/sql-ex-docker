create database dml_ships
go
use dml_ships
GO
PRINT N'Recreating the objects for the database'
--Drop all FKs in the database
declare @table_name sysname, @constraint_name sysname
declare i cursor static for 
select c.table_name, a.constraint_name
from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS a join INFORMATION_SCHEMA.KEY_COLUMN_USAGE b
on a.unique_constraint_name=b.constraint_name join INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
on a.constraint_name=c.constraint_name
WHERE upper(c.table_name) in (upper('Battles'),upper('Classes'),upper('Ships'),upper('Outcomes'))
open i
fetch next from i into @table_name,@constraint_name
while @@fetch_status=0
begin
	exec('ALTER TABLE '+@table_name+' DROP CONSTRAINT '+@constraint_name)
	fetch next from i into @table_name,@constraint_name
end
close i
deallocate i
GO
--Drop all tables
declare @object_name sysname, @sql varchar(8000)
declare i cursor static for 
SELECT table_name from INFORMATION_SCHEMA.TABLES
where upper(table_name) in (upper('Battles'),upper('Classes'),upper('Ships'),upper('Outcomes'))

open i
fetch next from i into @object_name
while @@fetch_status=0
begin
	set @sql='DROP TABLE [dbo].['+@object_name+']'
	exec(@sql)
	fetch next from i into @object_name
end
close i
deallocate i
GO
CREATE TABLE [Battles] (
	[name] [varchar] (20) NOT NULL ,
	[date] [datetime] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [Classes] (
	[class] [varchar] (20) NOT NULL ,
	[type] [varchar] (2) NOT NULL ,
	[country] [varchar] (20) NOT NULL ,
	[numGuns] [tinyint] NULL ,
	[bore] [real] NULL ,
	[displacement] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Ships] (
	[name] [varchar] (20) NOT NULL ,
	[class] [varchar] (20) NOT NULL ,
	[launched] [smallint] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Outcomes] (
	[ship] [varchar] (20) NOT NULL ,
	[battle] [varchar] (20) NOT NULL ,
	[result] [varchar] (10) NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Battles] ADD 
	CONSTRAINT [PK_Battles] PRIMARY KEY  CLUSTERED 
	(
		[name]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Classes] ADD 
	CONSTRAINT [PK_Classes] PRIMARY KEY  CLUSTERED 
	(
		[class]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Ships] ADD 
	CONSTRAINT [PK_Ships] PRIMARY KEY  CLUSTERED 
	(
		[name]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Outcomes] ADD 
	CONSTRAINT [PK_Outcomes] PRIMARY KEY  CLUSTERED 
	(
		[ship],
		[battle]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Ships] ADD 
	CONSTRAINT [FK_Ships_Classes] FOREIGN KEY 
	(
		[class]
	) REFERENCES [dbo].[Classes] (
		[class]
	) NOT FOR REPLICATION 
GO

ALTER TABLE [dbo].[Outcomes] ADD 
	CONSTRAINT [FK_Outcomes_Battles] FOREIGN KEY 
	(
		[battle]
	) REFERENCES [dbo].[Battles] (
		[name]
	)
GO
                                                                                                                                                                                                                                                               
----Classes------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
insert into Classes values('Bismarck','bb','Germany',8,15,42000)
insert into Classes values('Iowa','bb','USA',9,16,46000)
insert into Classes values('Kongo','bc','Japan',8,14,32000)
insert into Classes values('North Carolina','bb','USA',12,16,37000)
insert into Classes values('Renown','bc','Gt.Britain',6,15,32000)
insert into Classes values('Revenge','bb','Gt.Britain',8,15,29000)
insert into Classes values('Tennessee','bb','USA',12,14,32000)
insert into Classes values('Yamato','bb','Japan',9,18,65000)

GO

                                                                                                                                                                                                                                                                 
----Battles------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
insert into battles values('Guadalcanal','19421115 00:00:00.000')
insert into battles values('North Atlantic','19410525 00:00:00.000')
insert into battles values('North Cape','19431226 00:00:00.000')
insert into battles values('Surigao Strait','19441025 00:00:00.000')
insert into battles values('Unreal Battle','19450128 00:00:00.000')

GO

                                                                                                                                                                                                                                                                 
----Ships------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
insert into ships values('California','Tennessee',1921)
insert into ships values('Haruna','Kongo',1916)
insert into ships values('Hiei','Kongo',1914)
insert into ships values('Iowa','Iowa',1943)
insert into ships values('Kirishima','Kongo',1915)
insert into ships values('Kongo','Kongo',1913)
insert into ships values('Missouri','Iowa',1944)
insert into ships values('Musashi','Yamato',1942)
insert into ships values('New   Jersey','Iowa',1943)
insert into ships values('North Carolina','North Carolina',1941)
insert into ships values('Ramillies','Revenge',1917)
insert into ships values('Renown','Renown',1916)
insert into ships values('Repulse','Renown',1916)
insert into ships values('Resolution','Renown',1916)
insert into ships values('Revenge','Revenge',1916)
insert into ships values('Royal Oak','Revenge',1916)
insert into ships values('Royal Sovereign','Revenge',1916)
insert into ships values('Tennessee','Tennessee',1920)
insert into ships values('Washington','North Carolina',1941)
insert into ships values('Wisconsin','Iowa',1944)
insert into ships values('Yamato','Yamato',1941)
GO

                                                                                                                                                                                                                                                                 
----Outcomes------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
insert into Outcomes values('Bismarck','North Atlantic','sunk')
insert into Outcomes values('California','Surigao Strait','ok')
insert into Outcomes values('Duke of York','North Cape','ok')
insert into Outcomes values('Fuso','Surigao Strait','sunk')
insert into Outcomes values('Hood','North Atlantic','sunk')
insert into Outcomes values('King George V','North Atlantic','ok')
insert into Outcomes values('Kirishima','Guadalcanal','sunk')
insert into Outcomes values('Prince of Wales','North Atlantic','damaged')
insert into Outcomes values('Rodney','North Atlantic','OK')
insert into Outcomes values('Schamhorst','North Cape','sunk')
insert into Outcomes values('South Dakota','Guadalcanal','damaged')
insert into Outcomes values('Tennessee','Surigao Strait','ok')
insert into Outcomes values('Washington','Guadalcanal','ok')
insert into Outcomes values('West Virginia','Surigao Strait','ok')
insert into Outcomes values('Yamashiro','Surigao Strait','sunk')
GO

