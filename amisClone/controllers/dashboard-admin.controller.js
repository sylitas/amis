module.exports.getDashboard_admin = (req,res)=>{
    if(!req.signedCookies.admin){
        res.redirect("/");
    }else{
        res.render("dashboard-admin");
    }
    
};
