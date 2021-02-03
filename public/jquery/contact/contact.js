$(document).ready(function() {
    var id;
    var tableRole = $('#dataTable-Role').DataTable({
        "scrollY":"58vh",
        // "scrollX":true,
        "paging":   true,
        "lengthMenu": [ 25, 50 , 100 , 150 ],
        "ordering": false,
        "info":     true,
        "filter": true,
        "processing": true,
        "serverSide": true,
        "ajax": {
            "type": "POST",
            "url":"http://localhost:1999/contact/postDataForClientTable"
        },
        "columns": [
            {"data": "name"}, 
            {"data": "phone"},
            {"data": "email"},
            {"data": "location"},
            {"data": "tax"},
            {"data": "ot"},
            {"data": "bc"}
        ],
        "createdRow":function(row,data,dataIndex,cells){
            if(dataIndex == 0){
                $(row).addClass( 'table-primary' );
                id = data.id;
            }
        },
        "rowId": function(a) {
            return a.id;
        },
        "language": {
            searchPlaceholder: "Search Client Name"
        }
    });
    //row of datatable clicked
    $("#dataTable-Role").on('click','tr',function(){
        id = tableRole.row( this ).id();
        //addclass
        $(this).siblings().removeClass('table-primary');
        $(this).addClass('table-primary');
    });
    //delete buttom clicked
    $("#delete").click(function(){
        if(id){
            var cf = confirm("Are you sure want to delete it ?");
            if(cf == true){
                $.ajax({
                    method:"POST",
                    url:"http://localhost:1999/contact/postDeleteDataFromTableClient",
                    data:{
                        "id":id
                    }
                }).done(function(rs){
                    tableRole.ajax.reload();
                    alert(rs);
                    id = null;
                })
            }
        }else{
            alert("Please select a row first !");
        }
    });
    //reload buttom
    $("#reload").click(function(){
        tableRole.ajax.reload();
    });
    $("#edit").click(function(){
        window.location.href = "/contact/edit?id="+id;
    });
    $('#export').click(function(){
        window.location.href="http://localhost:1999/contact/getExport";
    });
    //key Pressed
    $("html").keyup(function(e){
        if(e.keyCode == 46){
            var cf = confirm("Are you sure want to delete it ?");
            if(cf == true){
                $.ajax({
                    method:"POST",
                    url:"http://localhost:1999/contact/postDeleteDataFromTableClient",
                    data:{
                        "id":id
                    }
                }).done(function(rs){
                    tableRole.ajax.reload();
                    alert(rs);
                });
            }
        }
    });
    //set inactive all
    $('#add').prop('disabled', true);
    $('#edit').prop('disabled', true);
    $('#delete').prop('disabled', true);
    $('#grantPermission').prop('disabled', true);
    $('#export').prop('disabled', true);
    //if true set active
    if($('p[id=check_use]').text()=="true"){
        $('#grantPermission').prop('disabled', false);
    }
    if($('p[id=check_add]').text()=="true"){
        $('#add').prop('disabled', false);
    }
    if($('p[id=check_edit]').text()=="true"){
        $('#edit').prop('disabled', false);
    }
    if($('p[id=check_del]').text()=="true"){
        $('#delete').prop('disabled', false);
    }
    if($('p[id=check_export]').text()=="true"){
        $('#export').prop('disabled', false);
    }
}); 
