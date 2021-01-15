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
            {"data":"location"},
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
            searchPlaceholder: "Search Client Name"
        }
    });
    //click addRole
    $('#addRole').click(function(){
        $('select[name=toc]').val(1);
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
        var data = $("#addingRole").serializeArray();
        if($('select[name=calc_shipping_provinces] option:selected').text() != "City"){
            data[14].value = $('select[name=calc_shipping_provinces] option:selected').text();
        }else{
            data[14].value = '';
        }
        if(!data[14].value){
            alert("Please Choose The Location");
            return;
        }
        if(!data[2].value){
            alert('Missing Fill "Name"');
        }else{
            $.ajax({
                method:"POST",
                url:"http://localhost:1999/contact/postAddingClientInformation",
                data:{
                    "data":data
                }
            }).done(function(rs){
                alert(rs);
                tableRole.ajax.reload();
                $("form#addingRole :input[type=text]").each(function(){
                    var input = $(this);
                    input.val("");
                });
                $("form#addingRole select").each(function(){
                    var input = $(this);
                    input.val(null);
                });
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
                $("#editForm input[name=cc]").val(rs.code);
                $("#editForm input[name=cl]").val(rs.list);
                $("#editForm input[name=name]").val(rs.name);
                $("#editForm input[name=cg]").val(rs.group);
                $("#editForm input[name=toc]").val(rs.toc);
                $("#editForm input[name=sc]").val(rs.sc);
                $("#editForm input[name=dob]").val(rs.dob);
                $("#editForm input[name=numberId]").val(rs.numberId);
                $("#editForm input[name=dateId]").val(rs.dateId);
                $("#editForm input[name=place]").val(rs.place);
                $("#editForm input[name=phone]").val(rs.phone);
                $("#editForm input[name=fax]").val(rs.fax);
                $("#editForm input[name=pc]").val(rs.pc);
                $("#editForm input[name=email]").val(rs.email);
                $("#editForm select[name=calc_shipping_provinces]").val(rs.city);
                $("#editForm select[name=calc_shipping_district]").val(rs.district);
                $("#editForm input[name=address]").val(rs.address);
                $("#editForm input[name=tp]").val(rs.tp);
                $("#editForm input[name=tax]").val(rs.tax);
                $("#editForm input[name=numberBank]").val(rs.numberBank);
                $("#editForm input[name=bc]").val(rs.bc);
                $("#editForm input[name=branch]").val(rs.branch);
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
        $("form#addingRole :input[type=text]").each(function(){
            var input = $(this);
            input.val("");
        });
        $("form#addingRole select").each(function(){
            var input = $(this);
            input.val(null);
        });
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
