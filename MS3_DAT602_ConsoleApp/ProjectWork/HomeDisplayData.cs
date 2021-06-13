using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace ProjectWork
{
    class HomeDisplayData
    {
        public string message;
        public bool haveData;
        public List<GameCount> GameCount;
        public List<PlayerHighScore> PlayerHighScore;
    }
}
