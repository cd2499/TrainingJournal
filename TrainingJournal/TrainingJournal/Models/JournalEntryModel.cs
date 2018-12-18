using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TrainingJournal.DTO;

namespace TrainingJournal.Models
{
    public class JournalEntryModel
    {
        public IList<Exercise> Exercises { get; set; }
        public int TrainingLogId { get; set; }
        public DateTime TrainingDateTime { get; set; }
        public string LocationShortDesc { get; set; }
        public string GroupShortDesc { get; set; }
        
        public JournalEntryModel()
        {

        }

        public JournalEntryModel(IList<Exercise> exercises, int trainingLogId, DateTime trainingDateTime, string locationShortDesc, string groupShortDesc)
        {
            this.Exercises = exercises;
            this.TrainingLogId = trainingLogId;
            this.TrainingDateTime = trainingDateTime;
            this.LocationShortDesc = locationShortDesc;
            this.GroupShortDesc = groupShortDesc;
        }
    }
}