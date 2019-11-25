USE [ODS]
GO

/****** Object:  StoredProcedure [dbo].[MerlinStaging]    Script Date: 11/25/2019 3:30:24 PM ******/
DROP PROCEDURE [dbo].[MerlinStaging]
GO

/****** Object:  StoredProcedure [dbo].[MerlinStaging]    Script Date: 11/25/2019 3:30:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[MerlinStaging]
(
@InvoiceNumber NVARCHAR(50)
,@UseFileDate DATE
,@FileDate DATE
,@Partner NVARCHAR(50)
)

AS




DECLARE @BeginDate AS DATE 
DECLARE @EndDate AS DATE 
SET @BeginDate = CAST(CONCAT(YEAR(@FileDate),'-', MONTH(@FileDate),'-01') AS DATE)
SET @EndDate   = EOMONTH(@FileDate) 

 



DECLARE
	@Counter INT
SET
	@Counter   = CASE 
				    WHEN @Partner = 'SoundCloud'			
				    THEN 1
					WHEN @Partner = 'Pandora'			
				    THEN 2
					WHEN @Partner = 'Spotify'			
				    THEN 3
					WHEN @Partner = 'Youtube'			
				    THEN 4
					WHEN @Partner = 'Slacker'			
				    THEN 5
					WHEN @Partner = 'AWA'			
					THEN 6
					WHEN @Partner = 'KKBOX'			
				    THEN 7
					WHEN @Partner = 'iHeart'			
					THEN 8
					WHEN @Partner = 'Deezer'				
					THEN 9
					WHEN @Partner = 'Google'			
					THEN 10
					WHEN @Partner = 'Alibaba'				 
					THEN 11
					WHEN @Partner = 'UMA'				 
					THEN 12
					WHEN @Partner = 'Tencent'				 
					THEN 13
			   END

IF @Counter = 1
	GOTO SoundCloud

IF @Counter = 2 
	GOTO Pandora

IF @Counter = 3 
	GOTO Spotify

IF @Counter = 4 
	GOTO Youtube

IF @Counter = 5 
	GOTO Slacker

IF @Counter = 6
	GOTO AWA

IF @Counter = 7
	GOTO KKBOX

IF @Counter = 8
	GOTO iHeart

IF @Counter = 9
	GOTO Deezer

IF @Counter = 10
	GOTO Google

IF @Counter = 11
	GOTO Alibaba

IF @Counter = 12
	GOTO UMA

IF @Counter = 13
	GOTO Tencent


--Windup Merlin Staging TMP Tables--
 



--hopefully this will help with formatting all these fucking different types of files
--After import use the main script for ODS Formatting

--******************************************************************************************************************
SoundCloud:


--change dates by reporting period
INSERT INTO 
       ods.[dbo].[Windup_MerlinRoyalties]
              (
                     [ISRC]
                     ,[Artist]
                     ,[Title] 
                     ,[Album] 
                     ,[UPC]
                     ,[UPC2] 
                     ,[Country] 
                     ,[Nbofplays] 
                     ,[Royalties] 
                     ,[CurrencyExchange]
                     ,[TOTAL]  
                     ,[Service]  
                     ,[Provider] 
                     ,[Label] 
                     ,[FileDate]
					 ,[LabelID] 
                     ,[Filename]  
                     ,[distributorid]  
                     ,[InvoiceGroup] 
                     ,[Invoice] 
                     ,[Send2Sales] 
                     ,[Use_filedate] 
                     ,[formattypeid] 
                     ,[InvoiceNumber]
              )
select 
       ISRC
       ,[Artist name]
       ,[Track NAme]
       ,[album title]
       ,UPC
       ,UPc
       ,Territory
       ,[total plays]
       ,[TOtal revenue]
       ,1
       ,[total revenue]
       ,[monetisation type]
       ,[Partner name]
       ,[label name]
       ,@FileDate 
       ,@Partner
       ,filename
       ,'65'
       ,@Partner
       ,'Y'
       ,'Y'
       ,@UseFileDate
       ,'2'
       ,InvoiceNumber
              from   ods.dbo.MerlinWindup_SoundCloudTMP 
			  where 
			  [use_filedate ] = @UseFileDate
			  AND filedate = @FileDate
			  AND InvoiceNumber = @InvoiceNumber

GOTO InvoiceCheck


--*************************************************************************************************************************              
Spotify:


--import
INSERT INTO 
       ods.[dbo].[Windup_MerlinRoyalties]
              (
                     [Start Report]
                     ,[End Report]
                     ,[ISRC]
                     ,[Artist]
                     ,[Title] 
                     ,[Album] 
                     ,[UPC]
                     ,[UPC2] 
                     ,[Country] 
                     ,[Nbofplays] 
                     ,[Royalties] 
                     ,[CurrencyExchange]
                     ,[TOTAL]    
                     ,[Provider] 
                     ,[Label] 
                     ,[FileDate]
					 ,[LabelID] 
                     ,[Filename]  
                     ,[distributorid]  
                     ,[InvoiceGroup] 
                     ,[Invoice] 
                     ,[Send2Sales] 
                     ,[Use_filedate] 
                     ,[formattypeid] 
                     ,[InvoiceNumber]
              )
select 
       @BeginDate
       ,@EndDate
       ,ISRC
       ,[Artist name]
       ,[Track NAme]
       ,[album name]
       ,case when UPC1 is null then EAN else UPC1 end
       ,case when UPC1 is null then EAN else UPC1 end
       ,Country
       ,[Quantity]
       ,[USD Payable]
       ,1
       ,[USD Payable]
       ,[recipient]
       ,[label]
       ,@FileDate
       ,@Partner
       ,filename
       ,'65'
       ,@Partner
       ,'Y'
       ,'Y'
       ,use_filedate
       ,'2'
       ,@InvoiceNumber
from   
       ods.dbo.MerlinWindup_SpotifyTMP
where 
use_filedate = @UseFileDate
AND FILEDATE = @FileDate
--and invoicenumbeR = @InvoiceNumber
GOTO InvoiceCheck


--*************************************************************************************************************************              
Pandora:


--change dates by reporting period
INSERT INTO 
       ods.[dbo].[Windup_MerlinRoyalties]
              (
                     [Start Report]
                     ,[End Report]
                     ,[ISRC]
                     ,[Artist]
                     ,[Title] 
                     ,[Album] 
                     ,[UPC]
                     ,[UPC2] 
                     ,[Country] 
                     ,[Nbofplays] 
                     ,[Royalties] 
                     ,[CurrencyExchange]
                     ,[TOTAL]  
                     ,[Service]  
                     ,[Provider] 
                     ,[Label] 
                     ,[FileDate]
                     ,[LabelID] 
                     ,[Filename]  
                     ,[distributorid]  
                     ,[InvoiceGroup] 
                     ,[Invoice] 
                     ,[Send2Sales] 
                     ,[Use_filedate] 
                     ,[formattypeid] 
                     ,[InvoiceNumber]
              )
select 
       @BeginDate
       ,@EndDate
       ,ISRC
       ,[contributors]
       ,[Releasetitle]
       ,releasetitle
       ,UPC1
       ,UPc1
       ,territorycode
       ,[Numberofconsumersalesgross]
       ,[effectiveroyaltyrate]
       ,1
       ,[effectiveroyaltyrate]
       ,PlanNAme
       ,@Partner
       ,Member
       ,@FileDate 
       ,labelname
       ,Filename
       ,'65'
       ,@Partner
       ,'Y'
       ,'Y'
       ,use_Filedate 
       ,'2'
       ,@invoiceNumber
from   
       ods.dbo.MerlinWindup_PandoraTMP
where 
		use_filedate = @UseFileDate
		AND [FILEDATE ] = @FileDate
		--and invoicenumber = @InvoiceNumber

GOTO InvoiceCheck

--*************************************************************************************************************************              


Youtube:

--forget this shit
--alter table ods.dbo.MerlinWindup_YoutubeTMP add usefiledate date salesdate  date  Recordseq  int IDENTITY (12261551,1)
--select max(recordseq) from windup_merlinroyalties 



--select sum([partner revenue]), count(*) from ods.dbo.MerlinWindup_YoutubeTMP where filename ='YouTube_Wind_Up_M_20190501_20190531_red_label_rawdata_asset_v1-1'
--select sum([partner revenue]), count(*) from ods.dbo.MerlinWindup_YoutubeTMP where filename ='YouTube_Wind_Up_M_20190501_20190531_rev_views_by_asset_v1-0'



--update ods.dbo.MerlinWindup_youtubeTMP
--set usefiledate ='2018-02-15',zzzzz
--filedate ='2017-11-15'

--change dates by reporting period
INSERT INTO ods.[dbo].[Windup_MerlinRoyalties]
           ([Start Report], [End Report],[ISRC],[Artist],[Title]  
		   ,[UPC]
		   ,[UPC2] 
		   ,[Country] ,[Nbofplays] ,[Royalties] ,[CurrencyExchange],[TOTAL]  ,[Service]  ,[Provider] ,[Label] ,[FileDate]
           ,[LabelID] ,[Filename]  ,[distributorid]  ,[InvoiceGroup] ,[Invoice] ,[Send2Sales]  ,[Use_filedate] ,[formattypeid] ,[InvoiceNumber])
		   
		      select cast(concat(year(@FileDate),'-', month(@FileDate),'-01') as date), eomonth(@FileDate) ,ISRC,ARtist,[asset title]
			  ,CAST(CAST([UPC] AS BIGINT) AS NVARCHAR(255))
			  ,case when len(CAST(CAST([UPC] AS BIGINT) AS NVARCHAR(255))) = 11 then '0'+CAST(CAST([UPC] AS BIGINT) AS NVARCHAR(255)) else CAST(CAST([UPC] AS BIGINT) AS NVARCHAR(255)) end
			  ,Country,[owned views],[Partner revenue],1,[Partner revenue],'Video', 'Youtube',  'Windup',       
		  filedate, @Partner ,Filename,'65',@Partner,'Y','Y', @useFiledate ,'2',@invoiceNumber
		from   ods.dbo.MerlinWindup_YoutubeTMP --where usefiledate =  '2019-06-15' and filename  in ('YouTube_Wind_Up_M_20190501_20190531_red_label_rawdata_asset_v1-1', 'YouTube_Wind_Up_M_20190501_20190531_rev_views_by_asset_v1-0')
where 
usefiledate = @UseFileDate
AND [filedate ] = @FileDate
--and invoicenumber = @InvoiceNumber

GOTO InvoiceCheck

--update Windup_MerlinRoyalties
--set invoicenumber = 'WUEUS-2019-52001'
--WHERE FileDate = '2019-04-15'
--AND Filename in ('YouTube_Wind_Up_M_20190501_20190531_red_label_rawdata_asset_v1-1', 'YouTube_Wind_Up_M_20190501_20190531_rev_views_by_asset_v1-0')




/*
delete  from windup_merlinroyalties 
where use_filedate ='2018-02-15'
and invoicegroup = 'youtube'


select * from  windup_merlinroyalties 
where use_filedate != '2018-02-15'

delete from   windup_merlinroyalties 

where use_filedate = '2018-03-15'
and filename ='concord-music-group-inc_2017-11-01_2017-12-01_statement'
*/


