$(document).ready(function() {
    var id;
    var tableRole = $('#dataTable-Role').DataTable({
        "scrollY":"70vh",
        "scrollX":true,
        "paging":   false,
        "ordering": false,
        "info":     false,
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
            {"data": "address"},
            {"data": "tax"},
            {"data": "ot"},
            {"data": "bc"}
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
            searchPlaceholder: "Search Client"
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
    //submit adding new customer
    $("#submitAddingRole").click(function(e){
        e.preventDefault();
        var name = $('input[name=name]').val();
        var phone = $('input[name=phone]').val();
        var email = $('input[name=email]').val();
        if($('select[name=calc_shipping_provinces] option:selected').text() != "City"){
            var city = $('select[name=calc_shipping_provinces] option:selected').text();
        }else{
            var city = null;
        }
        var district = $('select[name=calc_shipping_district]').val();
        var address = $('input[name=address]').val();
        var tax = $('input[name=tax]').val();
        var bc = $('input[name=bc]').val();
        var toc = $('select[name=toc]').val();
        if(!name){
            alert("Invalid Name");
        }else{
            $.ajax({
                method:"POST",
                url:"http://localhost:1999/contact/postAddingClientInformation",
                data:{
                    "name":name,
                    "phone":phone,
                    "email":email,
                    "city":city,
                    "district":district,
                    "address":address,
                    "tax":tax,
                    "bc":bc,
                    "toc":toc
                }
            }).done(function(rs){
                alert(rs);
                tableRole.ajax.reload();
                $('input[name=name]').val("");
                $('input[name=phone]').val("");
                $('input[name=email]').val("");
                $('select[name=calc_shipping_provinces]').val(null);
                $('select[name=calc_shipping_district]').val(null);
                $('input[name=address]').val("");
                $('input[name=tax]').val("");
                $('input[name=bc]').val("");
                $("#addRole").modal("hide");
            })
        }
    });
    //reload buttom
    $("#reload").click(function(){
        tableRole.ajax.reload();
    });
    //get information when edit buttom clicked
    $("#edit").click(function(){
        $.ajax({
            method:"POST",
            url:"http://localhost:1999/contact/postDataForEdit",
            data:{
                "id":id
            }
        }).done(function(rs){
            if(rs == "err"){
                alert("Please select a row first !");
                $("#editer").modal("hide");
            }else if(rs == "err2"){
                alert("No Permission!");
                $("#editer").modal("hide");
            }else{
                $('input[name=edit_name]').val(rs.name);
                $('select[name=edit_toc]').val(rs.toc);
                $('input[name=edit_phone]').val(rs.phone);
                $('input[name=edit_email]').val(rs.email);
                $('input[name=edit_address]').val(rs.address);
                $('input[name=edit_tax]').val(rs.tax);
                $('input[name=edit_bc]').val(rs.bc);
            }
        });
    });
    //submit editing
    $("#submitEditingRole").click(function(e){
        e.preventDefault();
        var name = $('input[name=edit_name]').val();
        var phone = $('input[name=edit_phone]').val();
        var email = $('input[name=edit_email]').val();
        var address = $('input[name=edit_address]').val();
        var tax = $('input[name=edit_tax]').val();
        var bc = $('input[name=edit_bc]').val();
        var toc = $('select[name=edit_toc]').val();

        $.ajax({
            method:"POST",
            url:"http://localhost:1999/contact/postEditData",
            data:{
                "id":id,
                "name":name,
                "phone":phone,
                "email":email,
                "address":address,
                "tax":tax,
                "bc":bc,
                "toc":toc
            }
        }).done(function(rs){
            tableRole.ajax.reload();
            $("#editer").modal("hide");
            alert(rs);
        });
    });
    //cancel when adding customer
    $("#cancelAddingRole").click(function(){
        $('input[name=name]').val("");
        $('input[name=phone]').val("");
        $('input[name=email]').val("");
        $('input[name=address]').val("");
        $('input[name=tax]').val("");
        $('input[name=bc]').val("");
        $('select[name=calc_shipping_provinces]').val(null);
        $('select[name=calc_shipping_district]').val(null);
        //$("#addRole").modal("hide");
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
