import { asynhandler } from "../utils/ascynhandler.js";
import {User} from "../model/user.model.js"
import { ApiError } from "../utils/api.error.js";
import {ApiResponse} from "../utils/api.response.js"
import jsonwebtoken  from "jsonwebtoken";
import { Attendance  } from "../model/attendance.model.js";
//import moment from "moment";
import { AttendanceRule } from "../model/attendanceRule.model.js";
import mongoose from "mongoose";
import crypto from "crypto";
import moment from "moment-timezone";
import cron from 'node-cron';

const generateTokens  = async(userId)=>{
    const users = await User.findById(userId);
    if(!users){
       new ApiError(404,"User not Found");
    }
    const genaccessToken = users.generateAccessToken();
    const genrefreshToken = users.generateRefreshToken();
    users.refreshToken = genrefreshToken;
    await users.save({validateBeforeSave : false});

    return {
  accessToken: genaccessToken,
  refreshToken: genrefreshToken
}

}
const refreshTokenMethod = asynhandler(async(req, _)=>{
    const incomingToken = req.cookies.refreshToken || req.body.refreshToken;
    if(!incomingToken){
      throw new ApiError(401,"Unauthorized request")
    }
    let decoded; 
    try {
       decoded = jsonwebtoken.verify(
            incomingToken,
            process.env.REFRESH_TOKEN_SECRET
        );
        
    } catch (error) {
        return new ApiError(401 ,"Invalid Refresh Token");
    }
    const existingUser =  await User.findById(decoded?._id);
    if(!existingUser){
        new ApiError(401, "Invalid Refresh Token request");

    }
    if(incomingToken !== existingUser.refreshToken){
        return new ApiError(401, "Refresh Token is Expire")
    }

   const newAccessToken =  existingUser.generateAccessToken();
   return res.status(200).cookie("AccessToken", newAccessToken, {
    httpOnly : true,
    secure : true,
    sameSite : "lax"
   }).json(
    new ApiResponse(200,{accessToken: newAccessToken},"New AccessToken Genrated")
   )
});

const register = asynhandler(async(req,res)=> {
    
    const {email,password,name} = req.body;
    console.log("email", email);
    if([email,password,name].some(field =>!field?.trim() )){
       throw new ApiError(401, "All fields are required")
    }
   
  if(await User.findOne({email})){
    throw new ApiError(401, "Email already exists")
  }
    const newUser = await User.create({
    email,
    password,
    name
  });
  const createduser = await User.findById(newUser._id).select("-password -refreshToken");
    if (!createduser) {
    throw new ApiError(401, "FAILED REGISTER USER")
  }
  return res.
  status(200).
  json(
    new ApiResponse(200,[createduser],"User Registered Successfully")
  )
});
const loginUser = asynhandler(async (req, res) => {
  const { name, password } = req.body;

  const currentuser = await User.findOne({ name });
  if (!currentuser) throw new ApiError(401, "User Doesn't Exits");

  const checkPassword = await currentuser.ispasswordCorrect(password);
  if (!checkPassword) throw new ApiError(401, "password is Wrong");

  
  const { accessToken, refreshToken } = await generateTokens(currentuser._id);

  const loggedUser = await User.findById(currentuser._id).select("-password");

  const option = {
    httpOnly: true,
    secure: false,
    sameSite: "lax",
  };

  return res
  .status(200)
  .cookie("accessToken", accessToken, option)
  .cookie("refreshToken", refreshToken, option)
  .json({
    statusCode: 200,
     message: "User Logged In Successfully",
    
    Data: 
      {
        accessToken,
        refreshToken,
        ...loggedUser.toObject(),

      }
    
    
   
  });

});

const addAttendanceRule = asynhandler(async (req, res) => {
  const { label, start, end, ruleType, statusType } = req.body;

  
  if (!label) {
    throw new ApiError(400, "Label is required");
  }

  
  const allowedRuleTypes = ["default", "special"];
  const type = ruleType || "default";
  if (!allowedRuleTypes.includes(type)) {
    throw new ApiError(400, "Invalid ruleType (use 'default' or 'special')");
  }

  
  const allowedStatusTypes = ["checkin", "checkout"];
  if (!statusType || !allowedStatusTypes.includes(statusType)) {
    throw new ApiError(400, "Invalid statusType (use 'checkin' or 'checkout')");
  }

  
  const timeFormat = /^\d{2}:\d{2}$/;
  if (start && !timeFormat.test(start)) {
    throw new ApiError(400, "Start time must be in HH:mm format");
  }
  if (end && !timeFormat.test(end)) {
    throw new ApiError(400, "End time must be in HH:mm format");
  }
  
  const existingRule = await AttendanceRule.findOne({ 
    label, 
    ruleType: type, 
    statusType 
  });

  if (existingRule) {
    return res.status(400).json({
      statusCode: 400,
      message: `Attendance rule already exists for ${statusType} (${type})`,
      
    });
  }
  
  const newRule = await AttendanceRule.create({
    label,
    start,
    end,
    ruleType: type,
    statusType,
  });

  return res.status(200).json({
    statusCode: 200,
    message: `Attendance ${statusType} rule added successfully`,
    rule: newRule,
  });
});






