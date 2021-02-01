$(document).ready(function() {
    $("select[name=calc_shipping_provinces]").val(null);
    $('select[name=toc]').val(1);
    $("#submitAddingRole").click(function(e){
        e.preventDefault();
        var data = $("#addingRole").serializeArray();
        console.log(data);
        if(!data[0].value){
            alert('Please fill the "*" tag');
            return;
        }
        if(!data[2].value){
            alert('Please Fill full the "*" tag');
            return;
        }
        if(!data[4].value){
            alert('Please Fill full the "*" tag');
            return;
        }
        if($('select[name=calc_shipping_provinces] option:selected').text() != "City"){
            data[14].value = $('select[name=calc_shipping_provinces] option:selected').val();
        }else{
            data[14].value = '';
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
                window.location.href = "/contact";
            })
        }
    });
});