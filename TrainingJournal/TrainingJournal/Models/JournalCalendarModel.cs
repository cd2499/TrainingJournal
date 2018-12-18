using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TrainingJournal.DTO;

namespace TrainingJournal.Models
{
    public class JournalCalendarModel
    {
        public IList<CalendarDay> CalendarDays { get; set; }
        public string CalendarMonth { get; set; }
        public string CalendarYear { get; set; }

        public JournalCalendarModel()
        {

        }

        public JournalCalendarModel(IList<CalendarDay> calendarDays, string calendarMonth, string calendarYear)
        {
            CalendarDays = calendarDays;
            CalendarMonth = calendarMonth;
            CalendarYear = calendarYear;
        }
    }
}