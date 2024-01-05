
CREATE procedure [dbo].[sp_Create_Component_Diagram] (@diagram_name nvarchar(max),@package_name nvarchar(max))
as 
	declare @diagram_id int
	declare @package_id int 
	declare @object_id int 
	declare @object_style nvarchar(max)
	declare @source_id int
	declare @dest_id int
	declare @source_app nvarchar(max)
	declare @dest_app nvarchar(max)
	declare @source_object_id int 
	declare @dest_object_id int 
	declare @connector_id int 
	declare @connector_style nvarchar(max)
	declare @diagram_type nvarchar(50) = 'Component'
	declare @total_recs int = 0
	--declare @diagram_name nvarchar(255)= 'WNR Component Diagram'
	--declare @package_name nvarchar(255)= 'WNR Component Diagram'

	-- step 1 create the diagram if not exists --
	if not exists(select * from t_diagram where [Name] = @diagram_name)
		begin 
			-- get the package Name 
			set @package_id = (select Package_ID from t_package where [Name] = @package_name)
			INSERT [dbo].[t_diagram] ( [Package_ID], [ParentID], [Diagram_Type], [Name], [Version], [Author], [ShowDetails], [Notes], [Stereotype], [AttPub], [AttPri], [AttPro], [Orientation], [cx], [cy], [Scale], [CreatedDate], [ModifiedDate], [HTMLPath], [ShowForeign], [ShowBorder], [ShowPackageContents], [PDATA], [Locked], [ea_guid], [TPos], [Swimlanes], [StyleEx]) 
			VALUES ( @package_id, 0,@diagram_type , @diagram_name, N'1.0', N'ZainalA', 0, NULL, NULL, 1, 1, 1, N'P', 850, 1098, 100, GETDATE(), GETDATE(), NULL, 1, 1, 1, N'HideRel=0;ShowTags=0;ShowReqs=0;ShowCons=0;OpParams=1;ShowSN=0;ScalePI=0;PPgs.cx=1;PPgs.cy=1;PSize=1;ShowIcons=1;SuppCN=0;HideProps=0;HideParents=0;UseAlias=0;HideAtts=0;HideOps=0;HideStereo=0;HideEStereo=0;FormName=;', 0, CONVERT(varchar(255), newid()), NULL, N'locked=false;orientation=0;width=0;inbar=false;names=false;color=-1;bold=false;fcol=0;tcol=-1;ofCol=-1;hl=1;cls=0;', N'ExcludeRTF=0;DocAll=0;HideQuals=0;AttPkg=1;ShowTests=0;ShowMaint=0;SuppressFOC=1;MatrixActive=0;SwimlanesActive=1;KanbanActive=0;MatrixLineWidth=1;MatrixLocked=0;TConnectorNotation=UML 2.1;TExplicitNavigability=0;AdvancedElementProps=1;AdvancedFeatureProps=1;AdvancedConnectorProps=1;ProfileData=;MDGDgm=;STBLDgm=;ShowNotes=0;VisibleAttributeDetail=0;ShowOpRetType=1;SuppressBrackets=0;SuppConnectorLabels=0;PrintPageHeadFoot=0;ShowAsList=0;SuppressedCompartments=;SaveTag=2C41E33C;')
		end 

	-- step 2 get diagram id it exists 
	set @diagram_id = (select Diagram_ID from t_diagram where [Name] = @diagram_name)
	set @package_id = (select Package_ID from t_package where [Name] = @package_name)

	-- step 3 create the component objects 
	DECLARE  @app_name nvarchar(max);

	declare cursor_app cursor local for select AppName from [Application] inner join [Diagram] on [Application].DiagramId = [Diagram].DiagramId where [Diagram].DiagramName = @diagram_name

	open cursor_app;
	fetch next from cursor_app into @app_name;

	while @@FETCH_STATUS = 0
		begin		   

			-- insert into objects
			INSERT [dbo].[t_object] ([Object_Type], [Diagram_ID], [Name], [Alias], [Author], [Version], [Note], [Package_ID], [Stereotype], [NType], [Complexity], [Effort], [Style], [Backcolor], [BorderStyle], [BorderWidth], [Fontcolor], [Bordercolor], [CreatedDate], [ModifiedDate], [Status], [Abstract], [Tagged], [PDATA1], [PDATA2], [PDATA3], [PDATA4], [PDATA5], [Concurrency], [Visibility], [Persistence], [Cardinality], [GenType], [GenFile], [Header1], [Header2], [Phase], [Scope], [GenOption], [GenLinks], [Classifier], [ea_guid], [ParentID], [RunState], [Classifier_guid], [TPos], [IsRoot], [IsLeaf], [IsSpec], [IsActive], [StateFlags], [PackageFlags], [Multiplicity], [StyleEx], [EventFlags], [ActionFlags]) 
			VALUES (@diagram_type, 0, @app_name, NULL, N'ZainalA', N'1.0', NULL, @package_id, NULL, 0, N'1', 0, NULL, -1, 0, -1, -1, -1,GETDATE(), GETDATE(), N'Proposed', N'0', 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Java', NULL, NULL, NULL, N'1.0', N'Public', NULL, NULL, 0, CONVERT(varchar(255), newid()) , 0, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL)
		
			-- draw into diagram
			set @object_id = (select SCOPE_IDENTITY())
			set @object_style = 'DUID=' + SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 9) + ';NSL=0;BCol=-1;BFol=-1;LCol=-1;LWth=-1;fontsz=0;bold=0;black=0;italic=0;ul=0;charset=0;pitch=0;'

			INSERT [dbo].[t_diagramobjects] ([Diagram_ID], [Object_ID], [RectTop], [RectLeft], [RectRight], [RectBottom], [Sequence], [ObjectStyle]) VALUES (@diagram_id, @object_id, -597, 477, 587, -657, 1, @object_style)
		

			fetch next from cursor_app into @app_name;
		end;

	close cursor_app;

	-- step 4 create connector 
	declare cursor_connector cursor local for select Source_App_Id, Dest_App_Id from Connector

	open cursor_connector 
	fetch next from cursor_connector into @source_id, @dest_id 

	while @@FETCH_STATUS = 0
		begin		   
			-- get app_name 
			set @source_app = (select AppName from [Application] where Id = @source_id)
			set @dest_app = (select AppName from [Application] where Id = @dest_id)

			-- get objectId 
			set @source_object_id = (select [Object_ID] from t_object where [Name] = @source_app)
			set @dest_object_id = (select [Object_ID] from t_object where [Name] = @dest_app)
		
			-- insert into connector
			INSERT [dbo].[t_connector] ([Name], [Direction], [Notes], [Connector_Type], [SubType], [SourceCard], [SourceAccess], [SourceElement], [DestCard], [DestAccess], [DestElement], [SourceRole], [SourceRoleType], [SourceRoleNote], [SourceContainment], [SourceIsAggregate], [SourceIsOrdered], [SourceQualifier], [DestRole], [DestRoleType], [DestRoleNote], [DestContainment], [DestIsAggregate], [DestIsOrdered], [DestQualifier], [Start_Object_ID], [End_Object_ID], [Top_Start_Label], [Top_Mid_Label], [Top_End_Label], [Btm_Start_Label], [Btm_Mid_Label], [Btm_End_Label], [Start_Edge], [End_Edge], [PtStartX], [PtStartY], [PtEndX], [PtEndY], [SeqNo], [HeadStyle], [LineStyle], [RouteStyle], [IsBold], [LineColor], [Stereotype], [VirtualInheritance], [LinkAccess], [PDATA1], [PDATA2], [PDATA3], [PDATA4], [PDATA5], [DiagramID], [ea_guid], [SourceConstraint], [DestConstraint], [SourceIsNavigable], [DestIsNavigable], [IsRoot], [IsLeaf], [IsSpec], [SourceChangeable], [DestChangeable], [SourceTS], [DestTS], [StateFlags], [ActionFlags], [IsSignal], [IsStimulus], [DispatchAction], [Target2], [StyleEx], [SourceStereotype], [DestStereotype], [SourceStyle], [DestStyle], [EventFlags]) 
			VALUES 
			( NULL, N'Source -> Destination', NULL, N'Usage', NULL, NULL, N'Public', NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Unspecified', 0, 0, NULL, NULL, NULL, NULL, N'Unspecified', 0, 0, NULL, @source_object_id, @dest_object_id, NULL, NULL, NULL, NULL, N'«use»', NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, -1, N'dest', NULL, NULL, NULL, NULL, NULL, NULL, N'SX=0;SY=0;EX=0;EY=0;', 0, CONVERT(varchar(255), newid()), NULL, NULL, 0, 1, 0, 0, 0, N'none', N'none', N'instance', N'instance', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, NULL, N'Union=0;Derived=0;AllowDuplicates=0;Owned=0;Navigable=Non-Navigable;', N'Union=0;Derived=0;AllowDuplicates=0;Owned=0;Navigable=Navigable;', NULL)
		
			-- draw in the diagram 
			set @connector_id = (select SCOPE_IDENTITY())
			set @connector_style=  N'Mode=3;EOID=' + SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 9) + ';SOID=' + SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 9) + ';Color=-1;LWidth=0;'

			INSERT [dbo].[t_diagramlinks] ([DiagramID], [ConnectorID], [Geometry], [Style], [Hidden], [Path]) 
			VALUES (@diagram_id, @connector_id, N'SX=0;SY=0;EX=0;EY=0;EDGE=1;$LLB=;LLT=;LMT=;LMB=CX=69:CY=26:OX=0:OY=0:HDN=0:BLD=0:ITA=0:UND=0:CLR=-1:ALN=1:DIR=0:ROT=0;LRT=;LRB=;IRHS=;ILHS=;',@connector_style, 0, NULL)
		
			set @total_recs += 1
			fetch next from cursor_connector into @source_id, @dest_id;
		end;

	close cursor_connector;

	-- display total records created in connector
	select @total_recs as 'total_records'
GO


