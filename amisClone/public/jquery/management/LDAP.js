$(document).ready(function() {
    var tableRole;
    if($("input[name=ip]").val()){
        $("#status").css("color","green");
        $("#status").text("Connected !");
    }else{
        $("#status").css("color","red");
        $("#status").text("Disconnected !");
    }
    $('#submitConnection').click(function(e){
        e.preventDefault();
        var data = $('#createConnection').serializeArray();
        var ip = data[0].value;
        var baseDN = data[1].value;
        var username = data[2].value;
        var password = data[3].value;
        if(!ip){
            alert("Invalid Data!");
            return;
        }
        if(!baseDN){
            alert("Invalid Data!");
            return;
        }
        if(!username){
            alert("Invalid Data!");
            return;
        }
        if(!password){
            alert("Invalid Data!");
            return;
        }
        $.ajax({
            type: "POST",
            url: "http://localhost:1999/management/LDAP/postAuthLDAPPage",
            data: {
                "ip":ip,
                "baseDN":baseDN,
                "username":username,
                "password":password
            }
        }).done((rs)=>{
            if(rs == true){
                $("#status").css("color", "green");
                $("#status").text("Connected !");
            }else{
                $("#status").css("color", "red");
                $("#status").text("Disconnected !");
                alert("Wrong Information");
            }
        });
    });
    $("#cl_LDAPuser").click(function () {
        tableRole = $('#dataTable-LDAPuser').DataTable({
            "scrollY":"60vh",
            "paging":   false,
            "ordering": false,
            "info":     true,
            "filter":true,
            "processing": true,
            "serverSide": true,
            "ajax": {
                "type": "POST",
                "url":"http://localhost:1999/management/LDAP/postDataForLDAPuser"
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
    $("#cl_LDAP").click(function () {
        if ($.fn.DataTable.isDataTable('#dataTable-LDAPuser' )) {
            tableRole.destroy();
        }
    });
    $("#cl_").click(function () {
        if ($.fn.DataTable.isDataTable('#dataTable-LDAPuser' )) {
            tableRole.destroy();
        }
    });
    $("#sync").click(function(){
        $.ajax({
            type: "POST",
            url: "http://localhost:1999/management/LDAP/syncDataToDatabase"
        }).done(function(rs){
            alert(rs);
        });
    });
});