const checkInAttendance = asynhandler(async (req, res) => {
  const { user_Id } = req.body;
  const currentDay = moment().tz("Asia/Karachi").format("dddd");

  if (currentDay === "Sunday") {
     throw new ApiError(400, "Today is Holiday");
  }

  if (!user_Id) throw new ApiError(400, "user_Id is required");
  if (!mongoose.Types.ObjectId.isValid(user_Id))
    throw new ApiError(400, "Invalid user_Id format");

  const user = await User.findById(user_Id);
  if (!user) throw new ApiError(404, "User does not exist");

  const todayStart = moment().tz("Asia/Karachi").startOf("day").toDate();
  const todayEnd = moment().tz("Asia/Karachi").endOf("day").toDate();

  const existingCheckIn = await Attendance.findOne({
    user: user_Id,
    status: "checkin",
    createdAt: { $gte: todayStart, $lte: todayEnd },
  });

  if (existingCheckIn) {
    return res.status(400).json({
      statusCode: 400,
      message: "You already checked in today",
    });
  }

  const defaultRules = await AttendanceRule.find({
    ruleType: "default",
    statusType: "checkin",
  }).sort({ start: 1 });

  const specialRules = await AttendanceRule.find({
    ruleType: "special",
    statusType: "checkin",
  }).sort({ start: 1 });

  const currentTime = moment().tz("Asia/Karachi").format("HH:mm");
  const specialUserId = "692e88a450a5c580f6251320";

  let attendanceStatus = "Absent";   
  let appliedRuleType = "default";

  
  const matchRule = (rules) => {
    for (const rule of rules) {
      const start = rule.start || "00:00";
      const end = rule.end || "23:59";

      if (currentTime >= start && currentTime <= end) {
        return rule.label;
      }
    }
    return null;
  };

  
  if (user_Id.toString() === specialUserId.toString()) {
    const specialMatch = matchRule(specialRules);
    if (specialMatch) {
      attendanceStatus = specialMatch;
      appliedRuleType = "special";
    } else {
      
      const defaultMatch = matchRule(defaultRules);
      if (defaultMatch) {
        attendanceStatus = defaultMatch;
        appliedRuleType = "default";
      }
    }
  } 
  
  else {
    const defaultMatch = matchRule(defaultRules);
    if (defaultMatch) {
      attendanceStatus = defaultMatch;
      appliedRuleType = "default";
    }
  }

  
  const newAttendance = await Attendance.create({
    user: user_Id,
    status: "checkin",
    note: attendanceStatus,
  });

  const createdAtPK = moment(newAttendance.createdAt)
    .tz("Asia/Karachi")
    .format("YYYY-MM-DD HH:mm:ss");

  const updatedAtPK = moment(newAttendance.updatedAt)
    .tz("Asia/Karachi")
    .format("YYYY-MM-DD HH:mm:ss");

  return res.status(200).json({
    statusCode: 200,
    message: `Check-in successful (${attendanceStatus})`,
    attendance: {
      ...newAttendance.toObject(),
      createdAt: createdAtPK,
      updatedAt: updatedAtPK,
      ruleType: appliedRuleType,
    },
  });
});



