import mongoose from "mongoose";
import app  from "./app.js";
import { DataBaseName } from "./constant.js";
import dotenv from "dotenv";


dotenv.config({ path: '../.env' }); 


const PORT = process.env.PORT || 8000;
(async()=>{
    try {
        await mongoose.connect(`${process.env.MONGOOSE_URL}/${DataBaseName}`);
        console.log("Mongoos connected"),
        
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




// import mongoose from "mongoose";
// import app from "./app.js";
// import dotenv from "dotenv";
// import { DataBaseName } from "./constant.js";

// dotenv.config({ path: '../.env' });

// console.log("--- ENV CHECK ---");
// console.log("URL:", process.env.MONGOOSE_URL);
// console.log("DB Name from constant:", DataBaseName);
// console.log("-----------------");

// const connectDB = async () => {
//     if (!process.env.MONGOOSE_URL) {
//         console.error("Error: MONGOOSE_URL is still undefined!");
//         return;
//     }
//     try {
//         await mongoose.connect(`${process.env.MONGOOSE_URL}/${DataBaseName}`);
//         console.log("MongoDB connected");
//     } catch (error) {
//         console.error("MongoDB Connection Error:", error);
//     }
// };

// connectDB();
export default app;