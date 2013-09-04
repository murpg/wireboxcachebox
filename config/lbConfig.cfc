component  output="false"
{
	
    function configure()
     output="false"
    {
    	var read = new model.pathService();
    	var path = read.getPath('\logs');
        logBox = {
     
        appenders = {
  
            LogFile = {
                class="wirebox.system.logging.appenders.AsyncRollingFileAppender",
                properties={
                    filePath=path,
                    fileMaxSize="500",
                    autoExpand=false,
                    fileMaxArchives=20
                }
            }
  
        },
         
        categories={
                "model.artService" = {levelMAX="INFO", appenders="LogFile"},
                "model.logMe" = {levelMAX="INFO", appenders="LogFile"}
            },
             
        root = {levelMin="FATAL", levelMax="INFO", appenders="*"}
    }; 
}
  
}