/**********************************************************/

Slacker:

--alter table ods.dbo.MerlinWindup_SlackerTMP add upc2 varchar (20)  Recordseq  int IDENTITY (12261551,1)

--select * from ods.dbo.MerlinWindup_SlackerTMP


--update a
--set a.upc2 = b.upc
--from  ods.dbo.merlinwindup_slackertmp a 
--join sales.dbo.TrackAlbumMapping_unionAcquisition b on a.isrc = b.isrc 

--

--alter table [Windup_MerlinRoyalties] add salesdate date

--change dates 
INSERT INTO ods.[dbo].[Windup_MerlinRoyalties]
               ([Start Report] ,[End Report] ,[ISRC] ,[Artist] ,[Title]  ,[UPC],[UPC2] ,[Country],[Nbofplays],[Royalties],[CurrencyExchange]
           ,[TOTAL] ,[Service] ,[Provider] ,[Label],[FileDate],[LabelID] ,[Filename] ,[distributorid]
           ,[InvoiceGroup],[Invoice],[Send2Sales],[Use_filedate],[formattypeid] ,[InvoiceNumber])
		   
		      select @BeginDate,@EndDate,ISRC, [ARtist name],[Track Name], [EAN UPC], [UPC2],[country of transaction],[Number of transactions],  [Net Royalty Total],1,
			  [Net Royalty Total], [play type],label,[sub label], @FileDate, @Partner,filename,'65',@Partner,'Y','Y', @useFiledate ,'2',@invoiceNumber
		from   ods.dbo.MerlinWindup_SlackerTMP 
