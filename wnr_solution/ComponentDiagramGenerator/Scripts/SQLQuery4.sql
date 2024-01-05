/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      [Object_ID]
      ,[RectTop]
      ,[RectLeft]
      ,[RectRight]
      ,[RectBottom]
      ,[Sequence]
      ,[ObjectStyle]
      ,[Instance_ID]
  FROM [WahanaRucikaNusantara].[dbo].[t_diagramobjects] where Diagram_ID = 11