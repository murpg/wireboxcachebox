<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Author 	 :	Luis Majano
Description :
	Your WireBox Configuration Binder
----------------------------------------------------------------------->
<cfcomponent output="false" hint="The default WireBox Injector configuration object" extends="wirebox.system.ioc.config.Binder">
<cfscript>
	
	/**
	* Configure WireBox, that's it!
	*/
	function configure(){
		
		// The WireBox configuration structure DSL
		wireBox = {
			// Scope registration, automatically register a wirebox injector instance on any CF scope
			// By default it registeres itself on application scope
			scopeRegistration = {
				enabled = true,
				scope   = "application", // server, cluster, session, application
				key		= "wireBox"
			},

			// DSL Namespace registrations
			customDSL = {
				// namespace = "mapping name"
			},
			
			// Custom Storage Scopes
			customScopes = {
				// annotationName = "mapping name"
			},
			
			// Package scan locations
			scanLocations = ['model'],
			
			// Stop Recursions
			stopRecursions = [],
			
			// Parent Injector to assign to the configured injector, this must be an object reference
			parentInjector = "",
			
			// Register all event listeners here, they are created in the specified order
			listeners = [
			// This activates AOP
				{ class="wirebox.system.aop.Mixer",properties={} }
			],
			//Declaring the Logbox Configuration Binder
			logBoxConfig = 'config.lbConfig'			
		};
		wirebox.cacheBox = {
		enabled = true, 
		configFile = "wirebox.system.cache.config.DefaultConfiguration", //An optional configuration file to use for loading CacheBox
		cacheFactory = "", //A reference to an already instantiated CacheBox CacheFactory
		classNamespace = "wirebox.system.cache" //A class path namespace to use to create CacheBox: Default=coldbox.system.cache or wirebox.system.cache
		};
		mapDirectory("model");
		// Map Bindings below
		map("myDSN").toValue("cfartgallery");
		map("KoolArt").to("model.art");
		
		map("latestNews")
	    .toRSS("http://news.google.com/news?output=rss")
	    .asEagerInit()
	    .inCacheBox(timeout=20,lastAccessTimeout=30,provider="default",key="google-news");
		//map("cachebox").to("wirebox.system.cache.CacheFactory").init("wirebox.cache.config.DefaultConfiguration",false);
		
				              
		//Let's do some AOP
		/*mapAspect("loggingMethodAspect").to("config.loggingAspects");
		bindAspect(classes=match().regex('model.logMe'),methods=match().methods('methodLogger'),aspects="loggingMethodAspect");*/

	}	
</cfscript>
</cfcomponent>