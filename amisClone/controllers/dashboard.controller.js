module.exports.getDashboard = (req,res)=>{
    if(!req.signedCookies.login){
        res.redirect("/");
    }else{
        res.render("dashboard");
    }
    
};