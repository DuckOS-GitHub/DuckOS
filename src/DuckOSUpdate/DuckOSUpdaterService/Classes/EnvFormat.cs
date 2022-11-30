using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DuckOSUpdaterService.Classes
{
    static class EnvFormat
    {
        public static string FormatEnvironment(this string input)
        {
            return input.Replace("%SYSTEMROOT%", Environment.GetEnvironmentVariable("SYSTEMROOT")).Replace("%WINDIR%", Environment.GetEnvironmentVariable("WINDIR")).Replace("%TEMP%", Environment.GetEnvironmentVariable("TEMP"));
        }
    }
}
