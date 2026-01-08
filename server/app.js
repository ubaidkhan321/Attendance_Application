// import mongoose from "mongoose";
// import core from "cors";
// import cookieParser from "cookie-parser";
// import express from "express";

// const app = express();
// app.use(core({
//     origin: process.env.CORS_ORIGIN || "*",
//     //origin: true,
//     methods: ["GET", "POST", "PUT", "DELETE"],
//     credentials: true
// }));

// app.use(express.json({limit : "16kb"}));
// app.use(express.urlencoded({extended : true, limit : "40kb"}));
// app.use(express.static("public"));
// app.use(cookieParser());

// import route from "./routes/routes.js"
// import { errorMiddleware } from "./middlewear/error.middle.js";
// app.use("/api/v1",route);
// app.use(errorMiddleware);
// export default app

import core from "cors";
import cookieParser from "cookie-parser";
import express from "express";
import route from "./routes/routes.js"; 
import { errorMiddleware } from "./middlewear/error.middle.js";

const app = express();

app.use(core({
    origin: process.env.CORS_ORIGIN || "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
    credentials: true
}));

app.use(express.json({limit : "16kb"}));
app.use(express.urlencoded({extended : true, limit : "40kb"}));
app.use(express.static("public"));
app.use(cookieParser());


app.use("/api/v1", route);


app.use(errorMiddleware);

export default app;




