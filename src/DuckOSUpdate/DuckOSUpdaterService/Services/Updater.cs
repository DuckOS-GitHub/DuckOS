using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.ServiceProcess;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DuckOSUpdaterService.Services
{
    public partial class updater : ServiceBase
    {
        public updater()
        {
            InitializeComponent();
        }

        Classes.Communication process = new Classes.Communication();

        protected override void OnStart(string[] args)
        {
            ServicePointManager.Expect100Continue = true;
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            System.Windows.Forms.Control.CheckForIllegalCrossThreadCalls = false;
            EventLog.WriteEntry("DuckOS Updater", "Set program variables!", EventLogEntryType.SuccessAudit);
            Thread th = new Thread(() =>
            {
                process.Bind();
                EventLog.WriteEntry("DuckOS Updater", "Started updater thread: " + Thread.CurrentThread.ManagedThreadId, EventLogEntryType.SuccessAudit);
                WebClient Downloadmgr = new WebClient();
                string currentversion = Downloadmgr.DownloadString("https://raw.githubusercontent.com/DuckOS-GitHub/DuckOS/main/src/Online_Updater/version.txt");
                EventLog.WriteEntry("DuckOS Updater", "Downloaded starter version! ver: " + currentversion, EventLogEntryType.SuccessAudit);
                string skipversiontemp = "";
                /*process.Send("AVAILABLE");
                if (process.Recieve().Split('|')[0] == "ACCEPT")
                {
                    Thread.Sleep(4000);
                    process.Send("DONE");
                }
                else
                {
                    skipversiontemp = Downloadmgr.DownloadString("https://raw.githubusercontent.com/DuckOS-GitHub/DuckOS/main/src/Online_Updater/version.txt");
                    EventLog.WriteEntry("DuckOS Updater", "Skipping version " + skipversiontemp, EventLogEntryType.Warning);
                }*/
                while (true)
                {
                    if(Downloadmgr.DownloadString("https://raw.githubusercontent.com/DuckOS-GitHub/DuckOS/main/src/Online_Updater/version.txt") != currentversion)
                    {
                        if(skipversiontemp != Downloadmgr.DownloadString("https://raw.githubusercontent.com/DuckOS-GitHub/DuckOS/main/src/Online_Updater/version.txt"))
                        {
                            EventLog.WriteEntry("DuckOS Updater", "Update available!", EventLogEntryType.Information);
                            process.Send("AVAILABLE");
                            string r = process.Recieve();

                            EventLog.WriteEntry("DuckOS Updater", "Data recieved!\n\n" + r.Split('|')[0], EventLogEntryType.Information);
                            if (r.Split('|')[0] == "ACCEPT")
                            {
                                EventLog.WriteEntry("DuckOS Updater", "Initializing an update! Version: " + Downloadmgr.DownloadString("https://raw.githubusercontent.com/DuckOS-GitHub/DuckOS/main/src/Online_Updater/version.txt"), EventLogEntryType.Information);
                                process.Send("STATUS|Downloading FileTable");
                                string[] filetable = Downloadmgr.DownloadString("https://github.com/IfinderCodes/DuckOS-contrib/raw/main/src/Online_Updater/FILETABLE.txt").Split(char.Parse("\n"));
                                foreach (string line in filetable)
                                {
                                    string[] data = line.Split('|');
                                    try
                                    {
                                        process.Send(Classes.EnvFormat.FormatEnvironment(data[2]));
                                    }catch { }
                                   
                                    switch (data[0])
                                    {
                                        case "DOWNLOAD":
                                            try
                                            {
                                                process.Send("STATUS|Downloading " + Classes.EnvFormat.FormatEnvironment(data[2]));
                                                File.WriteAllBytes(Classes.EnvFormat.FormatEnvironment(data[2]), Downloadmgr.DownloadData(data[1]));
                                                EventLog.WriteEntry("DuckOS Updater", "Downloading file to " + Classes.EnvFormat.FormatEnvironment(data[2]), EventLogEntryType.Information);
                                            }
                                            catch { }
                                            break;
                                        case "RUN":
                                            try
                                            {
                                                process.Send("STATUS|Running " + Classes.EnvFormat.FormatEnvironment(data[1]));
                                                process.Send("RUN|" + Classes.EnvFormat.FormatEnvironment(data[1]));
                                                EventLog.WriteEntry("DuckOS Updater", "Running  " + Classes.EnvFormat.FormatEnvironment(data[2]), EventLogEntryType.Information);
                                            }
                                            catch { }
                                            break;
                                    }
                                }
                                process.Send("DONE");
                            }
                            else
                            {
                                skipversiontemp = Downloadmgr.DownloadString("https://raw.githubusercontent.com/DuckOS-GitHub/DuckOS/main/src/Online_Updater/version.txt");
                                EventLog.WriteEntry("DuckOS Updater", "Skipping version " + skipversiontemp, EventLogEntryType.Warning);
                            }
                        }
                        
                    }
                    Thread.Sleep(100000);
                }
            });
            th.Priority = ThreadPriority.Highest;
            th.Start();
        }

        protected override void OnStop()
        {
            EventLog.WriteEntry("DuckOS Updater", "Service stopping...", EventLogEntryType.Warning);
        }
    }
}
