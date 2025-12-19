import mongoose,{Schema} from "mongoose";
import bycrpt from "bcrypt";
import Jsonwebtoken from "jsonwebtoken";

const userSchema = new Schema({
    name : {
        type :  String,
        required : true,
        lowercase: true,
        trim : true,
        index : true
    },
     email :{
        type : String,
        required : true,
        unique : true,
        lowercase : true,
        trim : true,
        validate : {
            validator : (value)=>{
                const re =  /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re)
            },
            message: 'Enter a valid Email'

            
        }
    },
    password :{
        type : String,
        required : true,
        validate : {
            validator :(value)=> {
                return value.length > 6

            },
             message: 'Password should be Greather then 6 Number'
        }
    },

    resetPasswordToken: {
    type: String,
    default : "",
    
    },
    resetPasswordExpiry: {
    type: Date,
    default : "",
    
    },
    type : {
        type : String,
        default : "user",
    },
    refreshToken: {
        type: String,
        default: "",
    },
    


},{timestamps : true});
userSchema.pre("save",async function (next){
    //if pasword is modified then bycrpt
    // if password is not modified
    if(!this.isModified('password')) return next();
    this.password = await bycrpt.hash(this.password,10)
    next()
});

userSchema.methods.ispasswordCorrect =  async function (password){
    return await bycrpt.compare(password,this.password)
};

userSchema.methods.generateAccessToken = function(){
 return Jsonwebtoken.sign({
    _id : this.id,
 },
  process.env.ACCESS_TOKEN_SECRET,
  {
    expiresIn : process.env.ACCESS_TOKEN_EXPIRY
  }
)
}

userSchema.methods.generateRefreshToken = function(){
    return Jsonwebtoken.sign({
        _id :this._id.toString(),
    },
    process.env.REFRESH_TOKEN_SECRET,
    {
        expiresIn : process.env.REFRESH_TOKEN_EXPIRY
    }


)
}
export const User = mongoose.model("user",userSchema)