const checkOutAttendance = asynhandler(async (req, res) => {
  const { user_Id } = req.body;

  if (!user_Id) {
    throw new ApiError(400, "user_Id is required");
  }

  if (!mongoose.Types.ObjectId.isValid(user_Id)) {
    throw new ApiError(400, "Invalid user_Id format");
  }

  const user = await User.findById(user_Id);
  if (!user) {
    throw new ApiError(404, "User does not exist");
  }

  const todayStart = moment().tz("Asia/Karachi").startOf("day").toDate();
  const todayEnd = moment().tz("Asia/Karachi").endOf("day").toDate();

  
  const existingCheckIn = await Attendance.findOne({
    user: user_Id,
    status: "checkin",
    createdAt: { $gte: todayStart, $lte: todayEnd },
  });

  if (!existingCheckIn) {
    return res.status(400).json({
      statusCode: 400,
      message: "You cannot checkout before checking in",
    });
  }

  if (existingCheckIn.note === "Absent") {
    return res.status(400).json({
      statusCode: 400,
      message: "You are marked absent, checkout not allowed",
    });
  }

  
  const existingCheckOut = await Attendance.findOne({
    user: user_Id,
    status: "checkout",
    createdAt: { $gte: todayStart, $lte: todayEnd },
  });

  if (existingCheckOut) {
    return res.status(400).json({
      statusCode: 400,
      message: "You already checked out today",
    });
  }

  const currentTime = moment().tz("Asia/Karachi").format("HH:mm");
  const currentDay = moment().tz("Asia/Karachi").format("dddd");

  if (currentTime < "13:01") {
    return res.status(400).json({
      statusCode: 400,
      message: "You cannot checkout before 1:00 PM",
    });
  }

  
  const defaultRules = await AttendanceRule.find({
    ruleType: "default",
    statusType: "checkout",
  }).sort({ start: 1 });

  const specialRules = await AttendanceRule.find({
    ruleType: "special",
    statusType: "checkout",
  }).sort({ start: 1 });

  let attendanceStatus = "No Rule Found";
  let appliedRuleType = "default";
  const specialUserId = "692e88a450a5c580f6251320"; 

  let ruleToUse = defaultRules;
  if (user_Id.toString() === specialUserId.toString() && specialRules.length > 0) {
    ruleToUse = specialRules;
    appliedRuleType = "special";
  }

  let matched = false;

  
  if (currentDay === "Saturday") {
    
    if (currentTime >= "18:00") {
      attendanceStatus = "Late Sitting";
      matched = true;
    } 
    
    else if (currentTime >= "16:40" && currentTime <= "17:00") {
      attendanceStatus = "On Time";
      matched = true;
    }
    
  }

 
  if (!matched) {
    for (const rule of ruleToUse) {
      const start = rule.start || "00:00";
      const end = rule.end || "23:59";

      if (currentTime >= start && currentTime <= end) {
        attendanceStatus = rule.label;
        matched = true;
        break;
      }
    }
  }

  
  if (!matched) {
    if (currentTime >= "20:00") {
      attendanceStatus = "Late Sitting";
    } else if (currentTime < "15:01") {
      attendanceStatus = "Absent";
    } else {
      attendanceStatus = "Early going"; 
    }
  }

  // 4. Create Record
  const newAttendance = await Attendance.create({
    user: user_Id,
    status: "checkout",
    note: attendanceStatus,
  });

  const createdAtPK = moment(newAttendance.createdAt).tz("Asia/Karachi").format("YYYY-MM-DD HH:mm:ss");
  const updatedAtPK = moment(newAttendance.updatedAt).tz("Asia/Karachi").format("YYYY-MM-DD HH:mm:ss");

  return res.status(200).json({
    statusCode: 200,
    message: `Checkout successful (${attendanceStatus})`,
    attendance: {
      ...newAttendance.toObject(),
      createdAt: createdAtPK,
      updatedAt: updatedAtPK,
      ruleType: appliedRuleType,
      day: currentDay
    },
  });
});

// const checkOutAttendance = asynhandler(async (req, res) => {
//   const { user_Id } = req.body;

//   if (!user_Id) {
//     throw new ApiError(400, "user_Id is required");
//   }

//   if (!mongoose.Types.ObjectId.isValid(user_Id)) {
//     throw new ApiError(400, "Invalid user_Id format");
//   }

//   const user = await User.findById(user_Id);
//   if (!user) {
//     throw new ApiError(404, "User does not exist");
//   }

 
//   const todayStart = moment().tz("Asia/Karachi").startOf("day").toDate();
//   const todayEnd = moment().tz("Asia/Karachi").endOf("day").toDate();

  
//   const existingCheckIn = await Attendance.findOne({
//     user: user_Id,
//     status: "checkin",
//     createdAt: { $gte: todayStart, $lte: todayEnd },
//   });

