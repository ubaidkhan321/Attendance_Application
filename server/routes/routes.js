import { Router } from "express";
import { addAttendanceRule, checkInAttendance, checkOutAttendance, deleteOldAttendance, generateResetPassword, getuserAttendance, loginUser, refreshTokenMethod, register, resetPassword } from "../controller/user_controller.js";
import { upload } from "../middlewear/multer.js";

const routes = Router()
routes.route("/register").post(upload.none(),register)
routes.route("/login").post(upload.none(),loginUser)
routes.route("/refreshToken").post(upload.none(), refreshTokenMethod)
routes.route("/checkIn").post(upload.none(),checkInAttendance)
routes.route("/rule/add").post(upload.none(),addAttendanceRule)
routes.route("/checkOut").post(upload.none(),checkOutAttendance)
routes.route("/get-Attendace").post(upload.none(),getuserAttendance)
routes.route("/delete-Attendace").post(deleteOldAttendance)
routes.route("/forgot-password").post(upload.none(),generateResetPassword)
routes.route("/reset-password").post(upload.none(),resetPassword)



export default routes;