﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace ProjectWork
{
    public class GemDisplayData
    {
        public string message;
        public bool haveGem;
        public List<GemSelection> GemSelection;
    }
}
