using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ComponentDiagramGenerator
{
    public static class ConfigHelper
    {
        public static Config Config { get; } = new Config();
    }

    public static class SqlService
    {
        public static IDbConnection GetConnection()
        {
            var connString = ConfigurationManager.ConnectionStrings["EADb"].ConnectionString;
            return new SqlConnection(connString);
        }
    }


    public class Config
    {
        public string PackageName { get; set; }
        public string DiagramName{ get; set; }
        public string ApplicationDataFile { get; set; }
        public string ConnectorDataFile { get; set; }
        public Config()
        {
            PackageName = GetConfig("PackageName");
            DiagramName = GetConfig("DiagramName");
            ApplicationDataFile = GetConfig("ApplicationDataFile");
            ConnectorDataFile = GetConfig("ConnectorDataFile");
        }
        private static string GetConfig(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }
    }

}
