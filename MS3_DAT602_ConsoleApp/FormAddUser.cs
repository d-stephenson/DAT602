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
    public partial class FormAddUser : Form
    {
        public FormAddUser()
        {
            InitializeComponent();
        }

        private void label2_Click(object sender, EventArgs e)
        {

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

        private void Confirm_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.AddPlayer(Email.Text, Username.Text, Password.Text, Admin.Checked);
            
            if (DataAccess.addStatus == "New Account")
            {
                FormAdminDisplay aAdminDisplay = new FormAdminDisplay();
                aAdminDisplay.Show();
                this.Hide();
            }
            else if (DataAccess.addStatus == "Failed")
            {
                MessageBox.Show("Youve done something wrong, can't add this player!!!");
            }
        }

        private void Home_Click(object sender, EventArgs e)
        {
            FormHomeDisplay aHomeDisplay = new FormHomeDisplay();
            aHomeDisplay.refreshDS();
            aHomeDisplay.Show();
            this.Close();
        }

        private void AdminScreen_Click(object sender, EventArgs e)
        {
            FormAdminDisplay aAdminDisplay = new FormAdminDisplay();
            aAdminDisplay.refreshDS();
            aAdminDisplay.Show();
            this.Close();
        }

        private void Logout_Click(object sender, EventArgs e)
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
    }
}
