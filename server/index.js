import mongoose from "mongoose";
import app  from "./app.js";
import { DataBaseName } from "./constant.js";
import dotenv from "dotenv";
import { startAbsentCronJob } from "./controller/user_controller.js";

dotenv.config({ path: '../.env' }); 


const PORT = process.env.PORT || 8000;
(async()=>{
    try {
        await mongoose.connect(`${process.env.MONGOOSE_URL}/${process.env.DataBaseName}`);
        console.log("Mongoos connected"),
        startAbsentCronJob();
        console.log("Cron Job for Absent Marking is Running...");
        app.on('error',function(error){
            console.log("Error", error);
            throw error
        });
        if (process.env.NODE_ENV !== 'production') {
    app.listen(PORT, "0.0.0.0",() => {
        console.log(`Server is Running on port ${process.env.PORT}`)
    });
}
        
        
    } catch (error) {
        console.error(error);
        throw error;
    }
})()




export default app;