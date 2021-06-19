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
    public partial class FormRegister : Form
    {
        public FormRegister()
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

        private void Register_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.NewUserRegistration(Email.Text, Username.Text, Password.Text);
            // if loginStatus == "Success" then go to FormHomeDisplay
            if (DataAccess.registrationStatus == "New Account")
            {
                FormLogin aLoginDisplay = new FormLogin();
                aLogin.Show();
                this.Close();
            }
            // else if loginStats == "Failed" then display fail message
            else if (DataAccess.registrationStatus == "Failed")
            {
                FormRegFailDisplay aRegFailDisplay = new FormRegFailDisplay();
                aRegFailDisplay.Show();
                this.Hide();
            }
        }
    }
}
