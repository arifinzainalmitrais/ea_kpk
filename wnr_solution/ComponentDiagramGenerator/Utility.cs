using ComponentDiagramGenerator.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using System.Text;
using System.Threading.Tasks;

namespace ComponentDiagramGenerator
{
    public static class Utility
    {
        public static List<Application> ImportApplications(string filePath)
        {
            var applications = new List<Application>();

            using (var reader = new StreamReader(filePath)) 
            {
                while(!reader.EndOfStream) 
                {
                    var line = reader.ReadLine();
                    var values = !String.IsNullOrEmpty(line)?line.Split(','):null;
                    if (values != null) 
                    {
                        applications.Add(new Application
                        {
                            AppName = values[0],
                            DiagramName = values[1]
                        });
                    }
                }
            }


            return applications;
        }

        public static List<Connector> ImportConnectors(string filePath)
        {
            var connectors = new List<Connector>();

            using (var reader = new StreamReader(filePath))
            { 
                while (!reader.EndOfStream) 
                {
                    var line = reader.ReadLine();
                    var values = !String.IsNullOrEmpty(line) ? line.Split(","):null;
                    if(values != null) 
                    {
                        connectors.Add(new Connector 
                        {
                            SourceAppName = values[0],
                            DestinationAppName = values[1]
                        });
                    }
                }
            }
            return connectors;
        }

        public static int SaveApplication(List<Application> applications)
        {
            var result = 0;
            using(var sql = SqlService.GetConnection())
            {
                foreach(var app in applications) 
                {
                    //get diagram name 
                    var diagram = DataOperation.RetrieveDiagramByName(sql, app.DiagramName);
                    if(diagram != null)
                    {
                        var output = DataOperation.CreateApplication(sql, new Data.Application { AppName = app.AppName, DiagramId = diagram.DiagramId }); 
                        if(output!=0) result++;
                    }
                }
            }

            return result;
        }

        public static int SaveConnectors(List<Connector> connectors)
        {
            var result = 0;

            using (var sql = SqlService.GetConnection())
            { 
                foreach(var connector in connectors)
                {
                    var source_app = DataOperation.RetrieveApplicationByName(sql, connector.SourceAppName);
                    var dest_app = DataOperation.RetrieveApplicationByName(sql, connector.DestinationAppName);
                    var data_connector = new Data.Connector();
                    
                    if(source_app != null)  data_connector.Source_App_Id = source_app.Id;
                    if (dest_app != null) data_connector.Dest_App_Id = dest_app.Id;

                    var output = DataOperation.CreateConnector(sql, data_connector);
                    if(output!=0) result++;
                }
            }
            return result;
        }

        public static int GenerateComponentDiagram(string packageName, string diagramName)
        {
            using(var sql = SqlService.GetConnection()) 
            {
                return  DataOperation.ExecuteComponentGeneration(sql, packageName, diagramName);
            }
        }
    }
}
