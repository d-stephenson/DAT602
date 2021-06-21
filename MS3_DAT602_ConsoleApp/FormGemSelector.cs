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
    public partial class FormGemSelector : Form
    {
        private GemDisplayData GemDisplayData = new GemDisplayData();
        public void refreshDS()
        {
            //CheckBox clickedCheckbox = true;
            GemDisplayData = new DataAccess().GemDisplay(DataAccess.positionNow, DataAccess.currentGame);

            dataGridViewg1.ColumnCount = 2;

            dataGridViewg1.Columns[0].Name = "Gem";
            dataGridViewg1.Columns[1].Name = "Points";
            dataGridViewg1.Columns[2].Name = "Item";
            dataGridViewg1.Columns[3].Name = "Game";
            dataGridViewg1.Columns[4].Name = "Player";
            dataGridViewg1.Columns[5].Name = "Play";
            dataGridViewg1.Columns[6].Name = "Tile";

            foreach (GemSelection item in GemDisplayData.GemSelection)
            {
                string[] rowN =
                {
                    item.GemType.ToString(),
                    item.Points.ToString(),
                    item.ItemID.ToString(),
                    item.GameID.ToString(),
                    item.PlayerID.ToString(),
                    item.PlayID.ToString(),
                    item.TileID.ToString()
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
            this.Close();
        }

        private void dataGridViewg1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
