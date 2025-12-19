import jsonWebToken from "jsonwebtoken";
import { asynhandler } from "../utils/ascynhandler";
import { ApiError } from "../utils/api.error";
import { User } from "../model/user.model";
import jsonWebToken  from "jsonwebtoken";

export const verifyjwt = asynhandler(async(req,res,next)=>{
    try {
      const token =
        req.cookies?.accessToken || req.header("Authorization")?.replace("Bearer ", "");
        if(!token){
            ApiError(401,"UnAuthoriazed Request");
        }
        const decodedToken = jsonWebToken.verify(
            token,
            process.env.ACCESS_TOKEN_SECRET
        );
        const fonduser = await User.findById(decodedToken?._id).select("-password -refreshToken");
        if(!fonduser){
            new ApiError(401,"Invalid Access Token");
        }
        req.User = fonduser;
        next();
    } catch (error) {
        console.log(error)
        throw new ApiError(401, error.message || "Invlaid Access Token");
    }
})