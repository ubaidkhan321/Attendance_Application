import mongoose, { Schema } from "mongoose";

const attendanceSchema = new Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "user",
    required: true,
  },
  status: {
    type: String,
    enum: ["checkin", "checkout"],
    required: true,
  },
  note: { 
    type: String,
  },
}, { timestamps: true });

export const Attendance  = mongoose.model("attendance", attendanceSchema);
