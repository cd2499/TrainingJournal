using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TrainingJournal.DTO
{
   
    public class ExerciseSet
    {
        public int ExerciseSetOrder { get; set; } 
        public int ExerciseId { get; set; }
        //public string ExerciseShortDesc { get; set; }
        public decimal WeightResistence { get; set; }  
        public int Repetitions { get; set; } 
        public string Comments { get; set; }

        public ExerciseSet()
        {

        }

        public ExerciseSet(int exerciseSetOrder/*, int exerciseId, string exerciseShortDesc*/ , decimal weightResistence, int repetitions, string comments)
        {
            ExerciseSetOrder = exerciseSetOrder;
            //ExerciseId = exerciseId;
            //ExerciseShortDesc = exerciseShortDesc;
            WeightResistence = weightResistence;
            Repetitions = repetitions;
            Comments = comments;
        }

    }
}