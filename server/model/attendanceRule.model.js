import mongoose, { Schema } from "mongoose";

const attendanceRuleSchema = new Schema({
  label: { type: String, required: true },   
  start: { type: String },                   
  end: { type: String },
  
   ruleType: { 
    type: String, 
    enum: ["default", "special"], 
    default: "default" 
  },

  statusType: {
  type: String,
  enum: ["checkin", "checkout"],
  required: true,
}

});

export const AttendanceRule = mongoose.model("AttendanceRule", attendanceRuleSchema);
