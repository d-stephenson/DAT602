using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace ProjectWork
{
    public class GemSelection
    {
        public string GemType;
        public int Points;
        public int ItemID;
        public int GameID;
        public int PlayerID;
        public int PlayID;
        public int TileID;


        // 		ge.GemType, Points, 'ItemID', pl.GameID AS 'GameID', pl.PlayerID AS 'PlayerID', pl.PlayID AS 'PlayID', pl.TileID AS 'TileID'
    }
}
