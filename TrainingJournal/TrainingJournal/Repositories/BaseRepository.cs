using System;
using System.Data.SqlClient;
using System.Configuration;

namespace TrainingJournal.Repositories
{
    public abstract class BaseRepository
    {
        private string _connectionString { get; set; }


        protected BaseRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        protected BaseRepository()
        {

            _connectionString = ConfigurationManager.ConnectionStrings["TrainingJournalDb"].ConnectionString;
        }

        protected SqlConnection GetConnection()
        {
            return new SqlConnection(_connectionString);
        }
    }


}