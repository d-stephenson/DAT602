﻿using System;
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
    public partial class FormLogin : Form
    {
        public FormLogin()
        {
            InitializeComponent();
        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void Login_Click(object sender, EventArgs e)
        {
            DataAccess aDataAccess = new DataAccess();
            aDataAccess.LoginCheckCredentials(UsernameText.Text, PasswordText.Text);
            // if loginStatus == "Success" then go to FormHomeDisplay
            if(DataAccess.loginStatus == "Logged In")
            {
                FormHomeDisplay aHomeDisplay = new FormHomeDisplay();
                aHomeDisplay.refreshDS();
                aHomeDisplay.Show();
                this.Close();
            }
            // else if loginStats == "Failed" then display fail message
            else if(DataAccess.loginStatus == "Failed")
            {
                FormLoginFailDisplay aLoginFailDisplay = new FormLoginFailDisplay();
                aLoginFailDisplay.Show();
                this.Hide();
            }
        }

        private void UsernameText_TextChanged(object sender, EventArgs e)
        {

        }

        private void NewUser_Click(object sender, EventArgs e)
        {
            FormRegister aRegisterDisplay = new FormRegister();
            aRegisterDisplay.Show();
            this.Close();
        }

        private void PasswordText_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
