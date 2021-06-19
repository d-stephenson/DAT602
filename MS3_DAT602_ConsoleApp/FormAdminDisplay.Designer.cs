
namespace ProjectWork
{
    partial class FormAdminDisplay
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

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.Home = new System.Windows.Forms.Button();
            this.Logout = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.AddPlayer = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.KillGame = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.UpdatePlayer = new System.Windows.Forms.Button();
            this.RemovePlayer = new System.Windows.Forms.Button();
            this.dataGridViewa1 = new System.Windows.Forms.DataGridView();
            this.dataGridViewa2 = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewa1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewa2)).BeginInit();
            this.SuspendLayout();
            // 
            // Home
            // 
            this.Home.Location = new System.Drawing.Point(25, 23);
            this.Home.Name = "Home";
            this.Home.Size = new System.Drawing.Size(75, 23);
            this.Home.TabIndex = 25;
            this.Home.Text = "Home";
            this.Home.UseVisualStyleBackColor = true;
            this.Home.Click += new System.EventHandler(this.Home_Click);
            // 
            // Logout
            // 
            this.Logout.Location = new System.Drawing.Point(25, 52);
            this.Logout.Name = "Logout";
            this.Logout.Size = new System.Drawing.Size(75, 23);
            this.Logout.TabIndex = 24;
            this.Logout.Text = "Logout";
            this.Logout.UseVisualStyleBackColor = true;
            this.Logout.Click += new System.EventHandler(this.Logout_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Copperplate Gothic Bold", 27.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.DarkGoldenrod;
            this.label1.Location = new System.Drawing.Point(308, 23);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(143, 41);
            this.label1.TabIndex = 22;
            this.label1.Text = "Admin";
            // 
            // AddPlayer
            // 
            this.AddPlayer.Location = new System.Drawing.Point(483, 333);
            this.AddPlayer.Name = "AddPlayer";
            this.AddPlayer.Size = new System.Drawing.Size(91, 23);
            this.AddPlayer.TabIndex = 33;
            this.AddPlayer.Text = "Add Player";
            this.AddPlayer.UseVisualStyleBackColor = true;
            this.AddPlayer.Click += new System.EventHandler(this.AddPlayer_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Segoe UI", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(451, 95);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(138, 20);
            this.label4.TabIndex = 32;
            this.label4.Text = "Registered Players";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(456, 115);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(129, 15);
            this.label5.TabIndex = 31;
            this.label5.Text = "Username (High Score)";
            // 
            // KillGame
            // 
            this.KillGame.Location = new System.Drawing.Point(217, 333);
            this.KillGame.Name = "KillGame";
            this.KillGame.Size = new System.Drawing.Size(91, 23);
            this.KillGame.TabIndex = 29;
            this.KillGame.Text = "Kill Game";
            this.KillGame.UseVisualStyleBackColor = true;
            this.KillGame.Click += new System.EventHandler(this.KillGame_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Segoe UI", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(213, 95);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(98, 20);
            this.label3.TabIndex = 28;
            this.label3.Text = "Open Games";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Segoe UI", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(196, 115);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(131, 15);
            this.label2.TabIndex = 27;
            this.label2.Text = "Game ID (Player Count)";
            // 
            // UpdatePlayer
            // 
            this.UpdatePlayer.Location = new System.Drawing.Point(483, 362);
            this.UpdatePlayer.Name = "UpdatePlayer";
            this.UpdatePlayer.Size = new System.Drawing.Size(91, 23);
            this.UpdatePlayer.TabIndex = 34;
            this.UpdatePlayer.Text = "Update Player";
            this.UpdatePlayer.UseVisualStyleBackColor = true;
            this.UpdatePlayer.Click += new System.EventHandler(this.UpdatePlayer_Click);
            // 
            // RemovePlayer
            // 
            this.RemovePlayer.Location = new System.Drawing.Point(483, 391);
            this.RemovePlayer.Name = "RemovePlayer";
            this.RemovePlayer.Size = new System.Drawing.Size(91, 23);
            this.RemovePlayer.TabIndex = 35;
            this.RemovePlayer.Text = "Remove Player";
            this.RemovePlayer.UseVisualStyleBackColor = true;
            this.RemovePlayer.Click += new System.EventHandler(this.RemovePlayer_Click);
            // 
            // dataGridViewa1
            // 
            this.dataGridViewa1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewa1.Location = new System.Drawing.Point(144, 144);
            this.dataGridViewa1.Name = "dataGridViewa1";
            this.dataGridViewa1.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dataGridViewa1.Size = new System.Drawing.Size(234, 183);
            this.dataGridViewa1.TabIndex = 36;
            this.dataGridViewa1.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridViewa1_CellContentClick);
            // 
            // dataGridViewa2
            // 
            this.dataGridViewa2.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewa2.Location = new System.Drawing.Point(405, 144);
            this.dataGridViewa2.Name = "dataGridViewa2";
            this.dataGridViewa2.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dataGridViewa2.Size = new System.Drawing.Size(234, 183);
            this.dataGridViewa2.TabIndex = 37;
            this.dataGridViewa2.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridViewa2_CellContentClick);
            // 
            // FormAdminDisplay
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.dataGridViewa2);
            this.Controls.Add(this.dataGridViewa1);
            this.Controls.Add(this.RemovePlayer);
            this.Controls.Add(this.UpdatePlayer);
            this.Controls.Add(this.AddPlayer);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.KillGame);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.Home);
            this.Controls.Add(this.Logout);
            this.Controls.Add(this.label1);
            this.Name = "FormAdminDisplay";
            this.Text = "Admin";
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewa1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewa2)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button Home;
        private System.Windows.Forms.Button Logout;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button AddPlayer;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Button KillGame;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button UpdatePlayer;
        private System.Windows.Forms.Button RemovePlayer;
        private System.Windows.Forms.DataGridView dataGridViewa1;
        private System.Windows.Forms.DataGridView dataGridViewa2;
    }
}