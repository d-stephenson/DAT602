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
    public partial class FormHomeDisplay : Form
    {
        private HomeDisplayData HomeDisplayData = new HomeDisplayData();
        public void refreshDS()
        {
            HomeDisplayData = new DataAccess().HomeScreen();

            dataGridView1.ColumnCount = 2;
            dataGridView2.ColumnCount = 2;

            dataGridView1.Columns[0].Name = "Game ID";
            dataGridView1.Columns[1].Name = "Player count";
            dataGridView2.Columns[0].Name = "Player name";
            dataGridView2.Columns[1].Name = "High Score";

            foreach (GameCount item in HomeDisplayData.GameCount)
            {
                string[] rowN =
                {
                    item.GameID.ToString(),
                    item.PlayerCount.ToString()
                };
                dataGridView1.Rows.Add(rowN);
            }

            foreach (PlayerHighScore item in HomeDisplayData.PlayerHighScore)
            {
                string[] rowM =
                {
                    item.Player,
                    item.HighScore.ToString()
                };
                dataGridView2.Rows.Add(rowM);
            }

        }
        public FormHomeDisplay()
        {
            InitializeComponent();
        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void Form3_Load(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void Admin_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.AdminScreen(DataAccess.validatedUsername);

            if(DataAccess.adminStatus == "Success")
            {
                FormAdminDisplay aAdminDisplay = new FormAdminDisplay();
                aAdminDisplay.refreshDS();
                aAdminDisplay.Show();
                this.Hide();
            }
            else if(DataAccess.adminStatus == "Failed")
            {
                FormAdminFailDisplay aAdminFailDisplay = new FormAdminFailDisplay();
                aAdminFailDisplay.Show();
                this.Hide();
            }
        }

        private void JoinGame_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.JoinGame(dataGridView1.SelectedRows[0].Cells[0].Value.ToString(), DataAccess.validatedUsername);

            FormGame aJoinGame = new FormGame();
            aJoinGame.Show();
            this.Close();
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void NewGame_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.NewGame(DataAccess.validatedUsername);

            FormGame aGameDisplay = new FormGame();
            aGameDisplay.Show();
            this.Close();
        }

        private void dataGridView2_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void Logout_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.PlayerLogout(DataAccess.validatedUsername);

            FormLogin aLoginDisplay = new FormLogin();
            aLoginDisplay.Show();
            this.Close();
        }
    }
}
