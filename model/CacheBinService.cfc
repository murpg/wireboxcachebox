component  displayname="Cache Bin Service"
    
    output = false

{
	//property name="cachetwo" inject="cachebox:cache";

	public function getCachedItems( required string cachekey, required string wbalias )

        output = false

    {
        var obj = cache.get( arguments.cachekey );

        if( isNull( obj ) ) {

            cache.set( arguments.cachekey, application.wirebox.getInstance( arguments.wbalias ), 60,10);

            var obj = cache.get( arguments.cachekey );

            return obj;
        }
        else {
            return obj;
        }
  

    }

	public CacheBinService function init () 

            output = false

    {

        variables.cache = application.wirebox.getCacheBox().getDefaultCache();

        return this;

    }

}