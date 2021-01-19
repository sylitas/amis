$(document).ready(function() {
    $('#submitConnection').click(function(e){
        e.preventDefault();
        var data = $('#createConnection').serializeArray();
        console.log(data)
    });
});