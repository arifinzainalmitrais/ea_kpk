using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ComponentDiagramGenerator.Data
{
    public class Connector
    {
        public int ConnectorId { get; set; }
        public int Source_App_Id { get; set; }
        public int Dest_App_Id { get; set;}
    }
}