//   if (!existingCheckIn) {
//     return res.status(400).json({
//       statusCode: 400,
//       message: "You cannot checkout before checking in",
//     });
//   }
//   if (existingCheckIn.note === "Absent") {
//   return res.status(400).json({
//     statusCode: 400,
//     message: "You are marked absent, checkout not allowed",
//   });
// }
   
   

  
//   const existingCheckOut = await Attendance.findOne({
//     user: user_Id,
//     status: "checkout",
//     createdAt: { $gte: todayStart, $lte: todayEnd },
//   });

//   if (existingCheckOut) {
//     return res.status(400).json({
//       statusCode: 400,
//       message: "You already checked out today",
//     });
//   }
//   const CheckoutTime = moment().tz("Asia/Karachi").format("HH:mm");
  
//   if (CheckoutTime < "13:01") {
//   return res.status(400).json({
//     statusCode: 400,
//     message: "You cannot checkout before 1:00 PM",
//   });
// }


  
//   const defaultRules = await AttendanceRule.find({
//     ruleType: "default",
//     statusType: "checkout",
//   }).sort({ start: 1 });

  
//   const specialRules = await AttendanceRule.find({
//     ruleType: "special",
//     statusType: "checkout",
//   }).sort({ start: 1 });

//   //const currentTime = moment().format("HH:mm");
//   const currentTime = moment().tz("Asia/Karachi").format("HH:mm");
//   let attendanceStatus = "On Time";
//   let appliedRuleType = "default";

//   const specialUserId = "692e88a450a5c580f6251320"; 

  
//   let ruleToUse = defaultRules;
//   if (user_Id.toString() === specialUserId.toString() && specialRules.length > 0) {
//     ruleToUse = specialRules;
//     appliedRuleType = "special";
//   }
// let matched = false;
  
//   for (const rule of ruleToUse) {
//     const start = rule.start || "00:00";
//     const end = rule.end || "23:59";

//     if (currentTime >= start && currentTime <= end) {
//       attendanceStatus = rule.label;
//       matched = true;
//       break;
//     }
//   }

//  if (!matched) {
//   if (currentTime < "15:01") {
//     attendanceStatus = "Absent";   
//   } else {
//     attendanceStatus = "No Rule Found";
//   }
// }


  
//   const newAttendance = await Attendance.create({
//     user: user_Id,
//     status: "checkout",
//     note: attendanceStatus,
//   });
//     const createdAtPK = moment(newAttendance.createdAt)
//     .tz("Asia/Karachi")
//     .format("YYYY-MM-DD HH:mm:ss");

//   const updatedAtPK = moment(newAttendance.updatedAt)
//     .tz("Asia/Karachi")
//     .format("YYYY-MM-DD HH:mm:ss");

//   return res.status(200).json({
//     statusCode: 200,
//     message: `Checkout successful (${attendanceStatus})`,
//     attendance: {
//       ...newAttendance.toObject(),
//       createdAt: createdAtPK,
//       updatedAt: updatedAtPK,
//       ruleType: appliedRuleType,
//     },
//   });
// });

// const getuserAttendance = asynhandler(async (req, res) => {
//   const { user_Id } = req.body;

//   if (!mongoose.Types.ObjectId.isValid(user_Id)) {
//     throw new ApiError(400, "Invalid userId");
//   }

//   const user = await User.findById(user_Id);
//   if (!user) {
//     throw new ApiError(404, "User does not exist");
//   }

  
//   const today = new Date();
//   const currentMonth = today.getMonth(); 
//   const currentYear = today.getFullYear();

  
//   const startDate = new Date(currentYear, currentMonth - 1, 25, 0, 0, 0); 
  
//   const endDate = new Date(currentYear, currentMonth, 25, 23, 59, 59);

//   const attendance = await Attendance.find({
//     user: user_Id,
//     createdAt: { $gte: startDate, $lte: endDate },
//   }).sort({ createdAt: -1 });

//   if (!attendance || attendance.length === 0) {
//     return res.status(200).json({
//       statusCode: 200,
//       message: `No Attendance record found`,
//       attendance: [],
//     });
//   }

//   res.status(200).json({
//     statusCode: 200,
//     message: "Attendance fetched successfully",
//     attendance,
//   });
// });

