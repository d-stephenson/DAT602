﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace ProjectWork
{
    public class GameCount
    {
        public int GameID;
        public int PlayerCount;


        // 		SELECT GameID AS 'Game ID', COUNT(pl.GameID) AS 'Player Count'
    }
}
