component  displayname="Cache Bin Service"
    
    output = false

{
	
	public function getCachedItems( required string cachekey, required string wbalias )

        output = false

    {

        if ( cache.lookUp( arguments.cachekey ) ) {

            var obj = cache.get( arguments.cachekey );

            return obj;
        }

        else {
            cache.set( arguments.cachekey, application.wirebox.getInstance( arguments.wbalias ), 60,10);

            var obj = cache.get( arguments.cachekey );

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