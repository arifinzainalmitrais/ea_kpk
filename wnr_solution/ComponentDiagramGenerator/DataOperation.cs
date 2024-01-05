using ComponentDiagramGenerator.Data;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ComponentDiagramGenerator
{
    public static class DataOperation
    {
        public static long CreateApplication (this IDbConnection conn, Application application)
        {
            var insert = $@"insert into Application(
                            {nameof(Application.DiagramId)},
                            {nameof(Application.AppName)})
                            values(
                            @{nameof(Application.DiagramId)},
                            @{nameof(Application.AppName)})";


            var select = "select Id from Application where Id = scope_identity()";

            return conn.Query<long>(insert + select, application).FirstOrDefault();
        }

        public static long CreateConnector(this IDbConnection conn,Connector connector)
        {
            var insert = $@"insert into Connector(
                            {nameof(Connector.Source_App_Id)},
                            {nameof(Connector.Dest_App_Id)})
                            values(
                            @{nameof(Connector.Source_App_Id)},
                            @{nameof(Connector.Dest_App_Id)})";


            var select = "select ConnectorId from Connector where ConnectorId = scope_identity()";

            return conn.Query<long>(insert + select, connector).FirstOrDefault();
        }

        public static Diagram RetrieveDiagramByName(this IDbConnection conn, string name)
        {
            var select = $@"select * from Diagram where DiagramName = @name";
            return conn.Query<Diagram>(select, new { name }).FirstOrDefault();
        }

        public static Application RetrieveApplicationByName(this IDbConnection conn, string name)
        {
            var select = $@"select * from Application where AppName = @name";
            return conn.Query<Application>(select, new { name }).FirstOrDefault();
        }

        public static int ExecuteComponentGeneration(this IDbConnection conn, string diagramName, string packageName)
        {
            var parameters = new { diagram_name = diagramName, package_name = packageName};
            var result = conn.Query<int>("[dbo].[sp_Create_Component_Diagram]", parameters, commandType: System.Data.CommandType.StoredProcedure).FirstOrDefault();
            return result;
        }
    }
}
