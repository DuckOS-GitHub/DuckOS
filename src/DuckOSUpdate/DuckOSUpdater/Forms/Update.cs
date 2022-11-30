using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DuckOSUpdater.Forms
{
    public partial class Update : Form
    {
        Classes.Communication comms = new Classes.Communication();
        public Update()
        {
            InitializeComponent();
            this.WindowState = FormWindowState.Minimized;
            button1.Enabled = false;
            button2.Enabled = false;
            comms.Bind();
            CheckForIllegalCrossThreadCalls = false;
            Thread th = new Thread(() =>
            {
                this.Visible = false;
                while (true)
                {
                    try
                    {
                        string[] r = comms.Recieve().Split('|');
                        Console.WriteLine(r[0]);
                        switch (r[0])
                        {
                            case "STATUS":
                                label2.Text = r[1];
                                break;
                            case "AVAILABLE":
                                notifyIcon1.ShowBalloonTip(10000, "DuckOS Update", "An update is available! Click here for more info!", ToolTipIcon.Info);
                                break;
                            case "DONE":
                                MessageBox.Show("Update successful!");
                                label2.Text = "Working on updates...";
                                this.WindowState = FormWindowState.Minimized;
                                TopMost = false;
                                break;
                            case "RUN":
                                Console.WriteLine("Launching " + r[1]);
                                Process.Start(r[1]);
                                break;
                        }
                    }
                    catch { Thread.Sleep(10000); }
                }
            });
            th.Start();
        }

        private void Update_Load(object sender, EventArgs e)
        {
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            button1.Enabled = false;
            button2.Enabled = false;
            comms.Send("ACCEPT");
        }

        private void button2_Click(object sender, EventArgs e)
        {
            button1.Enabled = false;
            button2.Enabled = false;
            this.WindowState = FormWindowState.Minimized;
            TopMost = false;
            comms.Send("DENY");
        }

        private void notifyIcon1_BalloonTipClicked(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Normal;
            TopMost = true;
            WebClient wc = new WebClient();
            richTextBox1.Text = wc.DownloadString("https://github.com/IfinderCodes/DuckOS-contrib/raw/main/src/Online_Updater/Changelog.txt");
            button1.Enabled = true;
            button2.Enabled = true;
            TopMost = false;
        }
    }
}
