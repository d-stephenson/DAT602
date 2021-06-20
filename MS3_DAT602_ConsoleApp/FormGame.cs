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
    public partial class FormGame : Form
    {
        public FormGame()
        {
            InitializeComponent();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.PlayerLogout(DataAccess.validatedUsername);

            FormLogin aLoginDisplay = new FormLogin();
            aLoginDisplay.Show();
            this.Close();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            FormAdminDisplay aAdminDisplay = new FormAdminDisplay();
            aAdminDisplay.refreshDS();
            aAdminDisplay.Show();
            this.Close();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            FormHomeDisplay aHomeDisplay = new FormHomeDisplay();
            aHomeDisplay.refreshDS();
            aHomeDisplay.Show();
            this.Hide();
        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        private void checkBox82_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void checkBox_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox clickedCheckbox = (sender as CheckBox);
            // DataAccess.MovePlayer(clickedCheckbox.Tag, DataAccess.validatedUsername, DataAccess.currentGame)
            string message = "Your character has moved!!!";

            if(message == "Your character has moved!!!")
            {
                clickedCheckbox.Checked = true;
            }
            else
            {
                clickedCheckbox.Checked = false;
            }
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
