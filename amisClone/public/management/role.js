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
        "scrollX":true,
        "paging":   false,
        "ordering": false,
        "info":     false,
        "processing": true,
        "serverSide": true,
        "ajax": {
            "type": "POST",
            "url":"http://localhost:1999/management/role/postUserDataByAjax"
        },
        "columns": [
            {"data": "id"}, 
            {"data": "username"},
            {"data": "fullname"},
            {"data": "title"},
            {"data": "place"},
            {"data": "note"}
        ],
        "rowId": function(a) {
            return a.id;
        },
        "language": {
            searchPlaceholder: "Search Username"
        },
        "columnDefs":[
            {
                'targets':0,
                'checkboxes':{
                    'selectRow':true
                }
            }
        ],
        'select': {
            'style': 'multi'
         },
        'order': [[1, 'asc']]
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
    $('#addingUser').on('submit', function(e){
        var arr_rows = [];
        id = $(".table-primary").find("td:first-child").text();
        var rows_selected = tableUser.column(0).checkboxes.selected();
        $.each(rows_selected, function(index, rowId){
            arr_rows.push(rowId);
        });
        $.ajax({
            method:"POST",
            url:"http://localhost:1999/management/role/postDataForAddingUser",
            data:{
                "userId":arr_rows,
                "roleId":id
            }
        }).done(function(rs){
            $("#addUser").modal("hide");
            tableContained.ajax.reload();
            $('input:checkbox').removeAttr('checked');
        });
        e.preventDefault();
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
    $("#deleteUserInRole").click(function(){
        var cf = confirm("Are you sure want to remove this user ?");
        if(cf == true){
            var roleId = $(".table-primary").find("td:first-child").text();
            $.ajax({
                url:"http://localhost:1999/management/role/postDeleteUserInRole",
                method:"POST",
                data:{
                    "userId":"userId",
                    "roleId":roleId
                }
            }).done(function(rs){
                alert(rs);
            });
        }
    });
    $("#dataTable-contained").on('click','tr',function(){
        $(this).siblings().removeClass('table-info');
        $(this).addClass('table-info');
    });
});