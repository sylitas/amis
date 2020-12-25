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
    var tableAction = $('#action').DataTable({
        "scrollY":"50vh",
        "paging":   false,
        "ordering": false,
        "info":     false,
        "filter":false,
        "processing": true,
        "serverSide": true,
        "ajax": {
            "type": "POST",
            "url":"http://localhost:1999/management/role/postActionData",
            "data":{
                "fId":1,
                "urId":1
            }
        },
        "columns": [
            {"data": "id"}, 
            {"data": "name"}
        ],
        "rowId": function(a) {
            return a.id;
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
    $('#addingUser').on('submit', function(e){
        var arr_rows = [];
        id = $(".table-primary").find("td:first-child").text();
        var rows_selected = tableUser.column(0).checkboxes.selected();
        $.each(rows_selected, function(index, rowId){
            arr_rows.push(rowId);
        });
        if(arr_rows.length>0){
            $.ajax({
                method:"POST",
                url:"http://localhost:1999/management/role/postDataForAddingUser",
                data:{
                    "userId":arr_rows,
                    "roleId":id
                }
            }).done(function(rs){
                if(rs=="false2"){
                    alert("Invalid Data");
                }
                tableUser.columns(0).checkboxes.deselectAll()
                tableContained.ajax.reload();
                $("#addUser").modal("hide");
            });
        }else{
            alert("Invalid Data");
        }
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
        if($("tr").hasClass("table-inew")){
            var cf = confirm("Are you sure want to remove this user ?");
            if(cf == true){
                var roleId = $(".table-primary").find("td:first-child").text();
                var userId = $(".table-inew").find("td:first-child").text();
                $.ajax({
                    url:"http://localhost:1999/management/role/postDeleteUserInRole",
                    method:"POST",
                    data:{
                        "userId":userId,
                        "roleId":roleId
                    }
                }).done(function(rs){
                    tableContained.ajax.reload();
                });
            }
        }else{
            alert("Please choose an user for using remove function !");
        }
    });
    $("#dataTable-contained").on('click','tr',function(){
        if($(this).hasClass('table-inew')){
            $(this).removeClass('table-inew');
        }else{
            $(this).siblings().removeClass('table-inew');
            $(this).addClass('table-inew');
        }
    });
    $("#grantPermission").click(function(){
        $.ajax({
            method:"POST",
            url:"http://localhost:1999/management/role/postFuction"
        }).done(function(rs){
            if(!$('li').hasClass("functionList")){
                for(var i=0;i<rs.length;i++){
                    $(".nested").append('<li id="'+rs[i].id+'" class= "functionList">'+rs[i].name+"</li>");
                }
            }
        });
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
    $(document).on("click",".functionList",function(){
        var fId = $(this).attr('id');
        var urId = $(".table-primary").find("td:first-child").text();
        //add css class when click
        $(this).addClass("table-lmao");
        $(this).siblings().removeClass('table-lmao');
        //query data from new id
        tableAction.destroy();
        tableAction = $('#action').DataTable({
            "scrollY":"50vh",
            "paging":   false,
            "ordering": false,
            "info":     false,
            "filter":false,
            "processing": true,
            "serverSide": true,
            "ajax": {
                "type": "POST",
                "url":"http://localhost:1999/management/role/postActionData",
                "data":{
                    "fId":fId,
                    "urId":urId
                }
            },
            "columns": [
                {"data": "id"}, 
                {"data": "name"}
            ],
            "rowId": function(a) {
                return a.id;
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
    });
    $('#submitCheckboxAction').click(function(e){
        e.preventDefault();
        var urId = $(".table-primary").find("td:first-child").text();
        if($('li').hasClass('table-lmao')){
            var functionId = $(".table-lmao").attr('id');
        }else{
            var functionId = 1;
        }
        var actionId = []
        var rows_selected = tableAction.column(0).checkboxes.selected();
        $.each(rows_selected, function(index, rowId){
            actionId.push(rowId);
        });
        $.ajax({
            url:"http://localhost:1999/management/role/postDataForPermission",
            method:"POST",
            data:{
                "fId":functionId,
                "aId":actionId,
                "urId":urId
            }
        }).done(function(rs){
            alert("Saved!");
        });
        
    });
}); 