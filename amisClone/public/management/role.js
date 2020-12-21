$(document).ready(function() {
    var id;
    var tableRole = $('#dataTable-Role').DataTable({
        "scrollY":"35vh",
        "paging":   false,
        "ordering": false,
        "info":     false,
        "filter":false,
        "processing": true,
        "serverSide": true,
        "ajax": {
            "type": "POST",
            "url":"http://localhost:1999/management/role/postDataByAjax"
        },
        "columns": [
            {"data": "id"}, 
            {"data": "name"},
            {"data": "note"}
        ],
        "createdRow":function(row,data,dataIndex,cells){
            if(data.id == 1){
            $(row).addClass( 'table-primary' );
            }
        },
        "rowId": function(a) {
            return a.id;
        },
        "language": {
            searchPlaceholder: "Search Role"
        }
    });
    var tableUser = $('#dataTableUser').DataTable({
        "scrollY":"50vh",
        "paging":   false,
        "ordering": false,
        "info":     false,
        // "processing": true,
        // "serverSide": true,
        // "ajax": {
        //     "type": "POST",
        //     "url":"http://localhost:1999/management/role/postUserDataByAjax"
        // },
        // "columns": [
        //     {"data": "id"}, 
        //     {"data": "username"},
        //     {"data": "fullname"},
        //     {"data": "title"},
        //     {"data": "place"},
        //     {"data": "desc"}
        // ],
        // "rowId": function(a) {
        //     return a.id;
        // },
        "language": {
            searchPlaceholder: "Search Username"
        }
    });
    var tableContained = $('#dataTable-contained').DataTable({
        "scrollY":"20vh",
        "paging":   false,
        "ordering": false,
        "info":     false,
        "filter": false,
        "processing": true,
        "serverSide": true,
        "ajax": {
            "type": "POST",
            "url":"http://localhost:1999/management/role/postUserInRoleByAjax"
        }
    });
    $("#delete").click(function(){
    var cf = confirm("Are you sure want to delete a role ?");
    if(cf == true){
        if($("tr").hasClass("table-primary")){
        id = $(".table-primary").find("td:first-child").text();
        }else{
        id = 1;
        }
        $.ajax({
        method:"POST",
        url:"http://localhost:1999/management/role/deleteRole",
        data:{"id":id}
        }).done(function(notif){
        tableRole.ajax.reload();
        });
    }
    });   
    $("#dataTable-Role").on('click','tr',function(){
    id = tableRole.row( this ).id();
    //addclass
    $(this).siblings().removeClass('table-primary');
    $(this).addClass('table-primary');
    //for reload table
    tableContained.destroy();
    tableContained.clear();
    tableContained = $('#dataTable-contained').DataTable({
        "scrollY":"20vh",
        "paging":   false,
        "ordering": false,
        "info":     false,
        "filter": false,
        "serverSide": true,
        "ajax": {
        "type": "POST",
        "url":"/management/role/postUserInRoleByAjax",
        "data":{
            "id":id
        }
        }
    });
    });
    $("#submitAddingRole").click(function(e){
    e.preventDefault();
    if(!$('input[name="role"]').val()){
        alert("Invalid data !");
        return; 
    }
    var role = $('input[name="role"]').val();
    var note = $('textarea[name="note"]').val();
    $.ajax({
        method:"POST",
        url:"http://localhost:1999/management/role/addNewRole",
        data:{
        "role":role,
        "note":note
        }
    }).done(function(err){
        tableRole.ajax.reload();
        $('input[name="role"]').val("");
        $('textarea[name="note"]').val("");
        if(err == "false"){
        alert("This role is already exist !");
        }else{
        alert("Role created!");
        }
        $("#addRole").modal("hide");
    });
    });
    $("#edit").click(function(){
    if($("tr").hasClass("table-primary") == true){
        id = $(".table-primary").find("td:first-child").text();
    }else{
        id = 1;
    }
    $.ajax({
        method:"POST",
        url:"http://localhost:1999/management/role/takeValueForEditRole",
        data:{
        "id":id
        }
    }).done(function(data){
        if(data=="false"){alert("Invalid Data!")}else{
        $("#inputNameRole").val(data.name);
        $("#inputNoteRole").val(data.note);
        }
    });
    });
    $("#submitEdit").click(function(e){
    e.preventDefault();
    if($("tr").hasClass("table-primary") == true){
        id = $(".table-primary").find("td:first-child").text();
    }else{
        id = 1;
    }
    var name = $("#inputNameRole").val();
    var note = $("#inputNoteRole").val();
    $.ajax({
        method:"POST",
        url:"http://localhost:1999/management/role/postEditRole",
        data:{
        "id": id,
        "name": name,
        "note": note
        }
    }).done(function(data){
        if(data == "false"){
        alert("Role is already exist");
        }else{
        $("#editer").modal("hide");
        tableRole.ajax.reload();
        }
    });
    });
    $("#reload").click(function(){
    tableRole.ajax.reload();
    tableContained.ajax.reload();
    });
});