const getuserAttendance = asynhandler(async (req, res) => {
  const { user_Id, startDate, endDate } = req.body;

  
  if (!mongoose.Types.ObjectId.isValid(user_Id)) {
    throw new ApiError(400, "Invalid userId");
  }

  const user = await User.findById(user_Id);
  if (!user) {
    throw new ApiError(404, "User does not exist");
  }

  
  if (!startDate || !endDate) {
    throw new ApiError(400, "startDate and endDate are required");
  }
 

  const start = new Date(startDate);
  const end = new Date(endDate);

  
  if (isNaN(start.getTime()) || isNaN(end.getTime())) {
    throw new ApiError(400, "Invalid date format");
  }

   if(start > endDate){
     throw new ApiError(400, "startDate cannot be greater than endDate");
  }

  
  end.setHours(23, 59, 59, 999);

  
  const attendance = await Attendance.find({
    user: user_Id,
    createdAt: {
      $gte: start,
      $lte: end,
    },
  }).sort({ createdAt: -1 });

  if (!attendance.length) {
    return res.status(200).json({
      statusCode: 200,
      message: "No Attendance record found",
      attendance: [],
    });
  }

  res.status(200).json({
    statusCode: 200,
    message: "Attendance fetched successfully",
    attendance,
  });
});


const deleteOldAttendance = asynhandler(async (_, res) => {
  const now = new Date();
  const currentMonthStart = new Date(now.getFullYear(), now.getMonth(), 1);
  const prevMonthStart = new Date(now.getFullYear(), now.getMonth() - 1, 1);
  const prevMonthEnd = new Date(now.getFullYear(), now.getMonth(), 0);
  const deleteResult = await Attendance.deleteMany({
    createdAt: { $lt: prevMonthStart }
  });

  return res.status(200).json({
    statusCode: 200,
    message: "Old attendance deleted successfully",
    previousMonthKept: {
      from: prevMonthStart,
      to: prevMonthEnd,
    },
    currentMonthStart: currentMonthStart,
    deletedCount: deleteResult.deletedCount,
  });
});




const generateResetPassword = asynhandler(async (req, res) => {
  const { name, email } = req.body;

  if (!name) {
    throw new ApiError(400, "Name are required");
  }
  if (!email) {
    throw new ApiError(400, "Email are required");
  }

  const user = await User.findOne({ name, email });

  if (!user) {
    throw new ApiError(404, "User with this name and email not found");
  }

  const resetToken = crypto.randomBytes(20).toString("hex");

  user.resetPasswordToken = resetToken;
  user.resetPasswordExpiry = Date.now() + 10 * 60 * 1000;

  await user.save({ validateBeforeSave: false });

  return res.status(200).json(
    new ApiResponse(
      200,
      [resetToken ],
      "Reset token generated successfully"
    )
  );
});


const resetPassword = asynhandler(async (req, res) => {
  const { token, newPassword } = req.body;

  if (!token || !newPassword) {
    throw new ApiError(400, "Token and new password are required");
  }

  const user = await User.findOne({
    resetPasswordToken: token,
    resetPasswordExpiry: { $gt: Date.now() }
  });

  if (!user) {
    throw new ApiError(400, "Invalid or expired reset token");
  }

  
  user.password = newPassword;

  
  user.resetPasswordToken = null;
  user.resetPasswordExpiry = null;

  await user.save();

  return res.status(200).json(
    new ApiResponse(200, "Password reset successfully")
  );
});



const startAbsentCronJob = () => {
    
    cron.schedule('37 18 * * *', async () => {
        const tz = "Asia/Karachi";
        const now = moment().tz(tz);
        
        
        if (now.format("dddd") === "Sunday") {
            console.log("Today is Sunday, skipping.");
            return;
        }

        try {
            console.log(`[${now.format()}] TEST Cron Job: Starting now...`);

            const todayStart = moment.tz(tz).startOf("day").toDate();
            const todayEnd = moment.tz(tz).endOf("day").toDate();

            const allUsers = await User.find({});
            console.log(`Total users in DB: ${allUsers.length}`);

            let count = 0;

            for (const user of allUsers) {
                const existingRecord = await Attendance.findOne({
                    user: user._id,
                    createdAt: { $gte: todayStart, $lte: todayEnd }
                });

                if (!existingRecord) {
                    await Attendance.create({
                        user: user._id,
                        status: "checkin",
                        note: "Absent",
                        ruleType: "default"
                    });
                    count++;
                }
            }
            
            console.log(`TEST Success: ${count} users marked absent.`);
        } catch (error) {
            console.error("Cron Job Error:", error);
        }
    }, {
        scheduled: true,
        timezone: "Asia/Karachi"
    });
};












export{register,loginUser,refreshTokenMethod,checkInAttendance,addAttendanceRule,checkOutAttendance,getuserAttendance,deleteOldAttendance,generateResetPassword,resetPassword,startAbsentCronJob}   