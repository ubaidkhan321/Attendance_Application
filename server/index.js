// import mongoose from "mongoose";
// import app  from "./app.js";
// import { DataBaseName } from "./constant.js";
// import dotenv from "dotenv";
// dotenv.config({ path: '../.env' }); 

// const PORT = process.env.PORT || 8000;
// (async()=>{
//     try {
//         mongoose.connect(`${process.env.MONGOOSE_URL}/${process.env.DataBaseName}`),
//         console.log("Mongoos connected"),
//         app.on('error',function(error){
//             console.log("Error", error);
//             throw error
//         }),
//         app.listen(PORT, "0.0.0.0",()=>{
//             console.log(`Server is Running on port ${process.env.PORT}`)
//         })
        
//     } catch (error) {
//         console.error(error);
//         throw error;
//     }
// })()

import mongoose from "mongoose";
import app from "./app.js";
import dotenv from "dotenv";
import { DataBaseName } from "./constant.js";

dotenv.config(); 


const connectDB = async () => {
    if (mongoose.connection.readyState >= 1) return; 
    try {
        await mongoose.connect(`${process.env.MONGOOSE_URL}/${DataBaseName}`);
        console.log("MongoDB connected");
    } catch (error) {
        console.error("MongoDB Connection Error:", error);
    }
};


app.use(async (req, res, next) => {
    await connectDB();
    next();
});


export default app;