where 
use_filedate = @UseFileDate
AND FILEDATE = @FileDate
--and invoicenumber = @InvoiceNumber

GOTO InvoiceCheck


--select sum(Total),  InvoiceGroup,use_filedate 
--from windup_merlinroyalties 
--where invoicenumber= 'CONUS-2019-55316' 
--group by invoicegroup, use_filedate


--select *--sum([Net Royalty Total]) 
--from MerlinWindup_SlackerTMP 
--where use_filedate ='2018-03-15'



--*************************************************************************************************************************              
AWA:

--change dates 
INSERT INTO 
       ods.[dbo].[Windup_MerlinRoyalties]
              (
                     [Start Report] 
                     ,[End Report] 
                     ,[ISRC] 
                     ,[Artist] 
                     ,[Title]  
                     ,[UPC]
                     ,[UPC2] 
                     ,[Country]
                     ,[Nbofplays]
                     ,[Royalties]
                     ,[CurrencyExchange]
            ,[TOTAL] 
                     ,[Service] 
                     ,[Provider] 
                     ,[Label]
                     ,[FileDate]
                     ,[LabelID] 
                     ,[Filename] 
                     ,[distributorid]
            ,[InvoiceGroup]
                     ,[Invoice]
                     ,[Send2Sales]
                     ,[Use_filedate]
                     ,[formattypeid] 
                     ,[InvoiceNumber]
              )
