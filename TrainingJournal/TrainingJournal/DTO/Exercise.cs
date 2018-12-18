using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TrainingJournal.DTO
{
    public class Exercise
    {
        public IList<ExerciseSet> ExerciseSetsDetail { get; set; }
        public int ExerciseEntryOrder { get; set; }
        public string ExerciseName { get; set; }
        public int ExerciseId { get; set; }

        public Exercise()
        {

        }

        public Exercise(IList<ExerciseSet> exerciseSetsDetail, int exerciseEntryOrder,string exerciseName, int exerciseId)
        {
            ExerciseSetsDetail = exerciseSetsDetail;
            ExerciseEntryOrder = exerciseEntryOrder;
            ExerciseName = exerciseName;
            ExerciseId = exerciseId;
        }

    }
}