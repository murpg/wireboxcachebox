component  displayname="Test Cache"
{
	
	function getCategories(){
    var cacheKey = "google-news";
    var cache = application.wirebox.getCacheBox();
    //writeDump(application.wirebox.getInstance("latestNews"));
    writeDump(cache.getCache("google-news"));
    
    abort;
    //Check if data exists
    if( cache.lookup( cacheKey ) ){
        return cache.get( cacheKey );
    }
    
    // Else query DB and cache
    var data = application.wirebox.getinstance("latestNews");
    cache.set(cacheKey, data, 120, 20);
    
    return data;
}
	
}