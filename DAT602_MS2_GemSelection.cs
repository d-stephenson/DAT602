using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace DAT602_ConsoleApp
{
    class GemSelection
    {
        public int ItemID;
        public string GemType;
        public int Points;
        public int GameID;
        public int PlayerID;
        public int PlayID;
        public int TileID;


        // 		ItemID, ge.GemType, Points, pl.GameID, pl.PlayerID, pl.PlayID, pl.TileID
    }
}
