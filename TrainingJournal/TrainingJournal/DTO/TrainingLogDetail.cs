using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TrainingJournal.DTO
{
    public class TrainingLogDetail
    {
        public int TrainingLogId { get; set; }   //TrainingDay level
        public DateTime TrainingDateTime { get; set; } //TrainingDay level
        public string LocationShortDesc { get; set; } //TrainingDay level
        public string GroupShortDesc { get; set; } //TrainingDay Level
        public int TrainingLogOrder { get; set; }  //Exercise level
        public int ExerciseId { get; set; } //exercise level
        public string ExerciseShortDesc { get; set; } //Exercise leel
        public int ExerciseSetOrder { get; set; } //ExerciseSet level
        public decimal WeightResistence { get; set; }  //ExerciseSet level
        public int Repetitions { get; set; } //ExerciseSet level
        public string Comments { get; set; } //ExerciseSet level

        public TrainingLogDetail()
        {

        }

        public TrainingLogDetail(int trainingLogId, DateTime trainingDateTime, string locationShortDesc, string groupShortDesc, int trainingLogOrder, int exerciseId, string exerciseShortDesc, int exerciseSetOrder, decimal weightResistence, int repetitions, string comments)
        {
            TrainingLogId = trainingLogId;
            TrainingDateTime = trainingDateTime;
            LocationShortDesc = locationShortDesc;
            ExerciseId = exerciseId;
            GroupShortDesc = groupShortDesc;
            TrainingLogOrder = trainingLogOrder;
            ExerciseShortDesc = exerciseShortDesc;
            ExerciseSetOrder = exerciseSetOrder;
            WeightResistence = weightResistence;
            Repetitions = repetitions;
            Comments = comments;
        }
    }
}