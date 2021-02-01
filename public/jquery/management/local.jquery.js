$(document).ready(function() {
    $('#userLocal').DataTable({
        "scrollY":"60vh",
        "paging":   true,
        "lengthMenu": [ 25, 50 , 100 , 150 ],
        "ordering": true,
        "info":     true,
        "filter":true,
        "processing": true,
        "serverSide": true,
        "ajax": {
            "type": "POST",
            "url":"http://localhost:1999/management/user/local/postDataForUserLocal"
        },
        "columns": [
            {"data": "name"}, 
            {"data": "fullname"},
            {"data":"email"},
            {"data": "description"},
            {"data": "status"}
        ],"createdRow":function(row,data,dataIndex,cells){
            if(data.status == "active"){
                $(cells[4]).css("color","green");
            }
            if(data.status == "inactive"){
                $(cells[4]).css("color","red");
            }
        },
        "language": {
            searchPlaceholder: "Search Full Name"
        }
    });
});