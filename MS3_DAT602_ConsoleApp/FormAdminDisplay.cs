using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ProjectWork
{
    public partial class FormAdminDisplay : Form
    {
        private HomeDisplayData HomeDisplayData = new HomeDisplayData();
        public void refreshDS()
        {
            HomeDisplayData = new DataAccess().HomeScreen();

            dataGridViewa1.ColumnCount = 2;
            dataGridViewa2.ColumnCount = 2;

            dataGridViewa1.Columns[0].Name = "Game ID";
            dataGridViewa1.Columns[1].Name = "Player count";
            dataGridViewa2.Columns[0].Name = "Player name";
            dataGridViewa2.Columns[1].Name = "High Score";

            foreach (GameCount item in HomeDisplayData.GameCount)
            {
                string[] rowO =
                {
                    item.GameID.ToString(),
                    item.PlayerCount.ToString()
                };
                dataGridViewa1.Rows.Add(rowO);
            }

            foreach (PlayerHighScore item in HomeDisplayData.PlayerHighScore)
            {
                string[] rowP =
                {
                    item.Player,
                    item.HighScore.ToString()
                };
                dataGridViewa2.Rows.Add(rowP);
            }
        }

        public FormAdminDisplay()
        {
            InitializeComponent();
        }

        private void Home_Click(object sender, EventArgs e)
        {
            FormHomeDisplay aHomeDisplay = new FormHomeDisplay();
            aHomeDisplay.refreshDS();
            aHomeDisplay.Show();
            this.Close();
        }

        private void Logout_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.PlayerLogout(DataAccess.validatedUsername);

            FormLogin aLoginDisplay = new FormLogin();
            aLoginDisplay.Show();
            this.Close();
        }

        private void AddPlayer_Click(object sender, EventArgs e)
        {
            FormAddUser aAddUserDisplay = new FormAddUser();
            aAddUserDisplay.Show();
            this.Close();
        }

        private void UpdatePlayer_Click(object sender, EventArgs e)
        {
            FormUpdateUser aAddUpdateUser = new FormUpdateUser();
            aAddUpdateUser.Show();
            this.Close();
        }

        private void RemovePlayer_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.DeletePlayer(dataGridViewa2.SelectedRows[0].Cells[0].Value.ToString());

            FormRemovePlayerDisplay aRemovePlayer = new FormRemovePlayerDisplay();
            aRemovePlayer.Show();
            this.Hide();
        }

        private void KillGame_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.KillGame(dataGridViewa1.SelectedRows[0].Cells[0].Value.ToString());

            FormKillDisplay aGameKill = new FormKillDisplay();
            aGameKill.Show();
        }

        private void dataGridViewa1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void dataGridViewa2_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
