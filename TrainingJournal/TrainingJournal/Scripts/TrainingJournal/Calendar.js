
$(document).on("click", "#prev-month-btn", function () {
    /** get calc'd prev month from view (hidden) **/
    var yearMonth = $("#prev-month").attr("value");
    populateCalendar(yearMonth);
})

$(document).on("click", "#next-month-btn", function () {
    /** get calc'd next month from view (hidden) **/
    var yearMonth = $("#next-month").attr("value");
    populateCalendar(yearMonth);
})

function populateCalendar(yearMonth) {
    $.ajax({
        type: 'POST',
        data: { yearMonth: yearMonth },
        url: "/TrainingJournal/PopulateCalendar" /**' @url.Action("PopulateCalendar", "Home")'**/,
        success: function (results) {
            $('#calendar-container').html(results);
        },
        error: function (xhr, textStatus, error) {
            alert(xhr.responseText);
        }
    });
}

$(document).on("click", ".days > .trained", function () {
    var calendarDate = $(this).data("calendar-date-id");
    //var trainingLogId = $(this).data("training-log-id");
    //alert(trainingLogId);
    //alert(calendarDate);

    if (calendarDate) {
        window.location = '/TrainingJournal/JournalEntry?calendarDate=' + calendarDate;
    }
});

/*$(document).on("click", ".days > .active", function () {
    var trainingLogId = $(this).data("training-log-id");
    alert(trainingLogId);
})*/

$(document).on("click", ".active", function () {
    var trainingLogId = $(this).parent().data("training-log-id");
    if (trainingLogId != -1) {
        alert("session availale");
    }
    else if (confirm("create a new session?")) {
        alert("ok create new session");
    }
});