select 
       @BeginDate
       ,@EndDate
       ,ISRC_id
       ,[ARtist]
       ,[Track_title]
       ,[release_id]
       ,[Release_id]
       ,[territory_code]
       ,[quantity]
       ,[Net Royalty Total]
       ,([total in usd]/[net royalty total])
       ,[total in USD]
       ,[type]
       ,label_id
       ,[Member_ID]
       ,filedate
       ,'AWA'
       ,filename
       ,'65'
       ,'AWA'
       ,'Y'
       ,'Y'
       ,use_Filedate 
       ,'2'
       ,@invoiceNumber
from   
       ods.dbo.MerlinWindup_AWATMP 
where 
[use_filedate ] = @UseFileDate
AND FILEDATE = @FileDate
--and invoicenumber = @InvoiceNumber
GOTO InvoiceCheck

--*************************************************************************************************************************              
KKBOX:

--change dates 
INSERT INTO 
       ods.[dbo].[Windup_MerlinRoyalties]
              (
                     [Start Report] 
                     ,[End Report] 
                     ,[ISRC] 
                     ,[Artist] 
                     ,[Title]  
                     ,[UPC]
                     ,[UPC2] 
                     ,[Country]
                     ,[Nbofplays]
                     ,[Royalties]
                     ,[CurrencyExchange]
                     ,[TOTAL] 
                     ,[Service] 
                     ,[Provider] 
                     ,[Label]
                     ,[FileDate]
                     ,[LabelID] 
                     ,[Filename] 
                     ,[distributorid]
                     ,[InvoiceGroup]
                     ,[Invoice]
                     ,[Send2Sales]
                     ,[Use_filedate]
                     ,[formattypeid] 
                     ,[InvoiceNumber]
              )
