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
                string[] rowN =
                {
                    item.Player,
                    item.HighScore.ToString()
                };
                dataGridView2.Rows.Add(rowN);
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

        private void button2_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            //HomeDisplayData aDisplayData = DataAccess.HomeScreen();
            //HomeDisplayDataList = aDisplayData.GameCount();
            //refreshDS();
        }

        private void button3_MouseClick(object sender, MouseEventArgs e)
        {

        }

        private void dataGridView2_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
