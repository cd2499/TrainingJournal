using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using Dapper;
using TrainingJournal.DTO;
using TrainingJournal.Models;

namespace TrainingJournal.Repositories
{
    public class TrainingJournalRepository:BaseRepository
    {
        #region dbo object constant names
        public const string GetTrainingLogDetailsProc = "[journal].[GetTrainingLogDetails]";
        public const string SetTrainingLogProc = "[journal].[SetTrainingLog]";
        public const string GetCalendarMonthProc = "[journal].[GetCalendarMonth]";
        #endregion

        public int GetNextTrainingLogId()
        {
            using (IDbConnection db = GetConnection())
            {
                return db.Query<int>
                    ("SELECT journal.PeekNextTrainingLogId()").ToList().FirstOrDefault();
            }
        }

        public int GetCurrentActiveTrainingLogId()
        {
            using (IDbConnection db = GetConnection())
            {
                return db.Query<int>
                    ("SELECT journal.GetCurrentActiveTrainingLogId()").ToList().FirstOrDefault();
            }
        }


        //public IList<Exercise> GetTrainingLogDetails()
        // public JournalEntryModel GetTrainingLogDetails(int trainingLogId)
        public JournalEntryModel GetTrainingLogDetails(string calendarDate)
        {
            IList<TrainingLogDetail> QueryResults;
            
            //Get all details from training log for a given day
            using (IDbConnection db = GetConnection())
            {
                QueryResults = db.Query<TrainingLogDetail>
                    (GetTrainingLogDetailsProc, new { TrainingDateStr = calendarDate }, commandType: CommandType.StoredProcedure).ToList();
            }

           if(QueryResults.Count > 0)
            { 
            //Begin break out into objects for model

                //find total number of exercises completed in training log entry for the day
                int TotalExerciseCount = QueryResults.OrderByDescending(x => x.TrainingLogOrder).FirstOrDefault().TrainingLogOrder;

                //new object for results
                IList<Exercise> TrainingLogEntryExercises = new List<Exercise>();
                
                //loop through each exercise within training day and create as seperate object
                for (int i = 1; i <= TotalExerciseCount; i++)
                {
                    IList<ExerciseSet> SetsForExercise = new List<ExerciseSet>();

                    var ExerciseToAdd = QueryResults.Where(o => o.TrainingLogOrder == i);

                    foreach(var detail in ExerciseToAdd)
                    {
                        SetsForExercise.Add(new ExerciseSet(detail.ExerciseSetOrder
                                                           ,detail.WeightResistence
                                                           ,detail.Repetitions
                                                           ,detail.Comments));
                    }

                    int ExerciseSequence = i;
                    string ExerciseName = ExerciseToAdd.FirstOrDefault().ExerciseShortDesc;
                    int ExerciseId = ExerciseToAdd.FirstOrDefault().ExerciseId;

                    TrainingLogEntryExercises.Add(new Exercise(SetsForExercise, ExerciseSequence, ExerciseName, ExerciseId));
                }

                int TrainingLogId = QueryResults.FirstOrDefault().TrainingLogId;
                DateTime TrainingDateTime = QueryResults.FirstOrDefault().TrainingDateTime;
                string LocationShortDesc = QueryResults.FirstOrDefault().LocationShortDesc;
                string GroupShortDesc = QueryResults.FirstOrDefault().GroupShortDesc;
                return (new JournalEntryModel(TrainingLogEntryExercises, TrainingLogId, TrainingDateTime, LocationShortDesc, GroupShortDesc));
            }
            else
            {
                return null; //new JournalEntryModel());
            }
        }
        
        public void SaveTrainingLogDetails(JournalEntryModel saveModel)
        {




        }


        //public void SaveJournalEntry(JournalEntryModel model)
        //{
        //    //flatten model

        //}


        public void CreateJournalentry(int exerciseGroupId, string trainingLocationSId, int? trainingLogId)
        {            
            using (IDbConnection db = GetConnection())
            {
                db.Query(SetTrainingLogProc, new { ExerciseGroupId = exerciseGroupId, TrainingLocationSId = trainingLocationSId }, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public IList<CalendarDay> GetCalendarMonth(string yearMonth)
        {
            IList<CalendarDay> ResultSet;

            using (IDbConnection db = GetConnection())
            {
                ResultSet = db.Query<CalendarDay>
                    (GetCalendarMonthProc, new { YearMonth = yearMonth }, commandType: CommandType.StoredProcedure).ToList();
            }

            return ResultSet;
        }


    }
}