using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TrainingJournal.Repositories;
using TrainingJournal.DTO;
using TrainingJournal.Models;

namespace TrainingJournal.Controllers
{
    public class TrainingJournalController : Controller
    {
        TrainingJournalRepository journalRepo = new TrainingJournalRepository();

        // GET: TrainingJournal
        public ActionResult Index()
        {
            int eh = journalRepo.GetNextTrainingLogId();
            return View();
        }

        public ActionResult Calendar()
        {
            string CurrentYearMonth = DateTime.Now.ToString("yyyy-MM");
            IList<CalendarDay> calendarDays = journalRepo.GetCalendarMonth(CurrentYearMonth);

            CalendarDay lastDayOfMonth = calendarDays[calendarDays.Count - 1];

            JournalCalendarModel calendarModel = new JournalCalendarModel(calendarDays
                                                                    , lastDayOfMonth.MonthName
                                                                    , lastDayOfMonth.CalendarDate.Year.ToString());

            return View(calendarModel);
        }

        public ActionResult PopulateCalendar(string yearMonth)
        {
            IList<CalendarDay> calendarDays = journalRepo.GetCalendarMonth(yearMonth);

            CalendarDay lastDayOfMonth = calendarDays[calendarDays.Count - 1];

            JournalCalendarModel calendarModel = new JournalCalendarModel(calendarDays
                                                                         , lastDayOfMonth.MonthName
                                                                         , lastDayOfMonth.CalendarDate.Year.ToString());

            return PartialView("~/Views/TrainingJournal/_Calendar.cshtml", calendarModel);
        }

        //public ActionResult JournalEntry(int trainingLogId)
        //{

        //    int logId = trainingLogId; // trainingLogId ?? journalRepo.GetCurrentActiveTrainingLogId();

        //    if (trainingLogId == -1)
        //    { //use nest id in line, to force a create of new entry from UI
        //        logId = journalRepo.GetNextTrainingLogId();                
        //    }

        //    JournalEntryModel JournalModel = journalRepo.GetTrainingLogDetails(logId);

        //    return View(JournalModel);
        //}

        [HttpGet]
        public ActionResult JournalEntry(string calendarDate)
        {

           

           JournalEntryModel JournalModel = journalRepo.GetTrainingLogDetails(calendarDate);
         //   return Redirect("/")
            return View(JournalModel);
        }

        [HttpPost]
        public ActionResult JournalEntry(string calendarDate, JournalEntryModel model)
        {

            journalRepo.SaveTrainingLogDetails(model);

            JournalEntryModel JournalModel = journalRepo.GetTrainingLogDetails(calendarDate);
            //   return Redirect("/")
            // return View(model);
            return View(JournalModel);
        }

        public void CreateJournalEntry(int exerciseGroupId, string trainingLocationSId)
        { 
            journalRepo.CreateJournalentry(exerciseGroupId, trainingLocationSId, null);
            //return call to journalentry and return view?
            int NewTrainingLogId = journalRepo.GetCurrentActiveTrainingLogId();
            System.Diagnostics.Debug.WriteLine($"new training log id {NewTrainingLogId}");
        }



        //below is actually handled through POST for now, can probably turn it into ajax call on front end and serialize model as json, then pass
        //back to here for saving, but whatever for now
        //public ActionResult SaveJournalEntry(JournalEntryModel model)
        //{
            
        //    return View("JournalEntry", model);
        //}
    }
}