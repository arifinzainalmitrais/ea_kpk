select * from t_diagram where Diagram_ID = 11
select * from t_diagramlinks where DiagramID = 11
select * from t_diagramobjects where Diagram_ID = 11
select * from t_connector where Connector_ID in (select Connector_ID from t_diagramlinks where DiagramID = 11)







select SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 9)