using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace ProjectWork
{
    public class WinnerDisplayData
    {
        public string message;
        public bool haveWinner;
        public List<Winner> Winner;
    }
}
