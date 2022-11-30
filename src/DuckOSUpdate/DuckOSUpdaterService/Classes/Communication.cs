using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace DuckOSUpdaterService.Classes
{
    class Communication
    {
        public TcpListener listener = new TcpListener(System.Net.IPAddress.Any, 64532);

        public TcpClient secondprocess;

        public Process Updaterprocess = null;
        public void Bind()
        {
        retry:
            listener.Start();
            secondprocess = listener.AcceptTcpClient();
            EventLog.WriteEntry("DuckOS Updater", "Bound to updater process! " + secondprocess.Client.RemoteEndPoint, EventLogEntryType.SuccessAudit);
            listener.Stop();
        }

        public void Send(string data)
        {
            try
            {
                byte[] buf = Encoding.UTF8.GetBytes(data + "|");
                secondprocess.GetStream().Write(buf, 0, buf.Length);
            }
            catch
            {

            }
            
        }

        public string Recieve()
        {
            try
            {
                byte[] buf = new byte[50];
                secondprocess.GetStream().Read(buf, 0, buf.Length);
                secondprocess.GetStream().Flush();
                return Encoding.UTF8.GetString(buf);
            }catch { }
            return "NULL|";
        }
    }
}
