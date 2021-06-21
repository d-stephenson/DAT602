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
    public partial class FormGemSelector : Form
    {
        private GemDisplayData GemDisplayData = new GemDisplayData();
        public void refreshDS()
        {
            //CheckBox clickedCheckbox = true;
            GemDisplayData = new DataAccess().FindGem(DataAccess.positionNow, DataAccess.currentGame);

            dataGridViewg1.ColumnCount = 2;

            dataGridViewg1.Columns[0].Name = "Gem";
            dataGridViewg1.Columns[1].Name = "Points";

            foreach (GemSelection item in GemDisplayData.GemSelection)
            {
                string[] rowN =
                {
                    item.GemType.ToString(),
                    item.Points.ToString()
                };
                dataGridViewg1.Rows.Add(rowN);
            }

        }
        public FormGemSelector()
        {
            InitializeComponent();
        }

        private void checkedListBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {

        }
    }
}
