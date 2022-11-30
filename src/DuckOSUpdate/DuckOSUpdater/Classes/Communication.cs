using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace DuckOSUpdater.Classes
{
    class Communication
    {

        public TcpClient Service;

        public Process Updaterprocess = null;
        public void Bind()
        {
        retry:
            try
            {
                Service = new TcpClient();
                Service.Connect("127.0.0.1", 64532);
            }
            catch { Service = null; Thread.Sleep(1000); goto retry; }
        }

        public void Send(string data)
        {
            try
            {
                byte[] buf = Encoding.UTF8.GetBytes(data + "|");
                Service.GetStream().Write(buf, 0, buf.Length);
                Console.WriteLine("Sent " + data);
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
                Service.GetStream().Read(buf, 0, buf.Length);
                Service.GetStream().Flush();
                Console.WriteLine("Recieved data! " + Encoding.UTF8.GetString(buf).Split('|')[0]);
                return Encoding.UTF8.GetString(buf);
            }catch { }
            return "NULL|";
        }
    }
}