select 
       @BeginDate
       ,@EndDate
       ,ISRC
       ,[Artist name]
       ,[Track Name]
       ,[UPC]
       ,case 
              when len(upc) = 11 then '0'+upc 
              else upc 
        end
       ,[territory]
       ,[Number of Transaction]
       ,[Net Royalty Total]
       ,([USD Payable]/[Payable])
       ,[USD Payable]
       ,[Service Type]
       ,[Content Provider]
       ,Label
       ,filedate
       ,'KKBOX'
       ,filename
       ,'65'
       ,'KKBOX'
       ,'Y'
       ,'Y'
       ,@usefiledate 
       ,'2'
       ,@InvoiceNumber
from   
       ods.dbo.MerlinWindup_kkboxTMP
where 
use_filedate = @UseFileDate
AND FILEDATE = @FileDate
--and invoicenumber = @InvoiceNumber
GOTO InvoiceCheck


--***********************************************************************************************************************

iHeart:






INSERT INTO [dbo].[Windup_MerlinRoyalties]
    ([Start Report] ,[End Report],[ISRC],[Artist],[Title],[Album],[UPC],[UPC2],[Country]
    ,[Nbofplays],[Royalties],[CurrencyExchange],[TOTAL],[Service],[Provider] ,[Label]
    ,[FileDate],[LabelID],[Filename],[distributorid]
    ,[InvoiceGroup],[Invoice],[Send2Sales],[Use_filedate],[formattypeid],[InvoiceNumber])



