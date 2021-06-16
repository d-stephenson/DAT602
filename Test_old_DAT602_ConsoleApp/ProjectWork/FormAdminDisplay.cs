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
        

        public FormAdminDisplay()
        {
            InitializeComponent();
        }

        private void Home_Click(object sender, EventArgs e)
        {

        }

        private void Logout_Click(object sender, EventArgs e)
        {

        }

        private void AddPlayer_Click(object sender, EventArgs e)
        {
            FormAddUser aAddUserDisplay = new FormAddUser();
            aAddUserDisplay.Show();
            this.Hide();
        }

        private void UpdatePlayer_Click(object sender, EventArgs e)
        {

        }

        private void RemovePlayer_Click(object sender, EventArgs e)
        {

        }

        private void KillGame_Click(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void dataGridView2_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
