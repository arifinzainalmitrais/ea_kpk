// See https://aka.ms/new-console-template for more information
using ComponentDiagramGenerator;

Console.WriteLine(" --- Load CSV Files ---");

var package_name = ConfigHelper.Config.PackageName;
var diagram_name = ConfigHelper.Config.DiagramName;

string app_path = Path.GetDirectoryName(Path.GetDirectoryName(System.IO.Directory.GetCurrentDirectory())) + "\\Files\\Application.csv";
string conector_path = Path.GetDirectoryName(Path.GetDirectoryName(System.IO.Directory.GetCurrentDirectory())) + "\\Files\\Connector.csv";

var applications = Utility.ImportApplications(app_path);
var connectors = Utility.ImportConnectors(conector_path);

//load into db
if(applications.Any()) Utility.SaveApplication(applications);
if(connectors.Any()) Utility.SaveConnectors(connectors);
Console.WriteLine(" CSV Data is Loaded into Database");

Console.WriteLine(" --- Run the Generator ---");
var result = Utility.GenerateComponentDiagram(package_name, diagram_name);
if (result != 0)
{
    Console.WriteLine("Data is Found. Diagram is Created");
}
else
{
    Console.WriteLine("No Connector is Found.");
}
Console.WriteLine(" --- Process Completed ---");