SELECT [ReportStartDt],[ReportEndDt],[ISRC],[Artist Name],[Track Name],[Album Name],[UPC],[UPC],[Country]
	,[# Streams],[Price],1,[Price],[ProductTier],[Merlin Member],[Label Code]
	,[FileDate],'iHeart',[FileName],'65'
	,'iHeart','Y','Y',[use_filedate],'2',@InvoiceNumber
	FROM ODS.dbo.MerlinWindup_iHeartTMP 
where 
use_filedate = @UseFileDate
AND FILEDATE = @FileDate
and invoicenumber = @InvoiceNumber
GOTO InvoiceCheck


			
--select sum(Total), COUNT(*) ROWS,  InvoiceGroup,use_filedate 
--from windup_merlinroyalties 
--where invoicenumber= 'CONUS-2019-55316' 
--group by invoicegroup, use_filedate			

--select * from windup_merlinroyalties where invoicegroup = 'iHeart'


--*************************************************************************************************************************              

Deezer:



--populate temp table

INSERT INTO 
       [dbo].[Windup_MerlinRoyalties]
              (
                     [Start Report] 
                     ,[End Report]
                     ,[ISRC]
                     ,[Artist]
                     ,[Title]
                     ,[Album]
                     ,[UPC]
                     ,[UPC2]
                     ,[Country]
                     ,[Nbofplays]
                     ,[Royalties]
                     ,[TOTAL]
                     ,[Service]
                     ,[Provider] 
                     ,[Label]
                     ,[FileDate]
                     ,[LabelID]
                     ,[Filename]
                     ,[distributorid]
                     ,[InvoiceGroup]
                     ,[Invoice]
                     ,[Send2Sales]
                     ,[Use_filedate]
                     ,[formattypeid]
                     ,[InvoiceNumber]
              )



SELECT 
       @BeginDate 
       ,@EndDate
       ,[ISRC]
       ,[Artist]
       ,[Title]
       ,[Album]
       ,[UPC]
       ,case 
              when len([UPC]) = 11 then '0'+[UPC] 
              else [UPC] 
        end
       ,[Country]
       ,[Nb of plays]
       ,[Royalties]
       ,[Royalties]
       ,[Service]
       ,[Provider] 
       ,[Label]
       ,[FileDate]
       ,'Deezer'
       ,[FileName]
       ,'65'
       ,'Deezer'
       ,'Y'
       ,'Y'
       ,[use_filedate]
       ,'2'
       ,@InvoiceNumber
FROM 
       ODS.dbo.MerlinWindup_DeezerTMP 
where 
use_filedate = @UseFileDate
AND FILEDATE = @FileDate
and invoicenumber = @InvoiceNumber

	UPDATE  
		A SET A.CURRENCYEXCHANGE = B.XRATE 
	FROM 
		ODS.DBO.WINDUP_MERLINROYALTIES A 
		JOIN SALES.DBO.CURRENCYEXCHANGERATES B ON YEAR(A.FILEDATE)= YEAR(B.ASOFDATE) AND   MONTH(A.FILEDATE) = MONTH(B.ASOFDATE) 
	WHERE 
		use_filedate = @UseFileDate
		AND FILEDATE = @FileDate
		and invoicenumber = @InvoiceNumber
		and InvoiceGroup = 'Deezer'
		AND B.CURRENCYCODEID = 4

	UPDATE 
		WINDUP_MERLINROYALTIES
	SET 
		TOTAL = CASE WHEN CURRENCYEXCHANGE IS NULL THEN ROYALTIES ELSE  CURRENCYEXCHANGE * ROYALTIES END 
	WHERE 
		use_filedate = @UseFileDate
		AND FILEDATE = @FileDate
		and invoicenumber = @InvoiceNumber
		and InvoiceGroup = 'Deezer'

GOTO InvoiceCheck





--*************************************************************************************************************************              
Google: 

--populate temp table
INSERT INTO 
       [dbo].[Windup_MerlinRoyalties]
              (
                     [Start Report] 
                     ,[End Report]
                     ,[ISRC]
                     ,[Artist]
                     ,[Title]
                     ,[Album]
                     ,[UPC]
                     ,[UPC2]
                     ,[Country]
                     ,[Nbofplays]
                     ,[Royalties]
                     ,[TOTAL]
                     ,[Service]
                     ,[Provider] 
                     ,[Label]
                     ,[FileDate]
                     ,[LabelID]
                     ,[Filename]
                     ,[distributorid]
                     ,[InvoiceGroup]
                     ,[Invoice]
                     ,[Send2Sales]
                     ,[Use_filedate]
                     ,[formattypeid]
                     ,[InvoiceNumber]
              )

SELECT 
       @BeginDate 
       ,@EndDate
       ,[ISRC]
       ,[Artist]
       ,[Product_Title]
       ,[Container_Title]
       ,CAST(CAST([UPC] AS BIGINT) AS NVARCHAR(255))
       ,case 
              when len(CAST(CAST([UPC] AS BIGINT) AS NVARCHAR(255))) = 11 then '0'+CAST(CAST([UPC] AS BIGINT) AS NVARCHAR(255)) 
              else CAST(CAST([UPC] AS BIGINT) AS NVARCHAR(255)) 
        end
       ,[Consumer_Country]
       ,[Count]
       ,[Partner_Revenue_Invoiced]
       ,[Partner_Revenue_Invoiced]
       ,[Product_Type]
       ,[Content_Provider] 
       ,[Label]
       ,[FileDate]
       ,'Google'
       ,[FileName]
       ,'65'
	   ,'Google'
       ,'Y'
       ,'Y'
       ,[use_filedate]
       ,'2'
       ,@InvoiceNumber
FROM 
       ODS.dbo.MerlinWindup_GoogleTMP 
where 
use_filedate = @UseFileDate
AND FILEDATE = @FileDate
and invoicenumber = @InvoiceNumber

	UPDATE  
		A SET A.CURRENCYEXCHANGE = B.XRATE 
	FROM 
		ODS.DBO.WINDUP_MERLINROYALTIES A 
		JOIN SALES.DBO.CURRENCYEXCHANGERATES B ON YEAR(A.FILEDATE)= YEAR(B.ASOFDATE) AND   MONTH(A.FILEDATE) = MONTH(B.ASOFDATE) 
	WHERE 
		use_filedate = @UseFileDate
		AND FILEDATE = @FileDate
		and invoicenumber = @InvoiceNumber
		and InvoiceGroup = 'Google'
		AND B.CURRENCYCODEID = 4

	UPDATE 
		WINDUP_MERLINROYALTIES
	SET 
		TOTAL = CASE WHEN CURRENCYEXCHANGE IS NULL THEN ROYALTIES ELSE  CURRENCYEXCHANGE * ROYALTIES END 
	WHERE 
		use_filedate = @UseFileDate
		AND FILEDATE = @FileDate
		and invoicenumber = @InvoiceNumber
		and InvoiceGroup = 'Google'


GOTO InvoiceCheck
    



--select * from ODS.dbo.Windup_MerlinRoyalties where FileDate = '2019-07-15' and Use_filedate = @UseFileDate and invoicegroup = 'Google'
                     
--select 
--       sum(Total)
--       ,COUNT(*) AS ROWS
--       ,InvoiceGroup
--       ,use_filedate 
--from 
--       ODS.dbo.Windup_MerlinRoyalties 
--where 
--       invoicenumber= @InvoiceNumber 
--group by      
--       invoicegroup
--       ,use_filedate                    

--select * from Windup_MerlinRoyalties where invoicegroup = 'Google' 

/*
update 
       ods.dbo.merlinwindup_googleTMP 
set  
       partner_revenue_invoiced_currency = 'EUR' 
where 
       filename = 'GOOGLE_concord-music-group-inc_LOCKER_2019-03-01-2'
*/                   
                     
--*************************************************************************************************************************              
Alibaba:
--select 
--       sum([USD_Amount])
--       ,count(*)
--from 
--       ods.dbo.MerlinWindup_AlibabaTMP
--where
--       use_filedate = @UseFileDate
--       and filedate = '2019-05-15'

--change dates 
INSERT INTO 
       ods.[dbo].[Windup_MerlinRoyalties]
              (
                     [Start Report] 
                     ,[End Report] 
                     ,[ISRC] 
                     ,[Artist] 
                     ,[Title]  
                     ,[UPC]
                     ,[UPC2] 
                     ,[Country]
                     ,[Nbofplays]
                     ,[Royalties]
                     ,[CurrencyExchange]
                     ,[TOTAL] 
                     ,[Service] 
                     ,[Provider] 
                     ,[Label]
                     ,[FileDate]
                     ,[LabelID] 
                     ,[Filename] 
                     ,[distributorid]
                     ,[InvoiceGroup]
                     ,[Invoice]
                     ,[Send2Sales]
                     ,[Use_filedate]
                     ,[formattypeid] 
                     ,[InvoiceNumber]
              )
select 
       @BeginDate
       ,@EndDate
       ,ISRC
       ,[artist_name]
       ,[track_title]
       ,[release_id]
       ,[release_id]
       ,[country_of_sale]
       ,[quantity]
       ,[total_payable]
       ,([USD_Amount]/[total_payable])
       ,[USD_Amount]
       ,[service_type]
       ,[service]
       ,[label_name]
       ,filedate
       ,'Alibaba'
       ,filename
       ,'65'
       ,'Alibaba'
       ,'Y'
       ,'Y'
       ,use_Filedate 
       ,'2'
       ,@InvoiceNumber
from   
       ods.dbo.MerlinWindup_AlibabaTMP 
where 
use_filedate = @UseFileDate
AND FILEDATE = @FileDate
and invoicenumber = @InvoiceNumber
GOTO InvoiceCheck



--*************************************************************************************************************************
UMA:


--select 
--       sum([Total in USD])
--       ,count(*)
--from 
--       ods.dbo.MerlinWindup_UMATMP
--where
--       use_filedate = @UseFileDate

--change dates 
INSERT INTO 
       ods.[dbo].[Windup_MerlinRoyalties]
              (
                     [Start Report] 
                     ,[End Report] 
                     ,[ISRC] 
                     ,[Artist] 
                     ,[Title]  
                     ,[UPC]
                     ,[UPC2] 
                     ,[Country]
                     ,[Nbofplays]
                     ,[Royalties]
                     ,[CurrencyExchange]
                     ,[TOTAL] 
                     ,[Service] 
                     ,[Provider] 
                     ,[Label]
                     ,[FileDate]
                     ,[LabelID] 
                     ,[Filename] 
                     ,[distributorid]
            ,[InvoiceGroup]
                     ,[Invoice]
                     ,[Send2Sales]
                     ,[Use_filedate]
                     ,[formattypeid] 
                     ,[InvoiceNumber]
              )
select 
       @BeginDate
       ,@EndDate
       ,ISRC
       ,[artist]
       ,[track_title]
       ,[release_id]
       ,[release_id]
       ,[territory_code]
       ,[quantity]
       ,[Net Royalty Total]
       ,([Total in USD]/[Net Royalty Total])
       ,[Total in USD]
       ,[type]
       ,[Digital Service Code]
       ,[Label_name]
       ,filedate
       ,'UMA'
       ,filename
       ,'65'
       ,'UMA'
       ,'Y'
       ,'Y'
       ,use_Filedate 
       ,'2'
       ,@InvoiceNumber
from   
       ods.dbo.MerlinWindup_UMATMP 
where 
use_filedate = @UseFileDate
AND FILEDATE = @FileDate
and invoicenumber = @InvoiceNumber
AND [Total in USD] <> 0
GOTO InvoiceCheck

--******************************************************************************************************************
Tencent:


--select 
--       sum([USD_Amount])
--       ,count(*)
--from 
--       ods.dbo.MerlinWindup_TencentTMP
--where
--       use_filedate = @UseFileDate
       

--change dates 
INSERT INTO 
       ods.[dbo].[Windup_MerlinRoyalties]
              (
                     [Start Report] 
                     ,[End Report] 
                     ,[ISRC] 
                     ,[Artist] 
                     ,[Title]  
                     ,[UPC]
                     ,[UPC2] 
                     ,[Country]
                     ,[Nbofplays]
                     ,[Royalties]
                     ,[CurrencyExchange]
                     ,[TOTAL] 
                     ,[Service] 
                     ,[Provider] 
                     ,[Label]
                     ,[FileDate]
                     ,[LabelID] 
                     ,[Filename] 
                     ,[distributorid]
                     ,[InvoiceGroup]
                     ,[Invoice]
                     ,[Send2Sales]
                     ,[Use_filedate]
                     ,[formattypeid] 
                     ,[InvoiceNumber]
              )
select 
       @BeginDate
       ,@EndDate
       ,ISRC
       ,[artist_name]
       ,[track_title]
       ,[release_id]
       ,[release_id]
       ,[country_of_sale]
       ,[quantity]
       ,[total_payable]
       ,([USD_Amount]/[total_payable])
       ,[USD_Amount]
       ,[service_type]
       ,[service]
       ,[label_name]
       ,filedate
       ,@Partner
       ,filename
       ,'65'
       ,@Partner
       ,'Y'
       ,'Y'
       ,@useFiledate 
       ,'2'
       ,@InvoiceNumber
from   
       ods.dbo.MerlinWindup_TencentTMP
where 
use_filedate = @UseFileDate
AND FILEDATe = @FileDate
and invoicenumber = @InvoiceNumber
GOTO InvoiceCheck


--************************************************************************************************************************************




--select sum([partner revenue])
--from ods.dbo.merlinwindup_youtubetmp
--where usefiledate ='2019-06-15'
--and filename  in ('YouTube_Wind_Up_M_20190501_20190531_red_label_rawdata_asset_v1-1', 'YouTube_Wind_Up_M_20190501_20190531_rev_views_by_asset_v1-0')

InvoiceCheck:



select 
       sum(Total) AmountUSD
       ,COUNT(*) AS Rows
       ,InvoiceGroup
       ,Use_filedate
	   ,InvoiceNumber
from 
       ODS.dbo.Windup_MerlinRoyalties 
where 
       invoicenumber= @InvoiceNumber
	   and Use_filedate = @UseFileDate
group by      
       InvoiceGroup
       ,Use_filedate
	   ,InvoiceNumber


		
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			


           
           
          
          
           
           
           
           
           
          
           
           
           
           
           
           
           



GO


