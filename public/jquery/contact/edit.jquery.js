$(document).ready(function() {
    var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = window.location.search.substring(1),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;
    
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
    
            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
            }
        }
    };
    let id = getUrlParameter('id');
    $.ajax({
        method:"POST",
        url:"http://localhost:1999/contact/postDataForEdit",
        data:{
            "id":id
        }
    }).done(function(rs){
        if(rs == "err"){
            alert("Please select a row first !");
        }else if(rs == "err2"){
            alert("No Permission!");
        }else{
            $("input[name=cc]").val(rs.code);
            $("input[name=cl]").val(rs.list);
            $("input[name=name]").val(rs.name);
            $("input[name=cg]").val(rs.group);
            $("input[name=toc]").val(rs.toc);
            $("input[name=sc]").val(rs.sc);
            $("input[name=dob]").val(rs.dob);
            $("input[name=numberId]").val(rs.numberId);
            $("input[name=dateId]").val(rs.dateId);
            $("input[name=place]").val(rs.place);
            $("input[name=phone]").val(rs.phone);
            $("input[name=fax]").val(rs.fax);
            $("input[name=pc]").val(rs.pc);
            $("input[name=email]").val(rs.email);
            $("select[name=calc_shipping_provinces]").val(rs.city);
            $("select[name=calc_shipping_provinces]").change();
            $("select[name=calc_shipping_district]").val(rs.district);
            $("input[name=address]").val(rs.address);
            $("input[name=tp]").val(rs.tp);
            $("input[name=tax]").val(rs.tax);
            $("input[name=numberBank]").val(rs.numberBank);
            $("input[name=bc]").val(rs.bc);
            $("input[name=branch]").val(rs.branch);
        }
    });
    //submit editing
    $("#submitEditingRole").click(function(e){
        e.preventDefault();
        var data = $("#editForm").serializeArray();
        if($('select[name=calc_shipping_provinces] option:selected').text() != "City"){
            data[14].value = $('select[name=calc_shipping_provinces] option:selected').text();
        }else{
            data[14].value = '';
        }
        if(!data[2].value){
            alert('Missing Fill "Name"');
        }else{
            $.ajax({
                method:"POST",
                url:"http://localhost:1999/contact/postEditData",
                data:{
                    "id":id,
                    "data":data
                }
            }).done(function(rs){
                window.location.href = "/contact";
            })
        }
    });
});