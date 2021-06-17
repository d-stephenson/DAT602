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
    public partial class FormUpdateUser : Form
    {
        public FormUpdateUser()
        {
            InitializeComponent();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            FormHomeDisplay aHomeDisplay = new FormHomeDisplay();
            aHomeDisplay.refreshDS();
            aHomeDisplay.Show();
            this.Hide();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            FormAdminDisplay aAdminDisplay = new FormAdminDisplay();
            aAdminDisplay.refreshDS();
            aAdminDisplay.Show();
            this.Close();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.PlayerLogout(DataAccess.validatedUsername);

            if (DataAccess.validatedUsername == DataAccess.validatedUsername)
            {
                FormLogin aLoginDisplay = new FormLogin();
                aLoginDisplay.Show();
                this.Close();
            }
        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
