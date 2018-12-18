
// Shorthand for $( document ).ready()
$(function () {
    var url_string = window.location.href;
    var url = new URL(url_string);
    var calendarDate = url.searchParams.get("calendarDate");
    console.log(calendarDate);
});


$(document).on("click", "#submit-entry-btn", function () {

    var exerciseGroup = $('#exercise-group-select').find(":selected").val();
    var trainingLocation = $('#training-location-select').find(":selected").val();

    alert("exercisegroup " + exerciseGroup);
    alert("trainingLocation " + trainingLocation);

    $.ajax({
        type: 'POST',
        data: {
            exerciseGroupId: exerciseGroup,
            trainingLocationSId: trainingLocation
        },
        url: "/TrainingJournal/CreateJournalEntry",
        success: function (results) {
            alert(results);
        },
        error: function (xhr, textStatus, error) {
            alert(xhr.responseText);
        }
    });
})


