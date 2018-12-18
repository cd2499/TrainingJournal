using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TrainingJournal.DTO
{
    public class CalendarDay
    {
        public DateTime CalendarDate { get; set; }
        public string CalendarDateStr { get; set; }
        public int DateNumber { get; set; }
        public int DayOfMonthNumber { get; set; }
        public string DayOfWeekName { get; set; }
        public string MonthName { get; set; }
        public string ExcerciseGroup { get; set; }
        public bool IsToday { get; set; }
        public bool IsPreviousMonth { get; set; }
        public int TrainingLogId { get; set; }

        public CalendarDay()
        {

        }

        public CalendarDay(DateTime calendarDate, string calendarDateStr, int dateNumber, int dayOfMonthNumber, string dayOfWeekName, string monthName, string excerciseGroup, bool isToday, bool isPreviousMonth, int trainingLogId)
        {
            CalendarDate = calendarDate;
            CalendarDateStr = calendarDateStr;
            DateNumber = dateNumber;
            DayOfMonthNumber = dayOfMonthNumber;
            DayOfWeekName = dayOfWeekName;
            MonthName = monthName;
            ExcerciseGroup = excerciseGroup;
            IsToday = isToday;
            IsPreviousMonth = isPreviousMonth;
            TrainingLogId = trainingLogId;
        }
    }
}