
namespace DuckOSUpdaterService.Services
{
    partial class updater
    {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(updater));
            this.Trayicon = new System.Windows.Forms.NotifyIcon(this.components);
            // 
            // Trayicon
            // 
            this.Trayicon.BalloonTipIcon = System.Windows.Forms.ToolTipIcon.Info;
            this.Trayicon.Icon = ((System.Drawing.Icon)(resources.GetObject("Trayicon.Icon")));
            this.Trayicon.Text = "DuckOS Tray";
            this.Trayicon.Visible = true;
            // 
            // updater
            // 
            this.ServiceName = "Service1";

        }

        #endregion

        public System.Windows.Forms.NotifyIcon Trayicon;
    }
}
