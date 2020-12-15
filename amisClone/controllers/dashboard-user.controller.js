module.exports.getDashboard_user = (req,res)=>{
    if(!req.signedCookies.login){
        res.redirect("/");
    }else{
        res.render("dashboard-user");
    }
    
};
