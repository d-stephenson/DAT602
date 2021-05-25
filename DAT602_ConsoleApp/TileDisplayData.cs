using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace DAT602_ConsoleApp
{
    class TileDisplayData
    {
        public string message;
        public bool haveTile;
        public List<TileInfo> TileInfo;
    }
}
