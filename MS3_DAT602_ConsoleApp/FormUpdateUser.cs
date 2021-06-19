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

            FormLogin aLoginDisplay = new FormLogin();
            aLoginDisplay.Show();
            this.Close();
        }

        private void Email_TextChanged(object sender, EventArgs e)
        {

        }

        private void Username_TextChanged(object sender, EventArgs e)
        {

        }

        private void Password_TextChanged(object sender, EventArgs e)
        {

        }

        private void Admin_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void Locked_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void Active_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void FailedLogins_TextChanged(object sender, EventArgs e)
        {

        }

        private void Highscore_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.UpdatePlayer(Email.Text, Username.Text, Password.Text, Admin.Checked, Locked.Checked, Admin.Checked, FailedLogins.Text, Highscore.Text);

            if (DataAccess.upStatus == "Updated Account")
            {
                FormUpdateSuccessDisplay aUpdateSuccessDisplay = new FormUpdateSuccessDisplay();
                aUpdateSuccessDisplay.Show();
                this.Hide();
            }

            else if (DataAccess.upStatus == "Failed")
            {
                FormUpdateFailDisplay aUpdateFailDisplay = new FormUpdateFailDisplay();
                aUpdateFailDisplay.Show();
                this.Hide();
            }
        }
    }
}
