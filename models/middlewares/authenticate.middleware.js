module.exports.authenticate = (req,res,next)=>{
    if(!req.body.username){
        res.send("Invalid Username or Password");
        return;
    }
    if(!req.body.password){
        res.send("Invalid Username or Password");
        return;
    }
    next();
};