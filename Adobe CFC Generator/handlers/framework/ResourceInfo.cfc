<!---
ADOBE SYSTEMS INCORPORATED
 Copyright 2009 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the 
terms of the Adobe license agreement accompanying it.  If you have received this file from a 
source other than Adobe, then your use, modification, or distribution of it requires the prior 
written permission of Adobe.
--->

<cfcomponent name="ResourceInfo" output="false" >

	<cfset this.resourcePath = "">
	<cfset this.resourceType = "">
	
	<cffunction name="getResourceType" output="false">
		<cfreturn this.resourceType>
    </cffunction>
	
	<cffunction name="setResourceType" output="false">
		<cfargument name="type">
		<cfset this.resourceType = arguments.type>
	</cffunction>
	
	<cffunction name="getResourcePath" output="false">
		<cfreturn this.resourcePath>
    </cffunction>
	
	<cffunction name="setResourcePath" output="false">
		<cfargument name="path">
		<cfset this.resourcePath = arguments.path>
    </cffunction>
	
	<cffunction name="set" output="false">
		<cfargument name="path" type="string" required="true" >
		<cfargument name="type" type="string" required="true" >
		
		<cfset setresourcePath(arguments.path)>
		<cfset setresourceType(arguments.type)>
    </cffunction>
	
</cfcomponent>