class ApiError extends Error{
  constructor(
    statusCode,
    message = "something went wrong",
    error = [],
    stack = ""

  ){
   super(message)
   this.message = message,
   this.statusCode = statusCode, 
   this.success = false,
   this.error = error,
   this.data = null
    
   if(stack){
    this.stack = this.stack
   }else{
    Error.captureStackTrace(this,this.constructor)
   }
  }
}
export {ApiError}